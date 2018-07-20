FROM php-swoole/php-swoole:latest

RUN apt-get update && apt-get install -y git \
        apache2-utils

RUN curl -sS https://getcomposer.org/installer \
    | php -- --install-dir=/usr/bin --filename=composer

CMD "tail -f /dev/null"
