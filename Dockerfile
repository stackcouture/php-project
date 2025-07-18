FROM php:8.2-apache

# Install MySQLi and unzip for Composer
RUN docker-php-ext-install mysqli && apt-get update && apt-get install -y unzip

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Install Composer globally
COPY --from=composer:2.7 /usr/bin/composer /usr/bin/composer

# Set workdir
WORKDIR /var/www/html