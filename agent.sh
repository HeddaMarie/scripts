apt-get update
wget http://apt.puppetlabs.com/puppet6-release-focal.deb 
dpkg -i puppet6-release-focal.deb 
apt-get update
apt-get -y install puppet-agent
echo "10.0.0.111 tf-puppet.sparkles.gg tf-puppet" >> /etc/hosts
wget http://www.cs.hioa.no/~haugerud/agent.pp	 
/opt/puppetlabs/puppet/bin/puppet apply agent.pp
