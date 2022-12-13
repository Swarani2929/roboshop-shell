STAT() {
  if [ $? -eq 0 ]; then
    echo Success
    else
    echo Failure
    exit
  fi

}

curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo
STAT $?

dnf module disable mysql -y
STAT $?

yum install mysql-community-server -y
STAT $?

sudo grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}'
STAT $?

systemctl enable mysqld
STAT $?

systemctl restart mysqld
STAT $?


