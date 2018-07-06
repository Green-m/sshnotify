#!/bin/bash

white_user=(root)
white_ip=(192.168.77.1)
res1=1
res2=1

function emailsend() {
    local text="$1 login from $2 at $3"
    #sendEmail -f xxxxxxxxxxxxxxxxx@gmx.com -xu 'xxxxxxxxxx' -xp 'xxxxxxxxxxxxxxxxxx' -t xxxxxxxxxxxxxx@gmail.com -s mail.gmx.com:587 -u "SSH Login Warning" -m $text -o tls=yes -q
    echo "Email sended"
}

#check_contain_arr 'xxx' arr[@]
function check_contain_arr () {
  local e=$1
  local arr=("${!2}")
  for i in ${arr[@]}; do [[ $i == $e ]] && return 1; done
  return 0;
}

# function check_contain_hash () {
#   local key value match="$1"
#   shift
#   for e; do [[ "$e" == "$match" ]] && return 0; done
#   return 1
# }

while inotifywait -q -e modify /var/log/wtmp; do
 sleep 1
 read user ttyname ip start end <<< $(last -n 1 --time-format iso| awk 'NR==1{print $1,$2,$3,$4,$5}')
 #echo $user $ttyname $ip $start $end

 # To reduce twice notify when login and logout,
 # only send mail when login.
 [[ $end != 'still' ]] && continue

 if [[ -n "$white_user" ]]; then
    #echo $user ${white_user[@]}
    check_contain_arr $user white_user[@] 
    res1=$?
    #echo "res1 is " $res1
 fi

 if [[ -n "$white_ip" ]]; then
    check_contain_arr $ip white_ip[@] 
    res2=$?
    #echo "res2 is " $res2
 fi

 if [[ $res1 == 0 ]] || [[ $res2 == 0 ]]; then
    emailsend $user $ip $start
 fi
 
done


