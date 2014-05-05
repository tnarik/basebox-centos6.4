# Don't require tty for sudo
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

# Slow DNS
if [[ "${PACKER_BUILDER_TYPE}" =~ "virtualbox" ]]; then
  ## https://access.redhat.com/site/solutions/58625 (subscription required)
  echo 'RES_OPTIONS="single-request-reopen"' >> /etc/sysconfig/network
  service network restart

  # Make ssh faster by not waiting on DNS
  echo "UseDNS no" >> /etc/ssh/sshd_config
fi