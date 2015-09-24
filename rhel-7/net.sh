#/bin/sh!
devicename=""
ipaddr=""
I=1
M=1
hostname=`hostname`
nmcli device show |\
while read line; do 
	NAME=`echo $line|awk '{print $1}'`
	VALUE=`echo $line|awk '{print $2}'`
	
	case "$NAME" in
		"GENERAL.DEVICE:")
			devicename=$VALUE;
			;;
		"IP4.ADDRESS[1]:")
			ipaddr=`echo $VALUE|awk -F"/" '{print $1}'`;
			;;
		"GENERAL.TYPE:")
			type=$VALUE;
			;;
	esac

	if [ -z "$line" ]; then
#		echo "ZZ devicename=$devicename ipaddr=$ipaddr type=$type";
		ip3=`echo $ipaddr| awk -F"." '{print $3}'`
		case "$ip3" in
			 "200")
                          	 maindev=$devicename;
                                 mainip=$ipaddr;
                                 ip4=`echo $ipaddr| awk -F"." '{print $4}'`
                                 seconip="172.16.100.$ip4";
#                                 echo "maindev=$devicename mainip=$ipaddr ip4=$ip4 seconip=$seconip"
                                 ;;
                         "0")
#                                 echo "lo=$devicename"
                                 ;;
                         "")
                         	seconddev=$devicename;
#                         	echo "maindev=$maindev seconddev=$seconddev mainip=$mainip seconip=$seconip"
                esac
 	 	devicename="";
                ip3="";
                ip4="";
                ipaddr="";

	fi

	if [ ! -z "$seconddev"  -a  "$I" =  "1" ]; then
#		echo "nmcli  c add type ethernet  ifname $seconddev ip4 $seconip/24";
		sconuuid=`nmcli -f UUID,DEVICE   c s | grep $seconddev| awk '{print $1}'`
		echo nmcli d disconnect $seconddev
		nmcli d disconnect $seconddev
		echo nmcli  c add con-name $seconddev type ethernet  ifname $seconddev ip4 $seconip/24
		nmcli  c add con-name $seconddev type ethernet  ifname $seconddev ip4 $seconip/24
		echo nmcli c delete $sconuuid
		nmcli c delete $sconuuid
		echo nmcli d connect $seconddev
		nmcli d connect $seconddev
		I=0;
	fi 

	if [ ! -z "$maindev"  -a  "$M" =  "1" ]; then
		mconuuid=`nmcli -f UUID,DEVICE   c s | grep $maindev| awk '{print $1}'`
		echo nmcli d disconnect $maindev
                nmcli d disconnect $maindev
                echo "nmcli  c add con-name $maindev type ethernet  ifname $maindev ip4 $mainip/24";
		nmcli  c add con-name $maindev type ethernet  ifname $maindev ip4 $mainip/24
		echo nmcli  c mod $maindev ipv4.method manual ipv4.addr $mainip/24  +ipv4.dns "195.19.225.238" +ipv4.dns "195.19.225.253" ipv4.gateway "192.168.200.254"
		nmcli  c mod $maindev ipv4.method manual ipv4.addr $mainip/24  +ipv4.dns "195.19.225.238" +ipv4.dns "195.19.225.253" +ipv4.dns 195.19.225.253 +ipv4.dns 195.70.196.210  ipv4.gateway "192.168.200.254"

		echo nmcli c delete $mconuuid
                nmcli c delete $mconuuid

		echo nmcli d connect $maindev
                nmcli d connect $maindev

		hostnamectl --static set-hostname $hostname
		echo -e "$mainip\t$hostname.cloud.spbu.ru\t$hostname" >> /etc/hosts
                M=0;
        fi



done


#if [ ! -z "$seconddev" ]; then
#fi


	

