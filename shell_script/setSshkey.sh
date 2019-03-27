#!/bin/bash
username="hduser"
key_file="key.file"
authorized_key="authorized_keys"
passwd="123456"
home="/home/hduser"
expect_cmd="$(which expect)"
prompt="]#|~?"


while read ip
do
${expect_cmd} << EOF
set timeout 5
spawn ssh -t   ${username}@$ip
expect {
        "(yes/no)?"    { send "yes\r";exp_continue }
         "*password:*"    { send "${passwd}\n" }
}
expect -re    "${prompt}"            { send "ssh-keygen -t rsa\r" }
expect {
         "Enter file in which to save the key*" { send "\r";exp_continue }
         "Overwrite (y/n)?" { send "y\r";exp_continue }
         "Enter passphrase (empty for no passphrase):" { send "\r";exp_continue }
         "Enter same passphrase again:" { send "\r" }
         "*${prompt}*"   { send "exit 1\r" }
}
expect eof
EOF
done < ip.txt

while read ip
do
${expect_cmd}  << EOF
spawn scp $username@$ip:${home}/.ssh/id_rsa.pub  $key_file
set timeout 5
expect {
  "yes/no"  	{ send "yes\r"; exp_continue}
  "password:" 	{ send "${passwd}\r" }
}
expect -re "${prompt}" { send "exit 1\r" }
expect eof
EOF
cat ${key_file} >> $authorized_key
done < ip.txt


while read ip
do
${expect_cmd}  << EOF
spawn scp ${authorized_key} $username@$ip:${home}/.ssh/
set timeout 5
expect {
  "yes/no"      { send "yes\r"; exp_continue}
  "password:"   { send "${passwd}\r" }
}
expect -re "${prompt}" { send "exit 1\r" }
expect eof
EOF
done < ip.txt

if [ -e ${key_file} ];then
  rm -r ${key_file}
fi
if [ -e ${authorized_key} ];then
  rm -r ${authorized_key}
fi
