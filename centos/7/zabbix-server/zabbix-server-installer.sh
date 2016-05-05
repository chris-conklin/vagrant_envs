#!/bin/bash

# a mixup of the junkco lamp installer and 
# http://www.unixmen.com/how-to-install-zabbix-server-on-centos-7/


SYS_IP="`ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/'`"
YUM_OPTIONS="-y"

ZABBIX_HOSTNAME=${SYS_IP}
ZABBIX_TIMEZONE="America/New_York"
ZABBIX_USER=${ZABUSER:-zabbixuser}
ZABBIX_DB=${ZABDB:-zabbixdb}
ZABBIX_DB_PW=${ZBPW:-password}

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


###############################################################################
###############################################################################
# BEGIN ZABBIX INSTALL/CONFIG
###############################################################################
###############################################################################


###############################################################################
# Configure the ZabbixZone package repository and GPG key using command:
###############################################################################
rpm --import http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX
rpm -Uv  http://repo.zabbix.com/zabbix/2.4/rhel/7/x86_64/zabbix-release-2.4-1.el7.noarch.rpm

###############################################################################
# Now, Install Zabbix server and agent using command:
###############################################################################
yum install $YUM_OPTIONS zabbix-server-mysql zabbix-web-mysql zabbix-agent zabbix-java-gateway

###############################################################################
# set the timezone - sed can use any delimmiter using & here
###############################################################################
#sed -i 's&# php_value date.timezone Europe/Riga&php_value date.timezone America/New_York&g' /etc/httpd/conf.d/zabbix.conf

###############################################################################
# Replace zabbix httpd conf file with custom in vagrant sync directory
# this does not match the website conf - has 403 fix added
###############################################################################
mv /etc/httpd/conf.d/zabbix.conf /etc/httpd/conf.d/zabbix.conf.orig
cp /home/vagrant/sync/etc/default.conf /etc/httpd/conf.d/zabbix.conf

###############################################################################
# Replace default php.ini file with custom in vagrant sync directory
###############################################################################
mv /etc/php.ini /etc/php.ini.orig
cp /home/vagrant/sync/etc/clean_php.ini /etc/php.ini

systemctl restart httpd

###############################################################################
# service configuration
###############################################################################
systemctl start mariadb.service
systemctl enable mariadb.service
systemctl start httpd.service
systemctl enable httpd.service
systemctl start zabbix-server
systemctl start zabbix-agent
systemctl start firewalld

###############################################################################
# If you use SELinux, run the following command to allow Apache to communicate with Zabbix.
###############################################################################
setsebool -P httpd_can_connect_zabbix=1

###############################################################################
# firewall settings
###############################################################################

firewall-cmd --permanent --zone=public --add-port=10050/tcp
firewall-cmd --permanent --zone=public --add-port=10051/tcp
firewall-cmd --permanent --zone=public --add-service=http 
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --reload