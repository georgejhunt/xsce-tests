#!/bin/bash -x
# test script copied to vm and run by ssh

yum -y update

mkdir -p /opt/iiab
cd /opt/iiab/
git clone https://github.com/iiab/iiab 
git clone https://github.com/iiab/iiab-admin-console 
git clone https://github.com/iiab/iiab-menu 
git clone https://github.com/iiab/iiab-factory 

cd /opt/iiab/iiab/
which ansible
if [ $? -ne 0 ];then
  ./scripts/ansible
fi
./runansible

if [ $? -ne 0 ]; then
   exit 1
fi
cd /opt/iiab/iiab-admin-console/
./install

if [ $? -ne 0 ]; then
   exit 1
fi

cd /opt/iiab/iiab-menu/
./cp-menus
