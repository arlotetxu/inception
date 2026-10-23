#!/bin/sh

set -e

WP_PATH=/var/www/html

DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

# Check if admin is in username
case "$(echo "$WP_ADMIN_USER" | tr '[:upper:]' '[:lower:]')" in *admin*)
	echo "Error: env variable WP_ADMIN_USER cannot contain 'admin'" >&2
	exit 1
	;;
esac

# Wait for mariadb
until mariadb-admin ping -h mariadb -u"$MYSQL_USER" -p"$DB_PASSWORD" --skip-ssl --silent; do
	echo "Waiting to MariaDB..."
	sleep 2
done

# Download and configure WP
if [ ! -f "$WP_PATH/wp-config.php" ]; then
	wp core download --path="$WP_PATH" --allow-root
	wp config create --path="$WP_PATH" --allow-root \
		--dbname="$MYSQL_DATABASE" \
		--dbuser="$MYSQL_USER" \
		--dbpass="$DB_PASSWORD" \
		--dbhost=mariadb
fi

# Install the site and create the users
if ! wp core is-installed --path="$WP_PATH" --allow-root; then
	wp core install --path="$WP_PATH" --allow-root \
		--url="https://$DOMAIN_NAME" \
		--title="$WP_TITLE" \
		--admin_user="$WP_ADMIN_USER" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--admin_email="$WP_ADMIN_EMAIL" \
		--skip-email
	
	wp user create "$WP_USER" "$WP_USER_EMAIL" --path="$WP_PATH" --allow-root \
		--role=author \
		--user_pass="$WP_USER_PASSWORD"
fi

chown -R nobody:nobody "$WP_PATH"

exec "$@"

