source common.sh

print_head " Configure the Repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
status_check $?

print_head "Install Node.js"
yum install nodejs -y &>>${log_file}
status_check $?

print_head "Create Roboshop User"
useradd roboshop &>>${log_file}
status_check $?

print_head "Create Application directory"
mkdir /app &>>${log_file}
status_check $?

print_head "Delete Old content"
rm -rf /app/*  &>>${log_file}
status_check $?

print_head "Downloading App Content"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log_file}
status_check $?

cd /app

print_head "Extracting App Content"
unzip /tmp/catalogue.zip &>>${log_file}
status_check $?

print_head "Installing Nodejs dependencies"
npm install &>>${log_file}
status_check $?

print_head "Copy systemd service file"
cp ${code_dir}/configs/catalogue.service /etc/systemd/system/catalogue.service &>>${log_file}
status_check $?

print_head "Reload systemd"
systemctl daemon-reload &>>${log_file}
status_check $?

print_head "Enable Catalogue Service"
systemctl enable catalogue &>>${log_file}
status_check $?

print_head "Enable Catalogue Service"
systemctl restart catalogue &>>${log_file}
status_check $?

print_head "Copy mongodb repo"
cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
status_check $?

print_head "Install mongo client"
yum install mongodb-org-shell -y &>>${log_file}
status_check $?

print_head "Load Schema"
mongo --host mongodb.devops25.online </app/schema/catalogue.js &>>${log_file
status_check $?