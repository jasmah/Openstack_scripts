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

neutron net-create \
    --tenant-id ${TENANT_ID} \
    cookbook_network_1


neutron subnet-create \
    --tenant-id ${TENANT_ID} \
    --name cookbook_subnet_1 \
    cookbook_network_1 \
    10.200.0.0/24

neutron router-create \
    --tenant-id ${TENANT_ID} \
    cookbook_router_1

ROUTER_ID=$(neutron router-list \
  | awk '/\ cookbook_router_1\ / {print $2}')

SUBNET_ID=$(neutron subnet-list \
  | awk '/\ cookbook_subnet_1\ / {print $2}')

neutron router-interface-add \
     ${ROUTER_ID} \
     ${SUBNET_ID}

UBUNTU=$(nova image-list \
  | awk '/\ trusty-image\ / {print $2}')
echo ${UNBUNTU}

NET_ID=$(neutron net-list | awk '/cookbook_network_1/ {print $2}')
echo ${NET_ID}

nova boot --flavor m1.medium --block-device source=image,id=${UBUNTU},shutdown=preserve,dest=volume,size=15,bootindex=0 --key_name demokey --nic net-id=${NET_ID} --config-drive=true test1
