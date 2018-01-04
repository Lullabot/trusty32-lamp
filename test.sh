#!/bin/bash -ex

# This script expects to be run as root. It can be run with:
#   $ vagrant ssh --command "sudo /vagrant/test.sh"
test() {
  # Download Drupal 8 and install it.
  cd /var/www
  rm -rf /var/www/docroot

  drush dl drupal --destination=/var/www --drupal-project-rename=docroot -y
  cd /var/www/docroot

  # Test the installer loads.
  wget -q -O - http://localhost/ | grep 'Choose language'

  # Test installing Drupal.
  sudo -u www-data drush si --db-url=mysql://root@localhost/drupal8 -y

  # curl the Drupal 8 home page.
  wget -q -O - http://localhost/ | grep "Site-Install"

  # Test debugging.
  echo '<?php print_r(get_loaded_extensions());' > /var/www/docroot/extensions.php
  wget -q -O - http://localhost/extensions.php | grep xdebug

  # Test xhgui.
  wget -q -O - http://localhost/extensions.php | grep tideways
  mongo xhprof --eval "db.dropDatabase();"
  wget -q -O - http://localhost/?xhgui=on > /dev/null
  wget -q -O - http://localhost/xhgui | grep '/?xhgui=on'
}

# Test each php version.
VERSIONS="php5.6 php7.0 php7.1"
for VERSION in  $VERSIONS
do
  echo "Testing $VERSION..."
  a2dismod $VERSIONS
  a2enmod $VERSION
  service apache2 restart
  update-alternatives --set php /usr/bin/$VERSION
  test
done

echo 'All tests passed!'
