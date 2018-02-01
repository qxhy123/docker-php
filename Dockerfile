FROM daocloud.io/php:5.6.32-fpm
# Install modules
RUN apt-get update && apt-get install -y \
        Imagemagick \
        libevent-dev \
        libmagickwand-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libxml2 \
        libxml2-dev \
        vim \
        htop \
        tmux \
        wget \
    && wget http://launchpad.net/libmemcached/1.0/1.0.2/+download/libmemcached-1.0.2.tar.gz \
    && tar -zxvf libmemcached-1.0.2.tar.gz \
    && cd libmemcached-1.0.2 \
    && ./configure --prefix=/usr/local/libmemcached \
    && make && make install \
    && docker-php-ext-install pdo_mysql mysqli pcntl soap opcache \
    && docker-php-ext-enable pdo_mysql \
    && docker-php-ext-enable mysqli \
    && docker-php-ext-enable pcntl \
    && docker-php-ext-enable opcache \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
#    && docker-php-ext-enable gd \
    && pecl install imagick-3.4.3 \
    && docker-php-ext-enable imagick \
#    && pecl install redis-2.2.8 \
#    && docker-php-ext-enable redis \
#    && pecl install libevent-0.1.0 \
#    && docker-php-ext-enable libevent \
    && pecl install Xdebug-2.5.0 \
    && echo no | pecl install memcached-2.2.0 \
    && docker-php-ext-enable memcached \
    && docker-php-ext-enable xdebug \
    && export TERM=xterm \
    && apt-get clean \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && curl -sS https://getcomposer.org/installer \
    | php -- --install-dir=/usr/bin --filename=composer
EXPOSE 9000 9001 9002
CMD ["php-fpm"]
