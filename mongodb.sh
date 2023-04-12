source common.sh

print_head "setup MOngodb Repo"
cp configs/mongodb.repo /etc/yum.repos.d/mongo.repo

print_head "Install MOngodb"
yum install mongodb-org -y

print_head "Enable MOngodb"
systemctl enable mongod

print_head "Start MOngodb Service"
systemctl start mongod

# Update config file from 127.0.0.1 with 0.0.0.0