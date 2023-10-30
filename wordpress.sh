#!/bin/bash
# CentOS9 install wordpress x Apache
user_db="$1"
password_db="$2"

count=$(find /var/www/ -type d -mindepth 1 | wc -l)
if [ -n "$user_db" ] && [ -n "$password_db" ]; then
    if [ "$count" -gt 1 ]; then
        mv wordpress /var/www/$user_db
        chown -R apache. /var/www/$user_db
        mysql -u root -p -e "CREATE DATABASE $user_db;"
        mysql -u root -p -e "grant all privileges on $user_db.* to '$user_db'@'localhost' identified by '$password_db';"
        mysql -u root -p -e "flush privileges;"
        echo "
Timeout 600
ProxyTimeout 600
Alias /$user_db \"/var/www/$user_db/\"
DirectoryIndex index.php index.html index.htm
<Directory \"/var/www/$user_db\">
    Options FollowSymLinks
    AllowOverride All
    Require all granted
</Directory>" | tee -a "/etc/httpd/conf.d/$user_db.conf"
        systemctl reload httpd
        setsebool -P httpd_can_network_connect on
        setsebool -P domain_can_mmap_files on
        setsebool -P httpd_unified on
        systemctl restart httpd
    else
        dnf -y update
        dnf -y install php wget mysql mysql-server
        systemctl enable mysqld
        systemctl start mysqld
        systemctl enable httpd
        systemctl restart httpd
        systemctl enable php-fpm
        systemctl status php-fpm
        dnf -y install php-pear php-mbstring php-pdo php-gd php-mysqlnd php-enchant enchant hunspell
        echo "
php_value[max_execution_time] = 600
php_value[memory_limit] = 2G
php_value[post_max_size] = 2G
php_value[upload_max_filesize] = 2G
php_value[max_input_time] = 600
php_value[max_input_vars] = 2000
php_value[date.timezone] = Asia/Bangkok" | tee -a /etc/php-fpm.d/www.conf
        systemctl restart php-fpm
        echo "
Timeout 600
ProxyTimeout 600
Alias /$user_db \"/var/www/$user_db/\"
DirectoryIndex index.php index.html index.htm
<Directory \"/var/www/$user_db\">
    Options FollowSymLinks
    AllowOverride All
    Require all granted
</Directory>\n" | tee -a "/etc/httpd/conf.d/$user_db.conf"
        systemctl restart httpd
        setsebool -P httpd_can_network_connect on
        setsebool -P domain_can_mmap_files on
        setsebool -P httpd_unified on
        mysql -u root -e "CREATE DATABASE $user_db;"
        mysql -u root -e "grant all privileges on $user_db.* to '$user_db'@'localhost' identified by '$password_db';"
        mysql -u root -e "flush privileges;"
        wget https://wordpress.org/latest.tar.gz -O /var/www/latest.tar.gz
        tar zxvf latest.tar.gz -C /var/www/
        mv wordpress /var/www/$user_db
        chown -R apache. /var/www/$user_db
        systemctl restart httpd
    fi
else
    echo "Please settings Params"
fi
