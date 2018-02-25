#!/bin/sh

# parameters
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-"mysql"}
MYSQL_USER=${MYSQL_USER:-""}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-""}
MYSQL_DATABASE=${MYSQL_DATABASE:-""}

echo "$MYSQL_ROOT_PASSWORD"
echo "$MYSQL_USER"
echo "$MYSQL_PASSWORD"
echo "$MYSQL_DATABASE"

if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

if [ -d /var/lib/mysql/mysql ]; then
	echo '[i] MySQL directory already present, skipping creation'
else
	echo "[i] MySQL data directory not found, creating initial DBs"

	chown -R mysql:mysql /var/lib/mysql

	# init database
	echo 'Initializing database'
	mysql_install_db --user=mysql > /dev/null
	echo 'Database initialized'

	echo "[i] MySql root password: $MYSQL_ROOT_PASSWORD"

	# create temp file
	tempSqlFile='/var/lib/mysql/mysql-first-time.sql'
	if [ ! -f "$tempSqlFile" ]; then
	    return 1
	fi

	# save sql
	echo "[i] Create temp file: $tempSqlFile"
	cat << EOF > $tempSqlFile
USE mysql;
FLUSH PRIVILEGES;
DELETE FROM mysql.user;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION;
EOF


	# Create new database
	if [ "$MYSQL_DATABASE" != "" ]; then
		echo "[i] Creating database: $MYSQL_DATABASE"
		echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> $tempSqlFile

		# set new User and Password
		if [ "$MYSQL_USER" != "" ] && [ "$MYSQL_PASSWORD" != "" ]; then
		echo "[i] Creating user: $MYSQL_USER with password $MYSQL_PASSWORD"
		echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >> $tempSqlFile
		fi
	else
		# don`t need to create new database,Set new User to control all database.
		if [ "$MYSQL_USER" != "" ] && [ "$MYSQL_PASSWORD" != "" ]; then
		echo "[i] Creating user: $MYSQL_USER with password $MYSQL_PASSWORD"
		echo "GRANT ALL ON *.* to '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >> $tempSqlFile
		fi
	fi

	echo 'FLUSH PRIVILEGES;' >> $tempSqlFile

	# run sql in tempfile
	echo "[i] run tempfile: $tempSqlFile"
	/usr/bin/mysqld --user=mysql --bootstrap --verbose=0 < $tempSqlFile
	#rm -f $tempSqlFile
fi

echo "[i] Sleeping 5 sec"
sleep 5

echo '[i] start running mysqld'
exec /usr/bin/mysqld --user=mysql --console
