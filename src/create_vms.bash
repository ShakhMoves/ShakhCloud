#!/bin/bash
# In The Name Of God
# ========================================
# [] File Name : create_vms.bash
#
# [] Creation Date : 03-03-2016
#
# [] Created By : Parham Alvani (parham.alvani@gmail.com)
# =======================================

for c in CloudManagement CloudController CloudCompute1 CloudBlock1 CloudObject1; do
	echo "Creating $c"
	lxc-create -B btrfs -t ubuntu-cloud --name $c
	if [ $? -ne 0 ]; then
		echo "Error in creating $c"
		exit
	fi
	echo "lxc.cgroup.memory.limit_in_bytes = 512M" >> /var/lib/lxc/$c/config
	echo "10.0.3.11 CloudController" >> /var/lib/lxc/$c/rootfs/etc/hosts
	echo "10.0.3.31 CloudCompute1" >> /var/lib/lxc/$c/rootfs/etc/hosts
	echo "10.0.3.41 CloudBlock1" >> /var/lib/lxc/$c/rootfs/etc/hosts
	echo "10.0.3.51 CloudObject1" >> /var/lib/lxc/$c/rootfs/etc/hosts
done

# Configure networking
echo "lxc.network.ipv4 = 10.0.3.05" >> /var/lib/lxc/CloudManagement/config
echo "lxc.network.ipv4 = 10.0.3.11" >> /var/lib/lxc/CloudController/config
echo "lxc.network.ipv4 = 10.0.3.31" >> /var/lib/lxc/CloudCompute1/config
echo "lxc.network.ipv4 = 10.0.3.41" >> /var/lib/lxc/CloudBlock1/config
echo "lxc.network.ipv4 = 10.0.3.51" >> /var/lib/lxc/CloudObject1/config

for c in CloudManagement CloudController CloudCompute1 CloudBlock1 CloudObject1; do
	echo "Starting $c"
	lxc-start --name $c
done
