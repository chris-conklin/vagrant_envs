#!/usr/bin/env bash

# eth1 for Vagrant ubuntu environments 
SYS_IP="`ip addr show eth1 | grep inet | awk '{ print $2; }' | sed 's/\/.*$//'`"
# vagrant runs this script as sudo

#echo "Installing Apache and setting it up..."
#apt-get update >/dev/null 2>&1
#apt-get install -y apache2 >/dev/null 2>&1
#rm -rf /var/www
#ln -fs /vagrant /var/www


# aptitude configuration
APTITUDE_OPTIONS="-y"
export DEBIAN_FRONTEND=noninteractive

# run an aptitude update to make sure python-software-properties
# dependencies are found
apt-get update

cat <<PACKAGES | xargs apt-get install $APTITUDE_OPTIONS
git-core
python-dev
python-setuptools
python-mysqldb
php5
mysql-server
phpmyadmin 
libapache2-mod-php5
php5-mcrypt
samba
PACKAGES

###############################################################################
# fix phpmyadmin access (for home nat network - this probably replaces more 
#	than what is necessary but works for now)
###############################################################################
APACHE_HOME="/etc/apache2"
OLD="/var/www/html"
NEW="/var/www"
cp $APACHE_HOME/sites-available/000-default.conf $APACHE_HOME/sites-available/000-default.conf.orig

cat > $APACHE_HOME/sites-available/000-default.conf <<FIXAPACHE

<VirtualHost *:80>

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>

FIXAPACHE

service apache2 restart

###############################################################################
# Install 
###############################################################################

apt-get install $APTITUDE_OPTIONS samba samba-client samba-common

mv /etc/samba/smb.conf /etc/samba/smb.conf.bak

cat > /etc/samba/smb.conf <<SCONF

[global]
workgroup = $WKGRP
server string = Samba Server %v
netbios name = vagrant php box
security = user
map to guest = bad user
dns proxy = no
#============================ Share Definitions ============================== 
[webroot]
path = /var/www
browsable =yes
writable = yes
guest ok = yes
read only = no

SCONF

#################################################################################
# move existing php into place
#################################################################################
cp -r /vagrant/app /var/www/

echo READY on $SYS_IP

