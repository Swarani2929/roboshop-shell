source common.sh
mysql_root_password=$1

if [ -z "${1}" ]; then
  echo "Missing Mysql Root Password argument"
  exit 1
fi

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

print_head "set password from default password"
mysql_secure_installation --set-root-pass ${mysql_root_[password]} &>>${log_file}
status_check $?