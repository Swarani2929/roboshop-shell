source common.sh
component=dispatch


Roboshop_app_password=$1
if [ -z "${Roboshop_app_password}" ]; then
  echo -e "\e[31mMissing Roboshop app Password argument\e[0m"
  exit 1
fi

golang