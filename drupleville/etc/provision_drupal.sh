#!/bin/bash

wget -O /vagrant/drupal.tar.gz  https://ftp.drupal.org/files/projects/drupal-7.43.tar.gz 2>&1 /dev/null

tar xf drupal.tar.gz

echo "Installing Apache and setting it up..."
apt-get update >/dev/null 2>&1
apt-get install -y apache2 >/dev/null 2>&1
rm -rf /var/www
ln -fs /vagrant /var/www

#apt-get install -y php5-common
#apt-get install -y mysql-server
