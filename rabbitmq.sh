source common.sh
component=rabbitmq

Roboshop_app_password=$1
if [ -z "${Roboshop_app_password}" ]; then
  echo -e "\e[31mMissing Roboshop app Password argument\e[0m"
  exit 1
fi
print_head "Setup Erlang Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>{log_file}
status_check $?

print_head "Setup Rabbitmq repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>{log_file}
status_check $?

print_head "Installing Rabbitmq"
yum install rabbitmq-server erlang -y &>>{log_file}
status_check $?

print_head "Start Rabbitmq service"
systemctl enable rabbitmq-server &>>{log_file}
status_check $?

print_head "Start rabbitmq service"
systemctl start rabbitmq-server &>>{log_file}
status_check $?

print_head "Add Application user"
rabbitmqctl list_users | grep roboshop &>>{log_file}
if [ $? -ne 0 ]; then
 rabbitmqctl add_user roboshop ${Roboshop_app_password} &>>{log_file}
fi
status_check $?

print_head "configure set_permissions"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>{log_file}
status_check $?