#! /bin/bash
# base operations
apt-get update
apt upgrade -y

# install required packages
apt install subversion -y
apt install emacs -y
apt install jed -y
apt install git -y

# Install glusterFS. Gathered from https://docs.gluster.org/en/latest/Install-Guide/Install/

# Add keys, optional key if 9 is not available.
wget -O - https://download.gluster.org/pub/gluster/glusterfs/7/rsa.pub | apt-key add -
wget -O - https://download.gluster.org/pub/gluster/glusterfs/9/rsa.pub | apt-key add -
# Add the source

DEBID=$(grep 'VERSION_ID=' /etc/os-release | cut -d '=' -f 2 | tr -d '"')
DEBVER=$(grep 'VERSION=' /etc/os-release | grep -Eo '[a-z]+')
DEBARCH=$(dpkg --print-architecture)
echo deb https://download.gluster.org/pub/gluster/glusterfs/LATEST/Debian/${DEBID}/${DEBARCH}/apt ${DEBVER} main > /etc/apt/sources.list.d/gluster.list

# uppdate package list
apt update
apt install glusterfs-server
# Ubuntu common files for gluster
apt install software-properties-common

# Add community GlusterFS PPA
add-apt-repository ppa:gluster/glusterfs-7
apt update
apt install glusterfs-server

# End gluster FS install steps.

# add specified users
adduser tim --disabled-password --shell /bin/bash
adduser bob --disabled-password --shell /bin/bash
adduser janet --disabled-password --shell /bin/bash
adduser alice --disabled-password --shell /bin/bash
# grant specified users root access
usermod -a -G sudo tim
usermod -a -G sudo alice
usermod -a -G sudo bob
usermod -a -G sudo janet
# create required group(s) and add users to required group(s)
groupadd developers 
usermod -a -G developers tim
usermod -a -G developers janet
