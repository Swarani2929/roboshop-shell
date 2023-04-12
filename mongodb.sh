source common.sh

print_head "setup MOngodb Repo"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}

print_head "Install MOngodb"
yum install mongodb-org -y &>>${log_file}

print_head "Update MOngodb listen address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${log_file}

print_head "Enable MOngodb"
systemctl enable mongod &>>${log_file}

print_head "Start MOngodb Service"
systemctl restart mongod &>>${log_file}

# Update config file from 127.0.0.1 with 0.0.0.0