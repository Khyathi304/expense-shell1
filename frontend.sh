#!/bin/bash

source ./common.sh

check_root

dnf install nginx -y &>>$LOGFILE
VALIDATE $? "Installing nginx" 

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "Enabling nginx" 

systemctl start nginx 
VALIDATE $? "starting nginx"

rm -rf /usr/share/nginx/html/*  &>>$LOGFILE
VALIDATE $? "Removing default nginx content" 

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOGFILE
VALIDATE $? "Downloading content"

cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>$LOGFILE
VALIDATE $? "Extracting content"

cp /home/ec2-user/expense-shell1/expense.conf /etc/nginx/default.d/expense.conf
VALIDATE $? "Copying content"

systemctl restart nginx
VALIDATE $? "Restart nginx"



