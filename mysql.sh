source common.sh

curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo

if [ $? -eq 0 ]; then
  echo Success
  else
  echo Failure
  exit

fi
dnf module disable mysql

yum install mysql-community-server -y

# systemctl enable mysqld
# systemctl start mysqld

