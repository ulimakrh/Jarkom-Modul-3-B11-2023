apt-get update
apt-get install mariadb-server -y

echo '
[client-server]

[mysqld]
skip-networking=0
skip-bind-address
' > /etc/mysql/my.cnf

service mysql restart

echo "
CREATE USER IF NOT EXISTS 'kelompokb11'@'%' IDENTIFIED BY 'passwordb11';
CREATE USER IF NOT EXISTS 'kelompokb11'@'localhost' IDENTIFIED BY 'passwordb11';
CREATE DATABASE IF NOT EXISTS dbkelompokb11;
GRANT ALL PRIVILEGES ON *.* TO 'kelompokb11'@'%';
GRANT ALL PRIVILEGES ON *.* TO 'kelompokb11'@'localhost';
FLUSH PRIVILEGES;
" > ~/script.sql

mysql < ~/script.sql



