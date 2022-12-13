  STAT() {
    if [ $? -eq 0 ]; then
      echo Success
      else
      echo Failure
      exit
    fi
  }
  PRINT() {
    echo -e "\e[33m$1\e[0m"
  }