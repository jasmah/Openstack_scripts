#!/bin/sh

export OS_TENANT_NAME=cookbook
export OS_USERNAME=admin
export OS_PASSWORD=openstack
export OS_AUTH_URL=https://192.168.100.200:5000/v2.0/
export OS_NO_CACHE=1
export OS_KEY=/vagrant/cakey.pem
export OS_CACERT=/vagrant/ca.pem

# Aliases for insecure SSL
alias nova='nova --insecure'
alias keystone='keystone --insecure'
alias neutron='neutron --insecure'
alias glance='glance --insecure'
alias cinder='cinder --insecure'

TENANT_ID=$(keystone tenant-list \
   | awk '/\ cookbook\ / {print $2}')

ROUTER_ID=$(neutron router-list \
  | awk '/\ cookbook_router_1\ / {print $2}')

NET_ID=$(neutron net-list | awk '/cookbook_network_1/ {print $2}')

SUBNET_ID=$(neutron subnet-list | awk '/cookbook_subnet_1/ {print $2}')

NOVA_VM1=$(nova list | awk '/test1/ {print $2}')


neutron router-interface-delete ${ROUTER_ID} ${SUBNET_ID}
neutron router-delete ${ROUTER_ID}
neutron net-delete ${NET_ID}
nova delete ${NOVA_VM1}



	
