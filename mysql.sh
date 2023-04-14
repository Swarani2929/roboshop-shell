source common.sh

dnf module disable mysql -y

yum install mysql-community-server -y

mysql_secure_installation --set-root-pass RoboShop@1