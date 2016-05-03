#!/bin/bash

# a mixup of the junkco lamp installer and 
# http://www.unixmen.com/how-to-install-zabbix-server-on-centos-7/

ZABBIX_HOSTNAME
ZABBIX_TIMEZONE="America/New_York
SYS_IP="`ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/'`"
YUM_OPTIONS="-y"

###############################################################################
# Install prerequisites
###############################################################################

# bootstrap
yum install -y wget

# epel repo in case isn't added already
wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
rpm -Uvh epel-release-7*.rpm

yum update $YUM_OPTIONS

cat <<PACKAGES | xargs yum install $YUM_OPTIONS
epel-release
vim
git
httpd
mariadb-server
mariadb
php
php-mysql
phpmyadmin
PACKAGES

###############################################################################
# generate php test page
###############################################################################

cat > /var/www/html/info.php <<PINFO
<?php phpinfo(); ?>
PINFO

###############################################################################
# fix phpmyadmin access (for home nat network - this probably replaces more 
#	than what is necessary but works for now)
###############################################################################

cp /etc/httpd/conf.d/phpMyAdmin.conf /etc/httpd/conf.d/phpMyAdmin.conf.orig
sed -i 's/127.0.0.1/192.168.0/g' /etc/httpd/conf.d/phpMyAdmin.conf