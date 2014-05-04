#rpm -Uhv http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

yum -y install gcc make kernel-devel-`uname -r` perl #dkms

# Installing the virtualbox guest additions
cd /tmp
mount -o loop /home/vagrant/VBoxGuestAdditions.iso /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt
#rm -rf /home/vagrant/VBoxGuestAdditions.iso
