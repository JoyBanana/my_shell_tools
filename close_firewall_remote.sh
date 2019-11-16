#!/bin/bash


for i in `cat ip_list`
do

expect <<EOF
set timeout -1
spawn ssh $i;

expect "*#" 
send "systemctl stop firewalld.service\r"
expect "*#" 
send "systemctl disable firewalld.service\r"
expect "*#"
send "setenforce 0\r"
expect "*#"
send "sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config\r"
expect "*#"
send "exit\r"
expect eof
EOF

done
