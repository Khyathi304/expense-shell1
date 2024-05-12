#!/bin/bash

source ./common.sh

check_root

echo "Please enter DB password:"
read -s mysql_root_password

dnf module disable nodejs -y &>>$LOGFILE
VALIDATE $? "Disabling default nodejs" 

dnf module enable nodejs:20 -y &>>$LOGFILE
VALIDATE $? "Enabling nodejs 20 Version"

dnf install nodejs -y &>>$LOGFILE
VALIDATE $? "Install  nodejs"

id expense &>>$LOGFILE
if [ $? -ne 0 ]
then
useradd expense &>>$LOGFILE
VALIDATE $? "Adding User "
else
echo -e "User already added $Y Skip $N "
fi

mkdir -p /app &>>$LOGFILE
VALIDATE $? "Creating the directorty" 

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE
VALIDATE $? "Downloading the code"

cd /app
rm -rf /app/*
unzip /tmp/backend.zip &>>$LOGFILE
VALIDATE $? "Extracting backend code"

npm install &>>$LOGFILE
VALIDATE $? "install dependencies"

cp /home/ec2-user/expense-shell/backend.service /etc/systemd/system/backend.service &>>$LOGFILE
VALIDATE $? "Copied backend service"

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "Daemon-reload "

systemctl start backend &>>$LOGFILE
VALIDATE $? "start backend"

systemctl enable backend &>>$LOGFILE
VALIDATE $? "Enable backend"

dnf install mysql -y &>>$LOGFILE
VALIDATE $? "Installing Sql Client"

mysql -h db.daws304.online -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE
VALIDATE $? "Loading schema"

systemctl restart backend &>>$LOGFILE
VALIDATE $? "Restarting backend"





