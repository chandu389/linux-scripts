#!/bin/bash

source openrc-f5rdcpod-admin
alias openstack="openstack --insecure"
networks_list=(${1//,/ })
echo "####################"
for network in "${networks_list[@]}"; do
  echo "Network: $network"
  subnets=$(openstack network show $network -c subnets -f value --insecure)
  subnets_list=(${subnets//,/ })
  for subnet in "${subnets_list[@]}"; do
    echo "********************"
    echo "Subnet: $subnet"
    echo $(openstack subnet show $subnet -c name -c cidr -c gateway_ip -f value --insecure)
  done
  echo "####################"
done
