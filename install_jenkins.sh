#!/bin/bash

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOG=jenkins-install.log
USER_ID=$(id -u)
NAME=grep -E '^(NAME)=' /etc/os-release
IFS="="
set $NAME
echo $2

if [ $USER_ID -ne 0 ]; then
	echo  -e "$R You are not the root user, you dont have permissions to run this $N"
	exit 1
fi
VALIDATE(){
	if [ $1 -ne 0 ]; then
		echo -e "$2 ... $R FAILED $N"
		exit 1
	else
		echo -e "$2 ... $G SUCCESS $N"
	fi

}
apt update  -y &>>$LOG
VALIDATE $? "Updating packages"

wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add - &>>$LOG
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list' &>>$LOG

apt update -y &>>$LOG
VALIDATE $? "Updating Packages"

apt install jenkins &>>$LOG
VALIDATE $? "Installing Jenkins"

systemctl start jenkins &>>$LOG
VALIDATE $? "Starting Jenkins"
systemctl status jenkins &>>$LOG
VALIDATE $? "Jenkins Status"

sudo cat /var/lib/jenkins/secrets/initialAdminPassword
echo " $G All Good. Jenkins is Working. $N"