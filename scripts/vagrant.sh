#!/bin/sh

VAGRANTUSER='vagrant'

# Dependencies
yum -y install wget

# Installing vagrant keys
mkdir -pm 700 /home/${VAGRANTUSER}/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O /home/${VAGRANTUSER}/.ssh/authorized_keys
chmod 0600 /home/${VAGRANTUSER}/.ssh/authorized_keys
chown -R ${VAGRANTUSER} /home/${VAGRANTUSER}/.ssh

# Customize the message of the day
echo 'Welcome to your Vagrant-built virtual machine.' > /etc/motd
