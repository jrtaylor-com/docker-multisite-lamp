#!/bin/bash
apache_config_path="/etc/apache2/sites-available/"
apache_config_file="${apache_config_path}000-default.conf"
site_directory="/var/www/html"

main() {
sed -i "s/#ServerName/ServerName/" ${apache_config_file}

# loop through our sites directory and generate configs
shopt -s dotglob
find ${site_directory}/* -prune -type d | while IFS= read -r d; do
    echo "Creating apache site conf for: ${d##*/}"
    dir=${d##*/}

    # pull in site specific vars
    source "${d}/server.cfg"

    # create new apache config for site
    new_filename="${dir}.conf"
    new_config="${apache_config_path}${new_filename}"
    cp ${apache_config_file} ${new_config};

    # update config with site specifics
    sed -ri -e "s/ServerName\swww.example.com/ServerName ${dir}/" ${new_config}
    sed -ri -e "s~/var/www/html~/var/www/html/${dir}${entry}~" ${new_config}
    sed -ri -e "s/error.log/${dir}.error.log/" ${new_config}
    sed -ri -e "s/access.log/${dir}.access.log/" ${new_config}

    # add overrides and setup php-fpm
    sed -i "s/<\/VirtualHost>//" ${new_config}
    echo "<Directory ${d}${entry}/>
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
</Directory>
<FilesMatch \"\.php$\">
    SetHandler \"proxy:fcgi://127.0.0.1:90${php}\"
</FilesMatch>
</VirtualHost>" >> ${new_config}

    # enable the site in apache2
    a2ensite ${new_filename}
done

}

main
exit 0
