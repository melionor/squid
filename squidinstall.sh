#!/bin/bash
yes | apt-get install squid3

mv /etc/squid/squid.conf /etc/squid/squid.conf.old

wget --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/melionor/squid/main/squidconf

user=$tr -cd 0-9 < /dev/urandom | head -c 12 ; echo ""
pass=$tr -cd 0-9 < /dev/urandom | head -c 12 ; echo ""

/usr/bin/htpasswd -b -c /etc/squid/passwords $user $pass

service squid restart
