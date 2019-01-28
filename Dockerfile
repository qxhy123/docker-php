FROM php:7.2-cli
# Install modules
RUN apt-get update && apt-get install -y \
        imagemagick \
        libevent-dev \
#        libmagickwand-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libxml2 \
        libxml2-dev \
        libmemcached-dev \
        openssl \
        libssl-dev \
        gdb \
        vim \
        wget \
        git \
        # jq \
        htop \
        tmux \
        make \
        gcc \
        libyaml-dev \
        autoconf \
    # && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    # && apt-get install -y nodejs \
    # && npm install -g nodemon \
    # && echo "/usr/local/lib" >> /etc/ld.so.conf \
    # && ldconfig \
    && cd .. \
    && wget -O phpunit.phar https://phar.phpunit.de/phpunit.phar \
    && mv phpunit.phar /usr/bin/phpunit \
    && chmod +x /usr/bin/phpunit \
    && docker-php-ext-install bcmath pdo_mysql mysqli pcntl soap opcache zip\
    && docker-php-ext-enable pdo_mysql \
    && docker-php-ext-enable mysqli \
    && docker-php-ext-enable pcntl \
    && docker-php-ext-enable opcache \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
#    && docker-php-ext-enable gd \
#    && pecl install imagick-3.4.3 \
#    && docker-php-ext-enable imagick \
    && pecl install redis-3.1.2 \
    && docker-php-ext-enable redis \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb \
#    && pecl install libevent-0.1.0 \
#    && docker-php-ext-enable libevent \
    && echo no | pecl install memcached-3.0.4 \
    && docker-php-ext-enable memcached \
    && git clone https://github.com/swoole/swoole-src.git \
    && cd swoole-src \
    && git checkout v4.2.12 \
    && /usr/local/bin/phpize \
    && ./configure --with-php-config=/usr/local/bin/php-config  --enable-openssl --with-openssl-dir=/usr/include/openssl \
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
    && echo 'yac.enable_cli = 1' >> /usr/local/etc/php/conf.d/docker-php-ext-yac.ini \
    && echo 'date.timezone = "Asia/Chongqing"' >> /usr/local/etc/php/conf.d/zZ99-overrides.ini \
    && export TERM=xterm \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* yaml-0.1.5 package.xml \
    # && curl -sS https://getcomposer.org/installer \
    # | php -- --install-dir=/usr/bin --filename=composer
EXPOSE 8000 9000 9001 9002

ENTRYPOINT tail -f /dev/null
