#!/bin/bash
# Code by Green-m
white_config=/etc/sshnotify/whitelist.config
log_file=/var/log/sshnotify/sshnotify.log
mail_config=/etc/sshnotify/email.config

# The matchine identity name, change it if you want.
matchine_name=`uname -rn`

white_user=()
white_ip=()
res1=1
res2=1

if [[ -f $white_config ]]; then 
  . $white_config
fi

if [[ -f $mail_config ]]; then 
  . $mail_config
fi

function log_to_file() {
  echo "$(date +'%Y-%m-%d %H:%M:%S')  $@" >> $log_file
}

function emailsend() {
    local text="$1 have logged in $matchine_name from $2 at $3"
    log_to_file `sendEmail -f $sendmailuser -xu $sendmailuser -xp $sendmailpass -t $sendtouser -s $mailserver -u "SSH Login Notification" -m $text -o tls=yes`
}

#check_contain_arr 'xxx' arr[@]
function check_contain_arr () {
  local e=$1
  local arr=("${!2}")
  for i in ${arr[@]}; do [[ $i == $e ]] && return 1; done
  return 0;
}

while inotifywait -q -e modify /var/log/wtmp; do
 sleep 1
 read user ttyname ip start end <<< $(last -n 1 --time-format iso| awk 'NR==1{print $1,$2,$3,$4,$5}')
 log_to_file $user $ttyname $ip 

 # To reduce twice notify when login and logout,
 # only send mail when login.
 [[ $end != 'still' ]] && continue

 if [[ -n "$white_user" ]]; then
    check_contain_arr $user white_user[@] 
    res1=$?
 fi

 if [[ -n "$white_ip" ]]; then
    check_contain_arr $ip white_ip[@] 
    res2=$?
 fi

 if [[ $res1 == 0 ]] || [[ $res2 == 0 ]]; then
    emailsend $user $ip $start
 fi
 
done


