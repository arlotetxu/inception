#!/bin/sh

set -e

DATADIR=/var/lib/mysql
SOCKET=/run/mysqld/mysqld.sock

DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
DB_PASSWORD=$(cat /run/secrets/db_password)

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld "$DATADIR"

if [ ! -d "$DATADIR/mysql" ]; then
	echo "First run. Initializating MariaDB..."
	mariadb-install-db --user=mysql --datadir="$DATADIR" --skip-test-db > /dev/null

	#temp server. No network (--skip-networking)
	mariadbd --user=mysql --skip-networking --socket="$SOCKET" & 
	TEMP_PID=$!

	until mariadb-admin --socket="$SOCKET" ping --silent; do
		sleep 1
	done

	mariadb --socket="$SOCKET" <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \'${MYSQL_DATABASE}\'.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

	mariadb-admin --socket="$SOCKET" -uroot -p"${DB_ROOT_PASSWORD}" shutdown
	wait "$TEMP_PID"
	echo "Initialization completed!."
fi

exec "$@"

