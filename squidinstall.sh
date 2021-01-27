#!/bin/bash

yes | apt-get install squid3

mv /etc/squid/squid.conf /etc/squid/squid.conf.old

wget --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/melionor/squid/main/squidconf

user=$(< /dev/urandom tr -cd a-zA-Z0-9 | head -c10)
pass=$(< /dev/urandom tr -cd a-zA-Z0-9 | head -c10)
ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1
echo port=51230
echo user = $user
echo pass = $pass

/usr/bin/htpasswd -b -c /etc/squid/passwords $user $pass

service squid restart
