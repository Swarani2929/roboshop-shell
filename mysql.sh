source common.sh

print_head "Disabling mysql 8 version"
dnf module disable mysql -y &>>${log_file}
status_check $?

print_head "setup Mysql Repo"
cp ${code_dir}/configs/mysql.repo /etc/yum.repos.d/mysql.repo &>>${log_file}
status_check $?

print_head "Install mysql"
yum install mysql-community-server -y &>>${log_file}
status_check $?

print_head "Enabling mysql service"
systemctl enable mysqld &>>${log_file}
status_check $?

print_head "Starting mysql service"
systemctl start mysqld &>>${log_file}
status_check $?

print_head "Reset password from default password"
mysql_secure_installation --set-root-pass RoboShop@1 &>>${log_file}
status_check $?