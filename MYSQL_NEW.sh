source common.sh

if [ -z "$1" ]; then
  echo Input argument password is needed
  exit
fi

PRINT "Downloading MYSQL Repo files"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo
STAT $?

PRINT "Disable MYSQL 8 version"
dnf module disable mysql -y
STAT $?

PRINT "Install MYSQL"
yum install mysql-community-server -y
STAT $?


#sudo grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}'
#STAT $?

PRINT "Enabling MYSQL"
systemctl enable mysqld
STAT $?

PRINT "Restart MYSQL"
systemctl restart mysqld
STAT $?

echo show databases | mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD}

if [$? -ne 0 ];
then
  echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROBOSHOP_MYSQL_PASSWORD}';" > /tmp/root-pass-sql
  DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')
  cat /tmp/root-pass-sql | mysql --connect-expired-password -uroot -p"${DEFAULT_PASSWORD}"
fi