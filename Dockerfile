FROM php:7.1.16-fpm-jessie
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
        libmemcached-dev \
        openssl \
        libssl-dev \
        vim \
        wget \
        git \
        jq \
        htop \
        tmux \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g nodemon \
    && wget -q -O hiredis-0.13.3.tar.gz https://github.com/redis/hiredis/archive/v0.13.3.tar.gz \
    && tar zxvf hiredis-0.13.3.tar.gz \
    && cd hiredis-0.13.3 \
    && make \
    && make install \
    && echo "/usr/local/lib" > /etc/ld.so.conf.d/local.conf \
    && ldconfig \
    && cd .. \
    && wget -O yaml-0.1.5.tar.gz http://pyyaml.org/download/libyaml/yaml-0.1.5.tar.gz \
    && tar xzf yaml-0.1.5.tar.gz \
    && cd yaml-0.1.5 \
    && ./configure --prefix=/usr/local \
    && make >/dev/null \
    && make install \
    && cd .. \
    && wget -O phpunit.phar https://phar.phpunit.de/phpunit.phar \
    && mv phpunit.phar /usr/bin/phpunit \
    && chmod +x /usr/bin/phpunit \
    && docker-php-ext-install bcmath pdo_mysql mysqli pcntl soap opcache \
    && docker-php-ext-enable pdo_mysql \
    && docker-php-ext-enable mysqli \
    && docker-php-ext-enable pcntl \
    && docker-php-ext-enable opcache \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
#    && docker-php-ext-enable gd \
    && pecl install imagick-3.4.3 \
    && docker-php-ext-enable imagick \
    && pecl install redis-3.1.2 \
    && docker-php-ext-enable redis \
    && pecl install mongodb-1.2.8 \
    && docker-php-ext-enable mongodb \
#    && pecl install libevent-0.1.0 \
#    && docker-php-ext-enable libevent \
    && echo no | pecl install memcached-3.0.4 \
    && docker-php-ext-enable memcached \
    && pecl install Xdebug-2.5.0 \
    && docker-php-ext-enable xdebug \
    # && docker-php-ext-configure swoole-1.9.18 --enable-async-redis --enable-openssl \
    && pecl download swoole-1.9.18 \
    && tar zxvf swoole-1.9.18.tgz \ 
    && cd swoole-1.9.18 \
    && /usr/local/bin/phpize \
    && ./configure --with-php-config=/usr/local/bin/php-config --enable-async-redis --enable-openssl --with-openssl-dir=/usr/include/openssl \
    && make \
    && make install \
    && cd .. \
    && docker-php-ext-enable swoole \
    && pecl install igbinary-2.0.5 \
    && docker-php-ext-enable igbinary \
    && pecl install inotify-2.0.0 \
    && docker-php-ext-enable inotify \
    && pecl install yaml-2.0.0 \
    && docker-php-ext-enable yaml \
    && pecl install yac-2.0.2 \
    && docker-php-ext-enable yac \
    && export TERM=xterm \
    && apt-get clean \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* yaml-0.1.5 swoole-1.9.18 package.xml hiredis-0.13.3 \
    && curl -sS https://getcomposer.org/installer \
    | php -- --install-dir=/usr/bin --filename=composer
EXPOSE 8000 9000 9001 9002
CMD ["php-fpm"]
