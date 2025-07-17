#!/bin/bash
set -e

WORDPRESS_DB_PASSWORD=$(cat /secrets/db_password.txt)

export HTTP_HOST="${DOMAIN_NAME}"

if [ ! -f /var/www/html/wp-config.php ]; then
  cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

  sed -i "s/database_name_here/${WORDPRESS_DB_NAME}/" /var/www/html/wp-config.php
  sed -i "s/username_here/${WORDPRESS_DB_USER}/" /var/www/html/wp-config.php
  sed -i "s/password_here/${WORDPRESS_DB_PASSWORD}/" /var/www/html/wp-config.php
  sed -i "s/localhost/${WORDPRESS_DB_HOST}/" /var/www/html/wp-config.php
fi

if ! wp core is-installed --path=/var/www/html --allow-root; then

  wp core install \
    --path=/var/www/html \
    --url="https://${DOMAIN_NAME}" \
    --title="${WORDPRESS_SITE_TITLE}" \
    --admin_user="${WORDPRESS_ADMIN_USER}" \
    --admin_password="${WORDPRESS_ADMIN_PASS}" \
    --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
    --skip-email \
    --allow-root

  echo "WordPress algultse"
fi

exec "$@"