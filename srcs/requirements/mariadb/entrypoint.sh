#!/bin/bash
set -e

echo "🔧 Initializing MariaDB..."
mysql_install_db --user=mysql --ldata=/var/lib/mysql > /dev/null

mysqld_safe --skip-networking &
sleep 5

export MYSQL_PASSWORD=$(cat $SECRETS_DIR/db_password.txt)
export MYSQL_ROOT_PASSWORD=$(cat $SECRETS_DIR/db_root_password.txt)

mysql -uroot -p"$MYSQL_ROOT_PASSWORD" <<EOF
CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
EOF

mysqladmin shutdown -uroot -p"$MYSQL_ROOT_PASSWORD"

# Pour gerer le probleme du PID 1, on utilise exec pour etre sur que mysqld soit bien le PID 1
exec su mysql -s /bin/bash -c "exec mysqld"
