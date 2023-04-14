source common.sh

dnf module disable mysql -y

print_head "setup Mysql Repo"
cp ${code_dir}/configs/mysql.repo /etc/yum.repos.d/mysql.repo &>>${log_file}
status_check $?

yum install mysql-community-server -y

mysql_secure_installation --set-root-pass RoboShop@1