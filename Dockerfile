FROM php:8.2-apache

ENV DEBIAN_FRONTEND=noninteractive

# Install system packages and PHP extensions
RUN apt-get update && apt-get install -y \
    unzip curl git libzip-dev zip \
    && docker-php-ext-install pdo_mysql zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Enable mod_rewrite
RUN a2enmod rewrite

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set workdir and copy app
WORKDIR /var/www/html

# Copy source files
COPY . /var/www/html

# Install PHP dependencies
RUN composer install --no-interaction --prefer-dist --no-dev

# Set permissions (optional)
RUN chown -R www-data:www-data /var/www/html

RUN sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf && \
    sed -i 's/<VirtualHost \*:80>/<VirtualHost \*:8080>/' /etc/apache2/sites-available/000-default.conf

# Expose Apache port
EXPOSE 8080

# Healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:8080/ || exit 1