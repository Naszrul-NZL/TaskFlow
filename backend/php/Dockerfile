FROM php:8.2-apache

RUN apt-get update && apt-get install -y libsqlite3-dev

RUN docker-php-ext-install pdo_sqlite

RUN a2enmod rewrite

RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

WORKDIR /var/www/html