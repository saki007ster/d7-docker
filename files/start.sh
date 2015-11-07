#!/bin/bash

export DRUSH="/.composer/vendor/drush/drush/drush"
export LOCAL_IP=$(hostname -I)


function PrintCreds() {
  # This is so the passwords show up in logs.
  echo
	echo "----GENERATED USERS CREDENTIALS----"
	echo "mysql drupal password: $2"
	echo "mysql root   password: $1"
  echo "ssh   root   password: $1"
	echo "-----------------------------------"
}

if [ ! -f /var/www/html/sites/default/settings.php ]; then
	# Start mysql
	/usr/bin/mysqld_safe --skip-syslog &
	sleep 3s
	# Generate random passwords
	DRUPAL_DB="drupal"
	ROOT_PASSWORD=`pwgen -c -n -1 12`
	DRUPAL_PASSWORD=`pwgen -c -n -1 12`
	echo $ROOT_PASSWORD > /mysql-root-pw.txt
	echo $DRUPAL_PASSWORD > /drupal-db-pw.txt
  PrintCreds $ROOT_PASSWORD $DRUPAL_PASSWORD
  echo "root:${ROOT_PASSWORD}" | chpasswd
	mysqladmin -u root password $ROOT_PASSWORD
	mysql -uroot -p$ROOT_PASSWORD -e "CREATE DATABASE drupal; GRANT ALL PRIVILEGES ON drupal.* TO 'drupal'@'localhost' IDENTIFIED BY '$DRUPAL_PASSWORD'; FLUSH PRIVILEGES;"
	cd /var/www/html
	cp sites/default/default.services.yml sites/default/services.yml
	${DRUSH} site-install standard -y --account-name=admin --account-pass=admin \
  --db-url="mysqli://drupal:${DRUPAL_PASSWORD}@localhost:3306/drupal" \
  --site-name="Drupal7 docker App" | grep -v 'continue?'
	${DRUSH} -y dl memcache | grep -v 'continue?'
	${DRUSH} -y en memcache | grep -v 'continue?'
	killall mysqld
	sleep 3s
else
	ROOT_PASSWORD=$(cat /mysql-root-pw.txt)
	DRUPAL_PASSWORD=$(cat /drupal-db-pw.txt)
  PrintCreds $ROOT_PASSWORD $DRUPAL_PASSWORD
fi

echo
echo "--------------------------STARTING SERVICES-----------------------------------"
echo "SSH    LOGIN: ssh root@${LOCAL_IP} with root  password: ${ROOT_PASSWORD}"
echo "DRUPAL LOGIN: http://${LOCAL_IP}   with admin password: admin"
echo "Please report any issues to https://github.com/saki007ster/d7-docker"
echo "USE CTRL+C TO STOP THIS APP"
echo "------------------------------------------------------------------------------"
supervisord -n -c /etc/supervisor/conf.d/supervisord.conf
