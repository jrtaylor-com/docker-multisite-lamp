#!/bin/bash
# update package repos
echo "deb http://snapshot.debian.org/archive/debian/20170712T145225Z/ unstable main" >> /etc/apt/sources.list
echo "deb-src http://snapshot.debian.org/archive/debian/20170712T145225Z/ unstable main" >> /etc/apt/sources.list
apt-get -o Acquire::Check-Valid-Until=false update; apt-get install \
  php5 \
  php7.1-fpm  \
  php5-fpm \
  php5-mcrypt -y

# set php7.1-fpm to listen on port
sed -i 's/listen = \/run\/php\/php7\.1-fpm\.sock/listen = 127\.0\.0\.1:9071/' /etc/php/7.1/fpm/pool.d/www.conf; \
  sed -i 's/;listen\.allowed_clients = 127\.0\.0\.1/listen\.allowed_clients = 127\.0\.0\.1/' /etc/php/7.1/fpm/pool.d/www.conf; service php7.1-fpm start

# set php5-fpm to listen on port
sed -i 's/listen = \/var\/run\/php5-fpm\.sock/listen = 127\.0\.0\.1:9056/' /etc/php5/fpm/pool.d/www.conf; \
  sed -i 's/;listen\.allowed_clients = 127\.0\.0\.1/listen\.allowed_clients = 127\.0\.0\.1/' /etc/php5/fpm/pool.d/www.conf; service php5-fpm start

# allow apache overrides so we dont get permission errors with vhosts
sed -i 's/#<\/Directory>/#<\/Directory>\n<Directory \/var\/www\/html>\nOptions Indexes FollowSymLinks\nAllowOverride All\nRequire all granted\n<\/Directory>/' /etc/apache2/apache2.conf

# enable needed apache modules
ln -s /etc/apache2/mods-available/actions.conf /etc/apache2/mods-enabled/actions.conf; \
  ln -s /etc/apache2/mods-available/actions.load /etc/apache2/mods-enabled/actions.load; \
  ln -s /etc/apache2/mods-available/proxy.load /etc/apache2/mods-enabled/proxy.load; \
  ln -s /etc/apache2/mods-available/proxy.conf /etc/apache2/mods-enabled/proxy.conf; \
  ln -s /etc/apache2/mods-available/proxy_fcgi.load /etc/apache2/mods-enabled/proxy_fcgi.load;
