
#!/bin/bash

source ./common.sh

check_root

echo "Please enter DB password:"
read -s mysql_root_password

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installing MySql server"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enable MySql server"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "Start MySql server"

#mysql_secure_installation --set-root-pass ExpenseApp@1 &>>$LOGFILE
#VALIDATE $? "Setting up root password"

mysql -h db.daws304.online -uroot -p${mysql_root_password} -e 'SHOW DATABASES;' &>>$LOGFILE
if [ $? -ne 0 ]
then
mysql_secure_installation --set-root-pass ${mysql_root_password} &>>$LOGFILE
VALIDATE $? "mysql is installing::"
else
echo -e "mysql is already installed please skip.. $Y SKIPPING $N"
fi

