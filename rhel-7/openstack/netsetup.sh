
source ~/admin-openrc.sh
neutron net-create ext-net --shared --router:external --provider:physical_network external --provider:network_type flat         
neutron subnet-create ext-net $EXTERNAL_NETWORK_CIDR --name ext-subnet  --allocation-pool start=$FLOATING_IP_START,end=$FLOATING_IP_END   --disable-dhcp --gateway $EXTERNAL_NETWORK_GATEWAY

source ~/demo-openrc.sh
neutron net-create demo-net
neutron subnet-create demo-net $PRIVATE_NETWORK_CIDR   --name demo-subnet --gateway $PRIVATE_NETWORK_GATEWAY

neutron router-create main-router
neutron router-interface-add main-router demo-subnet
neutron router-gateway-set main-router ext-net



#neutron net-create private-net
#neutron subnet-create private-net --name private-subnet --gateway $PRIVATE_NETWORK_GATEWAY $PRIVATE_NETWORK_CIDR


