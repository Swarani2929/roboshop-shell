code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

print_head(){
  echo -e "\e[35m$1\e[0m"
}

statuc_check()

{
if [ $? -eq 0 ]; then
 echo Success
else
 echo Failure
fi
}