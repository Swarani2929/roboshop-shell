source common.sh

print_head "Disabling mysql 8 version"
dnf module disable mysql -y &>>${log_file}
status_check $?

print_head "Downloading mysql repo"
cp ${code_dir}/configs/mysql.repo /etc/yum.repos.d/mysql.repo &>>${log_file}
status_check $?

print_head "Installing mysql"
yum install mysql-community-server -y &>>${log_file}
status_check $?

print_head "Enabling mysqld"
systemctl enable mysqld &>>${log_file}
status_check $?

print_head "Enabling mysqld"
systemctl start mysqld &>>${log_file}
status_check $?

print_head "Set Password"
mysql_secure_installation --set-root-pass RoboShop@1 &>>${log_file}
status_check $?