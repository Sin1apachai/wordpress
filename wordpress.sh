#!/bin/bash
# CentOS9 install wordpress x Apache
user_db="$1"
password_db="$2"
project_name="$3"

dnf -y install php
systemctl restart httpd
systemctl status php-fpm
dnf -y install php-pear php-mbstring php-pdo php-gd php-mysqlnd php-enchant enchant hunspell
echo "php_value[max_execution_time] = 600
php_value[memory_limit] = 2G
php_value[post_max_size] = 2G
php_value[upload_max_filesize] = 2G
php_value[max_input_time] = 600
php_value[max_input_vars] = 2000
php_value[date.timezone] = Asia/Bangkok" | tee -a /etc/php-fpm.d/www.conf
systemctl restart php-fpm
mysql -u root -p -e "CREATE DATABASE $user_db;"
mysql -u root -p -e "grant all privileges on $user_db.* to '$user_db'@'localhost' identified by '$password_db';"
mysql -u root -p -e "flush privileges;"
wget https://wordpress.org/latest.tar.gz -O "/var/www/$project_name.tar.gz"
tar zxvf $project_name.tar.gz -C /var/www/$project_name
chown -R apache. /var/www/$project_name
echo "
Timeout 600
ProxyTimeout 600

Alias /wordpress \"/var/www/$project_name/\"
DirectoryIndex index.php index.html index.htm
<Directory \"/var/www/$project_name\">
    Options FollowSymLinks
    AllowOverride All
    Require all granted
</Directory>" | tee -a /etc/php-fpm.d/www.conf
systemctl reload httpd
setsebool -P httpd_can_network_connect on
setsebool -P domain_can_mmap_files on
setsebool -P httpd_unified on
