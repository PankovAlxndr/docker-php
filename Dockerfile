FROM php:8.2-fpm-alpine3.18

LABEL authors="pankovalxndr"

ARG UID
ARG GID
ARG USER

ENV XDEBUG_VERSION 3.2.2
ENV UID=${UID}
ENV GID=${GID}
ENV USER=${USER}
ENV TZ Europe/Moscow

RUN apk add --no-cache bash coreutils git linux-headers tzdata unzip libzip-dev zip mysql-client \
    freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev \
    && git clone --branch $XDEBUG_VERSION --depth 1 https://github.com/xdebug/xdebug.git /usr/src/php/ext/xdebug \
    && docker-php-ext-configure xdebug --enable-xdebug-dev \
    && docker-php-ext-install xdebug pdo_mysql pcntl zip bcmath

RUN docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg \
  NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
  docker-php-ext-install -j$(nproc) gd && \
  apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev

RUN mv $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini
COPY ./config/conf.d/security.ini /usr/local/etc/php/conf.d/security.ini
COPY ./config/conf.d/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
COPY ./config/conf.d/timezone.ini /usr/local/etc/php/conf.d/timezone.ini
COPY ./config/conf.d/memory.ini /usr/local/etc/php/conf.d/memory.ini
COPY ./config/php-fpm.d/ping.conf /usr/local/etc/php-fpm.d/ping.conf

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/bin --filename=composer --quiet
RUN addgroup -g ${GID} --system ${USER} && adduser -G ${USER} --system -D -s /bin/bash -u ${UID} ${USER}
RUN sed -i "s/user = www-data/user = '${USER}'/g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -i "s/group = www-data/group = '${USER}'/g" /usr/local/etc/php-fpm.d/www.conf
RUN echo "php_admin_flag[log_errors] = on" >> /usr/local/etc/php-fpm.d/www.conf

COPY ./config/wait-for-it.sh /usr/local/bin/wait-for-it
RUN chmod 555 /usr/local/bin/wait-for-it

USER ${USER}

WORKDIR /application