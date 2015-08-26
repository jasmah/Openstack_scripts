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
    cookbook_network_2


neutron subnet-create \
    --tenant-id ${TENANT_ID} \
    --name cookbook_subnet_2 \
    cookbook_network_2 \
    11.200.0.0/24

UBUNTU=$(nova image-list \
  | awk '/\ trusty-image\ / {print $2}')
#printf ${UBUNTU}
#printf "\n"

NET_ID=$(neutron net-list | awk '/cookbook_network_2/ {print $2}')
#printf ${NET_ID}
#printf "\n"

nova boot --flavor 1 --image ${UBUNTU} --key_name demokey --nic net-id=${NET_ID} vm3



