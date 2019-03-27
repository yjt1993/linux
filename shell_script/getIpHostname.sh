#!/bin/bash
# get remote hosts hostname
host_file="hostname_result.txt"
ip_file="ip.txt"
username="hduser"
passwd="123456"
expect_cmd=$(which expect)
prompt=''
hostname_cmd=$(which hostname)
hosts="hosts"

if [ "$username" == "root" ];then
    prompt="#"
else
    prompt="$"
fi

while read  ip
do
${expect_cmd}   << EOF
set timeout 5
set output_file [ open $host_file a ]
spawn ssh -t  ${username}@$ip
expect { 
	"(yes/no)?" { send "yes\r";exp_continue }
         "password:" { send "${passwd}\r";exp_continue }
         "*$prompt*" { send "${hostname_cmd}\r" }
}
expect -re "\r\n(.*)\r\n(.*)$prompt"  { puts \$output_file \$expect_out(1,string) }
close \$output_file
expect  "*$prompt*" { send "exit 1\r" }
expect eof
EOF
done < ip.txt
paste -d ' ' $ip_file $host_file > $hosts
