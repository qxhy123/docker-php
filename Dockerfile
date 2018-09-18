FROM php:7.2.7-cli-alpine3.7
# Install modules
RUN apk update && apk add \
        imagemagick \
        libevent-dev \
        freetype-dev \
        libjpeg-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libxml2 \
        libxml2-dev \
        libmemcached-dev \
        openssl \
        openssl-dev \
        gdb \
        vim \
        wget \
        git \
        make \
        gcc \
        build-base \
        yaml \
        yaml-dev \
        autoconf

RUN cd /tmp \
    && wget -q -O hiredis-0.13.3.tar.gz https://github.com/redis/hiredis/archive/v0.13.3.tar.gz \
    && tar zxvf hiredis-0.13.3.tar.gz \
    && cd hiredis-0.13.3 \
    && make \
    && make install \
    && docker-php-ext-install bcmath pdo_mysql mysqli pcntl soap opcache zip\
    && docker-php-ext-enable pdo_mysql \
    && docker-php-ext-enable mysqli \
    && docker-php-ext-enable pcntl \
    && docker-php-ext-enable opcache \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install redis-3.1.2 \
    && docker-php-ext-enable redis \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb \
    && pecl install memcached-3.0.4 \
    && docker-php-ext-enable memcached \
    && pecl install igbinary-2.0.5 \
    && docker-php-ext-enable igbinary \
    && pecl install inotify-2.0.0 \
    && docker-php-ext-enable inotify \
    && pecl install yaml-2.0.0 \
    && docker-php-ext-enable yaml \
    && pecl install yac-2.0.2 \
    && docker-php-ext-enable yac \
    && echo 'yac.enable_cli = 1' >> /usr/local/etc/php/conf.d/docker-php-ext-yac.ini \
    && echo 'date.timezone = "Asia/Chongqing"' >> /usr/local/etc/php/conf.d/zZ99-overrides.ini

# 方便swoole编译，单独取出来
RUN cd /tmp \
    && curl -o swoole.tar.gz https://github.com/swoole/swoole-src/archive/v4.1.2.tar.gz -L \
    && tar zxvf swoole.tar.gz \
    && mv swoole-src* swoole-src \
    && cd swoole-src \
    && /usr/local/bin/phpize \
    && ./configure --with-php-config=/usr/local/bin/php-config --enable-async-redis --enable-openssl --with-openssl-dir=/usr/include/openssl \
    && make \
    && make install \
    && docker-php-ext-enable swoole

RUN rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

EXPOSE 8000 9000 9001 9002

ENTRYPOINT tail -f /dev/null