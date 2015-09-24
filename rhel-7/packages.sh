#/bin/sh!
packages="net-tools autofs nfs-utils vim bind-utils ntp ntpdate ntp-doc yum-plugin-priorities wget"
yum -y install $packages
systemctl enable autofs
systemctl start autofs
ntpdate -b 192.168.200.254
sed s/"server .*"/"server 192.168.200.254"/g -i /etc/ntp.conf
systemctl enable ntpd
systemctl start ntpd
