#! /bin/bash
# base operations
apt-get update
apt upgrade -y
# install required packages
apt install subversion -y
apt install emacs -y
apt install jed -y
apt install git -y
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
