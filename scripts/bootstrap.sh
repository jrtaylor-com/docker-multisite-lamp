# Generate apache vhosts
/scripts/apache_site_sync.sh

#start fpm
service php5-fpm start
service php7.1-fpm start

apache2-foreground
