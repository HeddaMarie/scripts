apt-get update
wget http://apt.puppetlabs.com/puppet6-release-focal.deb 
dpkg -i puppet6-release-focal.deb 
apt update
sleep 20
wget https://raw.githubusercontent.com/HeddaMarie/scripts/main/agent.pp
apt -y install puppet-agent
#echo "10.0.65.250 puppet.local" >> /etc/hosts
/opt/puppetlabs/puppet/bin/puppet apply agent.pp
