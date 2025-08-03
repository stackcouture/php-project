FROM php:8.2-apache

# Set environment variable for non-interactive apt installs
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages and PHP extensions
RUN apt-get update && apt-get install -y \
    unzip \
    curl \
    git \
    libzip-dev \
    libonig-dev \
  && docker-php-ext-install pdo_mysql zip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Install Composer globally (copy from official composer image)
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy application source code
COPY ./src /var/www/html

# Install AWS SDK for PHP via Composer
RUN composer require aws/aws-sdk-php --no-interaction --prefer-dist --optimize-autoloader

# Fix permissions for www-data user
RUN chown -R www-data:www-data /var/www/html

# Change Apache to listen on port 8080 instead of 80
RUN sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf \
 && sed -i 's/<VirtualHost \*:80>/<VirtualHost \*:8080>/' /etc/apache2/sites-available/000-default.conf

# Expose port 8080 for container
EXPOSE 8080

# Healthcheck to verify container is serving the app
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl --fail http://localhost:8080/ || exit 1
