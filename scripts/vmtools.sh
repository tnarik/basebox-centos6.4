#rpm -Uhv http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

VAGRANTUSER='vagrant'

yum -y install gcc make kernel-devel-`uname -r` perl fuse-libs patch
#Maybe 'dkms' -> DKMS (Dynamic Kernel Module Support) as per https://wiki.centos.org/HowTos/Virtualization/VirtualBox/CentOSguest 

case "$PACKER_BUILDER_TYPE" in 
virtualbox*)
  # Issue https://forums.virtualbox.org/viewtopic.php?f=3&t=69567 -> OpenGL support module [FAILED]
  # Installing the virtualbox guest additions
  mkdir /tmp/vboxguest_mnt
  mount -o loop /home/${VAGRANTUSER}/VBoxGuestAdditions.iso /tmp/vboxguest_mnt

  # If patch were required/useful
  #echo "Testing VBoxGuestAdditions patch"
  #sh /mnt/VBoxLinuxAdditions.run --noexec --target /tmp/tmp_vbox
  #cd /tmp/tmp_vbox
  #mkdir /tmp/tmp_vbox2
  #tar jxvf VBoxGuestAdditions-amd64.tar.bz2 -C /tmp/tmp_vbox2
  #cd /tmp/tmp_vbox2/src/vboxguest-5.0.4/vboxvideo/
  #patch -p0 < /tmp/el6.patch
  #cd /tmp/tmp_vbox2
  #tar jcvf /tmp/tmp_vbox/VBoxGuestAdditions-amd64.tar.bz2 *
  #cd /tmp/tmp_vbox
  #./install.sh
  #rm -rf /tmp/tmp_vbox2
  #rm -rf /tmp/tmp_vbox

  # If no patch is applied
  sh /tmp/vboxguest_mnt/VBoxLinuxAdditions.run

  umount /tmp/vboxguest_mnt
  rm -rf /home/${VAGRANTUSER}/VBoxGuestAdditions.iso
  ;;
vmware*)
  mkdir /tmp/vmwaretools_mnt
  mount -o loop /home/${VAGRANTUSER}/VMWareTools.iso /tmp/vmwaretools_mnt

  mkdir /tmp/vmwaretools_tmp
  cd /tmp/vmwaretools_tmp
  gunzip -c /tmp/vmwaretools_mnt/VMwareTools-*.tar.gz | tar xf -
#  # Fix for some versions of VMware as per http://kb.vmware.com/selfservice/microsites/search.do?language=en_US&cmd=displayKC&externalId=2057912 (2057912)
#  /opt/csw/bin/gsed -i -e 's#!/bin/sh#!/bin/bash#g' ./vmware-tools-distrib/installer/services.sh
  # Continue installation
  ./vmware-tools-distrib/vmware-install.pl -d

  cd /
  umount /tmp/vmwaretools_mnt
  rm -rf /home/${VAGRANTUSER}/VMWareTools.iso
  rm -rf /tmp/vmwaretools_tmp
  ;;
parallels*)
  # Not supported
  ;;
esac