#!/bin/bash

# run this after clean env
cp -r /vagrant/lib/drupalville /var/www/
apt-get install -y apache2 
apt-get install -y php5
apt-get install -y mysql-server

sudo cp /etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-enabled/000-default.conf.orig
sudo cp /vagrant/etc/000-default.conf /etc/apache2/sites-enabled/000-default.conf

