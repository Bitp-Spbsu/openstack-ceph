nmcli  c add type Bridge con-name br-ex  ifname br-ex ip4 $EXTINTERFACE
nmcli  c mod br-ex  ipv4.method manual  +ipv4.gateway $EXTGATEWAY +ipv4.dns $DNS1 +ipv4.dns $DNS2
#nmcli con add type bridge-slave con-name $DEVNAME ifname $DEVNAME master br-ex
systemctl restart NetworkManager.service

