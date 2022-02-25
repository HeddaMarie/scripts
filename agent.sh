apt-get update
wget http://apt.puppetlabs.com/puppet6-release-focal.deb 
dpkg -i puppet6-release-focal.deb 
apt update
sleep 10
apt -y install puppet-agent
echo "10.0.0.111 tf-puppet.sparkles.gg tf-puppet" >> /etc/hosts
/opt/puppetlabs/puppet/bin/puppet apply agent.pp
