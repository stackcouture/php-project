# Stage 1: Builder - for composer install only
FROM php:8.2-cli AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y zip unzip libzip-dev \
 && docker-php-ext-install zip \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /app

COPY composer.json composer.lock ./
RUN composer install --no-dev --prefer-dist --no-interaction --optimize-autoloader \
 && rm -rf /root/.composer/cache

COPY ./src ./src
RUN chown -R www-data:www-data /app


# Stage 2: Runtime - Apache + PHP + required extensions
FROM php:8.2-apache

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y libzip-dev zip unzip \
 && docker-php-ext-install pdo_mysql mysqli zip \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN a2enmod rewrite \
 && echo "ServerName localhost" >> /etc/apache2/apache2.conf \
 && sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/src|g' /etc/apache2/sites-available/000-default.conf \
 && sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf \
 && sed -i 's/<VirtualHost \*:80>/<VirtualHost \*:8080>/' /etc/apache2/sites-available/000-default.conf

WORKDIR /var/www/html

COPY --from=builder /app /var/www/html

RUN chown -R www-data:www-data /var/www/html

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:8080/ || exit 1
