#!/bin/bash

# run this after clean env
cp /vagrant/drupalville /var/www/
apt-get install -y apache2 
apt-get install -y php5
apt-get install -y mysql-server
