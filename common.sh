code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

print_head(){
  echo -e "\e[35m$1\e[0m"
}

status_check()
{
if [ $1 -eq 0 ]; then
 echo Success
else
 echo Failure
 echo "Read the log file ${log_file} for more information about error"
 exit 1
fi
}

schema_setup() {

  if [ "${schema_type}" == "mongo" ]; then
  print_head "Copy mongodb repo"
    cp ${code_dir}/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}
    status_check $?

    print_head "Install mongo client"
    yum install mongodb-org-shell -y &>>${log_file}
    status_check $?

    print_head "Load Schema"
    mongo --host mongodb.devops25.online </app/schema/${component}.js &>>${log_file}
    status_check $?
    elfi [ "${schema_type}" == "mysql" ]; then
      print_head "Installing mysql"
      yum install mysql -y
      status_check $?
      mysql -h mysql.devops25.online -uroot -pRoboShop@1 < /app/schema/shipping.sql
      systemctl restart shipping
      fi
}

app_prereq_setup() {

print_head "Create Roboshop ${component}"
  id roboshop &>>{log_file}
  if [ $? -ne 0 ]; then
   useradd roboshop &>>${log_file}
  fi
  status_check $?

  print_head "Create Application directory"
  if [ ! -d /app ]; then
    mkdir /app &>>${log_file}
  fi
  status_check $?

  print_head "Delete Old content"
  rm -rf /app/*  &>>${log_file}
  status_check $?

  print_head "Downloading App Content"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}
  status_check $?

  cd /app

  print_head "Extracting App Content"
  unzip /tmp/${component}.zip &>>${log_file}
  status_check $?

}
nodejs() {

  print_head " Configure the Repo"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}
  status_check $?

  print_head "Install Node.js"
  yum install nodejs -y &>>${log_file}
  status_check $?

  app_prereq_setup

  print_head "Installing Nodejs dependencies"
  npm install &>>${log_file}
  status_check $?

  print_head "Copy systemd service file"
  cp ${code_dir}/configs/${component}.service /etc/systemd/system/${component}.service &>>${log_file}
  status_check $?

  print_head "Reload systemd"
  systemctl daemon-reload &>>${log_file}
  status_check $?

  print_head "Enable ${component} Service"
  systemctl enable ${component} &>>${log_file}
  status_check $?

  print_head "Enable ${component} Service"
  systemctl restart ${component} &>>${log_file}
  status_check $?

schema_setup
}

java () {
  print_head "Install maven"
  yum install maven -y
  status_check $?
  print_head "Add Roboshop user"

  app_prereq_setup

  mvn clean package
  mv target/shipping-1.0.jar shipping.jar
  schema_setup
  systemctl daemon-reload
  systemctl enable shipping
  systemctl start shipping


}