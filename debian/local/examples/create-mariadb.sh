#!/bin/sh

set -e

DATABASE_NAME=${1:-'snipeit'}
DATABASE_USER=${2:-'snipeit'}
DATABASE_PASSWORD="${3}"

if [ -z "$DATABASE_PASSWORD" ]
then
	APG=$(dpkg -l apg|grep ^ii)
	if [ -z "$APG" ]
	then
		echo "Install apg first or enter password manually."
		exit 1
	fi
	DATABASE_PASSWORD=$(apg -m 10 -E '*%|`´;~' | head -n 1)
	echo "* Database password is ${DATABASE_PASSWORD}."
	echo "* Please note for config file."
fi

echo "* Creating MariaDB Database/User ${DATABASE_NAME}/${DATABASE_USER}."
sleep 5
mysql --execute="CREATE DATABASE ${DATABASE_NAME};GRANT ALL PRIVILEGES ON ${DATABASE_NAME}.* TO ${DATABASE_USER}@localhost IDENTIFIED BY '$DATABASE_PASSWORD';"
