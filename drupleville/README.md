


# Prereqs
- download drupal - lib/drupal.tar.gz
- extract drupal - lib/drupal7
- fire up the vagrant image

# Run provision_drupal.sh
- install apache2
- replace the /etc/apache2/sites-enabled/000-default.conf with the one in /vagrant
- install php5
- install mysql-server
- install mysql php playnice packages

# manual work
- login to mysql and create database drupalville
- open browser and navigate to the drupalville dir to config instance
