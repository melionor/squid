#!/bin/bash
yes | apt-get install squid3

mv /etc/squid/squid.conf /etc/squid/squid.conf.old

wget --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/melionor/squid/main/squidconf

service squid restart
