FROM php:8.3.0-fpm-alpine
RUN apk add --no-cache libcurl git nodejs npm
RUN docker-php-ext-install mysqli pdo_mysql
RUN EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')" && \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")" && \
    [ "$EXPECTED_CHECKSUM" = "$ACTUAL_CHECKSUM" ] && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer
COPY php.ini /usr/local/etc/php/php.ini
