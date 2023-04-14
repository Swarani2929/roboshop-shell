source common.sh
component=rabbitmq


print_head "Setup Erlang Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>{log_fine}
status_check $?

print_head "Setup Rabbitmq repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>{log_fine}
status_check $?

print_head "Installing Rabbitmq"
yum install rabbitmq-server erlang -y &>>{log_fine}
status_check $?

print_head "Start Rabbitmq service"
systemctl enable rabbitmq-server &>>{log_fine}

print_head "Start rabbitmq service"
systemctl start rabbitmq-server &>>{log_fine}

rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"