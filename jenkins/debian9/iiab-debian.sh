#!/bin/bash -x
# test script copied to vm and run by ssh

export DEBIAN_FRONTEND=noninteractive
apt-get -y update
apt-get -y dist-upgrade
apt-get -y clean

mkdir -p /opt/iiab
cd /opt/iiab/
git clone https://github.com/iiab/iiab 
pushd iiab
git remote add ghunt https://github.com/georgejhunt/iiab
git fetch --all
git checkout -b test ghunt/test
popd
git clone https://github.com/iiab/iiab-admin-console 
pushd iiab-admin-console
git remote add ghunt https://github.com/georgejhunt/iiab-admin
git fetch --all
git checkout -b test ghunt/test
popd
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
