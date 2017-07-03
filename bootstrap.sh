#!/usr/bin/env bash

DATABASE='craft'
DATABASE_PASSWORD='password'

# Update make sure linux stuff is installed
sudo apt-get update
sudo apt-get install -y vim curl

# Install Apache and PHP
sudo apt-get install -y apache2
sudo apt-get install -y php7.0 imagemagick php-imagick php-curl

# Setup of apache to use vagrant folder (ubuntu/trusty64 uses /var/www/html)
if ! [ -L /var/www/html ]; then
    sudo rm -rf /var/www/html
    if ! [ -L /vagrant/public ]; then
        sudo mkdir /vagrant/public
    fi
    sudo ln -fs /vagrant/public /var/www/html
fi

# Install MySQL
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $DATABASE_PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DATABASE_PASSWORD"
sudo apt-get -y install mysql-server
sudo apt-get install php5-mysql

# Install PHPMyAdmin
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $DATABASE_PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $DATABASE_PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $DATABASE_PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo apt-get -y install phpmyadmin

# Create database
sudo mysql -u root -p$DATABASE_PASSWORD -e "CREATE DATABASE $DATABASE;"
sudo mysql -u root -p$DATABASE_PASSWORD -e "ALTER DATABASE $DATABASE CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
sudo mysql -u root -p$DATABASE_PASSWORD -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION; FLUSH PRIVILEGES;"

# Turn on PHP errors and increase upload file size limit
sudo sed -i.bak "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.0/apache2/php.ini
sudo sed -i.bak "s/display_errors = .*/display_errors = On/" /etc/php/7.0/apache2/php.ini
sudo sed -i.bak "s/upload_max_filesize = .*/upload_max_filesize = 16M/" /etc/php/7.0/apache2/php.ini

# AllowOverride in apache
sudo sed -i.bak "s/\tAllowOverride None/\tAllowOverride All/g" /etc/apache2/apache2.conf 

# Enable mod_rewrite/mcrypt and restart Apache
sudo a2enmod rewrite
sudo php5enmod mcrypt
sudo service apache2 restart

# Install composer for PHP dependencies and install global (v1.4.2)
sudo wget https://raw.githubusercontent.com/composer/getcomposer.org/a488222dad0b6eaaa211ed9a21f016bb706b2980/web/installer -O - -q | php -- --quiet
sudo mv composer.phar /usr/local/bin/composer
