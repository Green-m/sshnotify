# sshnotify 

A script to notify you when others login your server via ssh.

## install (Debian/ubuntu supported, centos/redhat still in process)

```
wget -N --no-check-certificate https://raw.githubusercontent.com/Green-m/sshnotify/master/install.sh && chmod +x install.sh && bash install.sh
```

## white list config

vim /etc/sshnotify/whitelist.config
```
white_user=(root test)
white_ip=(1.1.1.1 8.8.8.8)
```

That sshnotify would send notification except these situations below:

- The login user is `root` or `test` 

- The ip login from is `1.1.1.1` or `8.8.8.8`  


## email config 

vim /etc/sshnotify/whitelist.config

```
sendmailuser=xxxxx@gmail.com
sendmailpass=xxxxxxxx
mailserver=smtp.gmail.com:587
sendtouser=yyyyyy@gmail.com
```

*Notice*: After any config changed, run `service sshnotify restart` to reload.  

## Log

Verbose log is locate `/var/log/sshnotify/sshnotify.log`

