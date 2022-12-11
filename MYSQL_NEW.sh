curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo

if [ $? -eq 0 ]; then
  echo Success
  else
  echo Failure
  exit
fi

dnf module disable mysql -y

if [ $? -eq 0 ]; then
  echo Success
  else
  echo Failure
  exit
fi

yum install mysql-community-server -y

if [ $? -eq 0 ]; then
  echo Success
  else
  echo Failure
  exit
fi

sudo grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}'
if [ $? -eq 0 ]; then
  echo Success
  else
  echo Failure
  exit
fi

systemctl enable mysqld
if [ $? -eq 0 ]; then
  echo Enabled mysql
  else
  echo Failure
  exit
fi

systemctl restart mysqld

if [ $? -eq 0 ]; then
  echo Restarted mysql
  else
  echo Failure
  exit
fi

echo hello world

