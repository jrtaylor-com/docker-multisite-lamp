# Multisite Docker LAMP

## Quickstart
Clone the development site you are working on to a subdirectory in the sites directory. The name of the directory will be used in your HOSTS file, so a name like local.dev should be used. EX:
```
cd ./sites
git clone example@github.com/user/repo.git local.dev
```

Create a server.cfg file in your site's root and set the php version and entry/DocumentRoot for your site. For document root use a leading slash, exclude this variable if your site root is also your Document root. See the PHP-FPM chart below for currently supported PHP versions use the config value that represents the version to use. An example of the contents of this file:

```
php=56
entry="/html"
```

Now build your repo from this repo's root directory
```
docker-compose build
```

And start the containers
```
docker-compose up
```

### Adding a site while the container is running
To update the apache configs while the container is running you can run this command on the host:
```
docker exec -it <container id> /scripts/apache_site_sync.sh
```

### Hosts file
To access your site in your browser you will need to update your hosts file. The location of this file is dependant on your OS. On a mac it can be found at /etc/hosts 
You should add a line to your hosts file with the IP and name of the directory your site is in. For example if your site is located at ./sites/local.dev your host file should have a line in it that reads like this:
```
127.0.0.1  local.dev
```

---

### Currently supported php-fpm version key

PHP Version | Config Value
--- | --- 
7.1 | 71
5.6 | 56

## About
This Docker setup allows you to run multiple side by side LAMP sites without having to juggle a lot of separate development environments. It utilizes a shared MySQL database and uses PHP-FPM to allow each site to run at a different version of PHP. This is very useful when you are working on multiple LAMP stack sites, you just clone your site and start developing.

####
* TODO: 
- Add more key PHP versions
- Add feature to import Databases from SQL file
