#!/usr/bin/env sh
set -e

sudo su <<OSCONFIG
echo 'vm.overcommit_memory = 1' >> /etc/sysctl.conf
echo 'vm.max_map_count=262144' >> /etc/sysctl.conf
sysctl vm.overcommit_memory=1
sysctl -w vm.max_map_count=262144

echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo never > /sys/kernel/mm/transparent_hugepage/defrag

cp disable-transparent-hugepages /etc/init.d/disable-transparent-hugepages
sudo chmod 755 /etc/init.d/disable-transparent-hugepages
sudo update-rc.d disable-transparent-hugepages defaults
OSCONFIG