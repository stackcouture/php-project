FROM php:8.2-apache

# Set environment variables for non-interactive apt installs
ENV DEBIAN_FRONTEND=noninteractive

# Install MySQLi and unzip for Composer
RUN apt-get update && apt-get install -y \
    unzip \
    curl \
    libzip-dev \
    && docker-php-ext-install mysqli \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Install Composer globally
COPY --from=composer:2.7 /usr/bin/composer /usr/bin/composer

# Create a non-root user and group
RUN groupadd -g 1000 appuser \
    && useradd -u 1000 -g appuser -m -s /bin/bash appuser

# Change ownership of Apache web root to the non-root user
RUN chown -R appuser:appuser /var/www/html \
    /var/log/apache2 /var/lock/apache2 /var/run/apache2


# Change Apache user and group to appuser
RUN sed -i 's/APACHE_RUN_USER=.*/APACHE_RUN_USER=appuser/' /etc/apache2/envvars && \
    sed -i 's/APACHE_RUN_GROUP=.*/APACHE_RUN_GROUP=appuser/' /etc/apache2/envvars

# Change Apache to listen on port 8080
RUN sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf && \
    sed -i 's/<VirtualHost \*:80>/<VirtualHost \*:8080>/' /etc/apache2/sites-available/000-default.conf

# Expose port 8080
EXPOSE 8080

# Switch to non-root user
USER appuser

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl --fail http://localhost:8080/ || exit 1

# Set workdir
WORKDIR /var/www/html