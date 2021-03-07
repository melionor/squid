#!/bin/bash
    /usr/bin/wget --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/melionor/squid/main/squidconf
IP_ALL=$(/sbin/ip -4 -o addr show scope global | awk '{gsub(/\/.*/,"",$4); print $4}')

IP_ALL_ARRAY=($IP_ALL)

SQUID_CONFIG="\n"

for IP_ADDR in ${IP_ALL_ARRAY[@]}; do
    ACL_NAME="proxy_ip_${IP_ADDR//\./_}"
    SQUID_CONFIG+="acl ${ACL_NAME}  myip ${IP_ADDR}\n"
    SQUID_CONFIG+="tcp_outgoing_address ${IP_ADDR} ${ACL_NAME}\n\n"
done

echo "Updating squid config"

echo -e $SQUID_CONFIG >> /etc/squid/squid.conf

echo "Restarting squid..."

systemctl restart squid

echo "Done"


user=$(< /dev/urandom tr -cd 0-9 | head -c10)
pass=$(< /dev/urandom tr -cd 0-9 | head -c10)
htpasswd -c -b /etc/squid/passwd $user $pass
ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1
echo port=51230
echo user = $user
echo pass = $pass
