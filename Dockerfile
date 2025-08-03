FROM php:8.2-apache

ENV DEBIAN_FRONTEND=noninteractive

# ----------------------------
# Install system packages and PHP extensions
# ----------------------------
RUN apt-get update && apt-get install -y \
    unzip curl git libzip-dev zip libonig-dev \
    && docker-php-ext-install pdo_mysql zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# ----------------------------
# Enable Apache mod_rewrite
# ----------------------------
RUN a2enmod rewrite

# ----------------------------
# Install Composer from official Composer image
# ----------------------------
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# ----------------------------
# Set working directory
# ----------------------------
WORKDIR /var/www/html

# ----------------------------
# Copy source code to the container
# ----------------------------
COPY . .

# ----------------------------
# Ensure permissions are safe
# ----------------------------
RUN chown -R www-data:www-data /var/www/html

# ----------------------------
# Install PHP dependencies
# Must be run as root or same user who owns files
# ----------------------------
RUN composer install --no-interaction --prefer-dist --no-dev

# ----------------------------
# Change Apache to listen on port 8080 instead of 80
# ----------------------------
RUN sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf && \
    sed -i 's/<VirtualHost \*:80>/<VirtualHost \*:8080>/' /etc/apache2/sites-available/000-default.conf

# ----------------------------
# Expose Apache port
# ----------------------------
EXPOSE 8080

# ----------------------------
# Add healthcheck (optional)
# ----------------------------
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:8080/ || exit 1

