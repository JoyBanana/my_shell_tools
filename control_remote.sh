#!/bin/bash
#apt install expetc -y

iparray=(
'10.66.1.235'
'10.66.1.236'
'10.66.1.238'
'10.66.3.153'
'10.66.3.154'
'10.66.3.155'
'10.66.3.156'
'10.80.1.10'
'10.80.1.11'
'10.80.1.14'
'10.80.1.15'
'10.80.1.16'
'10.80.1.3'
'10.80.1.4'
'10.80.1.5'
'10.80.1.6'
'10.80.1.8'
'10.80.1.9'
'10.80.11.1'
'10.80.11.3'
'10.80.11.4'
'10.80.13.1'
'10.80.13.3'
'10.80.13.4'
'10.80.13.6'
'10.80.3.10'
'10.80.3.11'
'10.80.3.13'
'10.80.3.14'
'10.80.3.15'
'10.80.3.16'
'10.80.3.17'
'10.80.3.4'
'10.80.3.6'
'10.80.3.7'
'10.80.3.9'
)
change(){
expect <<EOF
set timeout 5
spawn ssh root@$testip
expect {
"*yes/no*" {
     send "yes\r"; exp_continue
} "*assword*" {
     send "Abcd@1234\r"}
}
expect "*#"
send "wget 10.90.0.2:10101/blegate1012.ipk \r"
expect "*#" 
send "opkg install blegate1012.ipk \r"
expect "*#" 
send "killall blegate\r"
expect "*#" 
send "reboot && exit\r"
expect eof
EOF
}
for i in {0..35}
do
	testip=${iparray[i]}
	change
done
