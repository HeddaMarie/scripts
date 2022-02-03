#! /bin/bash

#wget http://apt.puppetlabs.com/puppet6-release-focal.deb
#dpkg -i puppet6-release-focal.deb
apt update
echo "deb http://deb.theforeman.org/ focal 3.0" >> /etc/apt/sources.list.d/foreman.list
echo "deb http://deb.theforeman.org/ plugins 3.0" >> /etc/apt/sources.list.d/foreman.list
apt-get install ca-certificates -y
wget -q https://deb.theforeman.org/pubkey.gpg -O- | apt-key add -
apt-get update && apt-get install foreman-installer
