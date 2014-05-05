yum -y clean all

# Remove traces of mac address from network configuration
rm /etc/udev/rules.d/70-persistent-net.rules
if [ -r /etc/sysconfig/network-scripts/ifcfg-eth0 ]; then
  sed -i /^HWADDR/d /etc/sysconfig/network-scripts/ifcfg-eth0
  sed -i /^UUID/d /etc/sysconfig/network-scripts/ifcfg-eth0
fi
