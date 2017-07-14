FROM php:7-apache

RUN apt-get update && apt-get install -yqq --no-install-recommends \
  vim \
  rsyslog \
  supervisor \
  mysql-client \
  libmysqlclient-dev \
  libpng-dev \
  libfreetype6-dev \
  libjpeg62-turbo-dev \
  libpng12-dev \
  libapache2-mod-fcgid \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install mysqli pdo_mysql zip mbstring gd exif pcntl opcache \
  && pecl install apcu xdebug \
  && echo extension=apcu.so > /usr/local/etc/php/conf.d/apcu.ini \
  && apt-get clean autoclean && apt-get autoremove -y

COPY ./configs/php.ini /usr/local/etc/php/php.ini
COPY ./configs/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini
COPY ./scripts/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./scripts/rsyslog.conf /etc/rsyslog.conf
COPY ./scripts/provision.sh /provision.sh
COPY ./scripts/bootstrap.sh /bootstrap.sh

RUN /provision.sh
RUN service php7.1-fpm start
RUN service php5-fpm start

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
