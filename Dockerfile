FROM php:8.2-apache

ENV DEBIAN_FRONTEND=noninteractive

# Install PHP extensions and system tools
RUN apt-get update && apt-get install -y \
    unzip curl git libzip-dev zip \
    && docker-php-ext-install pdo_mysql zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Install Composer from official image
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy composer files first to optimize layer caching
COPY composer.json composer.lock ./

# Install dependencies inside the container
RUN composer install --no-interaction --prefer-dist --no-dev --optimize-autoloader

# Copy full project source (after install to avoid cache busting)
COPY . .

# Optional: Fix permissions for Apache
RUN chown -R www-data:www-data /var/www/html

# Change Apache port from 80 to 8080
RUN sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf && \
    sed -i 's/<VirtualHost \*:80>/<VirtualHost \*:8080>/' /etc/apache2/sites-available/000-default.conf

# Expose container port
EXPOSE 8080

# Health check to ensure container is responsive
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:8080/ || exit 1
