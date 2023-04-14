source common.sh
mysql_root_password=$1

if [ -z "$mysql_root_password" ]; then
  echo "Missing mysql password argument"
  exit 1
  fi
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
echo show databases | mysql -uroot -p${mysql_root_password} &>>${log_file}
if [ $? -ne 0 ]; then
 mysql_secure_installation --set-root-pass ${mysql_root_password}  &>>${log_file}
fi
status_check $?