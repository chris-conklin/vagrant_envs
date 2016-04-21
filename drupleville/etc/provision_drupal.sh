#!/bin/bash

# run this after clean env
sudo apt-get install -y apache2 
sudo apt-get install -y php5
sudo apt-get install -y php5-gd
sudo apt-get install -y mysql-server
sudo apt-get install -y libapache2-mod-auth-mysql 
sudo apt-get install -y php5-mysql 
sudo apt-get install -y phpmyadmin

sudo cp -r /vagrant/lib/drupalville /var/www/
sudo chown -R www-data.www-data /var/www/drupalville/

sudo cp /etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/000-default.conf.orig
sudo cp /vagrant/etc/000-default.conf /etc/apache2/sites-enabled/000-default.conf

echo "You still need to create a mysql database called drupalville and run the installer"
