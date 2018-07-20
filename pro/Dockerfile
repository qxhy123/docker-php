FROM php:7.2.7-cli

# Install modules
RUN apt-get update && apt-get install -y libssl-dev \
        imagemagick \
        libevent-dev \
        libmagickwand-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libxml2 \
        libxml2-dev \
	&& apt-get clean \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

RUN docker-php-ext-install pdo_mysql mysqli pcntl soap opcache \
    && docker-php-ext-enable opcache \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install imagick-3.4.3 \
    && docker-php-ext-enable imagick

ENV SWOOLE_VERSION master

RUN mkdir -p ~/build && \
    cd ~/build && \
    rm -rf ./swoole-src && \
    curl -o ./swoole.tar.gz https://github.com/swoole/swoole-src/archive/$SWOOLE_VERSION.tar.gz -L && \
    tar zxvf ./swoole.tar.gz && \
    mv swoole-src* swoole-src && \
    cd swoole-src && \
    phpize && \
    ./configure \
    --enable-openssl  \
    --enable-mysqlnd && \
    make clean && make && make install \
    && rm -rf ~/build/*

RUN pecl install channel://pecl.php.net/yac-2.0.2 \
    inotify

RUN docker-php-ext-enable swoole \
    yac \
    inotify

CMD "tail -f /dev/null"
