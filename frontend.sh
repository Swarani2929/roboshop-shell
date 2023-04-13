
source common.sh

print_head "Installing nginx"
yum install nginx -y &>>${log_file}
if [ $? -eq 0 ]; then
 echo Success
else
 echo Failure
fi

print_head "Removing Old content"
rm -rf /usr/share/nginx/html/* &>>${log_file}
echo $?

print_head "Downloading frontend content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}
echo $?

print_head "Extracting Downloaded Frontend Content"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>${log_file}
echo $?

print_head "Copying nginx Config for Roboshop"
cp ${code_dir}/configs/nginx-roboshop.config /etc/nginx/default.d/roboshop.conf &>>${log_file}
echo $?

print_head "Enabling nginx"
systemctl enable nginx &>>${log_file}
echo $?

print_head "Starting nginx"
systemctl restart nginx &>>${log_file}
echo $?


