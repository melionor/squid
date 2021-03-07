#!/bin/bash

mv /etc/squid/squid.conf /etc/squid/squid.conf.old

    /bin/rm -rf /etc/squid
    touch /etc/squid/passwd
    /bin/rm -f /etc/squid/squid.conf
    /usr/bin/touch /etc/squid/blacklist.acl
    /usr/bin/wget --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/melionor/squid/main/squidconf
    /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
    /sbin/iptables-save
    systemctl enable squid
    systemctl restart squid
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

/usr/bin/htpasswd -b -c /etc/squid/passwd $user $pass
user=$(< /dev/urandom tr -cd 0-9 | head -c10)
pass=$(< /dev/urandom tr -cd 0-9 | head -c10)
ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1
echo port=51230
echo user = $user
echo pass = $pass
