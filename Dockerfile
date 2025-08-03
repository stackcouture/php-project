FROM php:8.2-apache

# Set environment variable to prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages and PHP extensions
RUN apt-get update && apt-get install -y \
    unzip \
    curl \
    git \
    libzip-dev \
    libonig-dev \
    libssl-dev \
    zlib1g-dev \
 && docker-php-ext-install pdo_mysql zip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Enable Apache modules
RUN a2enmod rewrite

# Fix "Could not reliably determine the server's fully qualified domain name" warning
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Install Composer globally
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy only composer files first to leverage Docker layer caching
COPY ./composer.json ./composer.lock ./

# Install dependencies
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Copy application source code (after dependencies to improve cache)
COPY ./src/ /var/www/html/

# Fix permissions (optional, depends on deployment)
RUN chown -R www-data:www-data /var/www/html

# Configure Apache to listen on port 8080
RUN sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf \
 && sed -i 's/<VirtualHost \*:80>/<VirtualHost \*:8080>/' /etc/apache2/sites-available/000-default.conf

# Expose the custom port
EXPOSE 8080

# Health check to ensure the container is serving properly
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl --fail http://localhost:8080/ || exit 1
