#!/bin/bash -x
# test script copied to vm and run by ssh

export DEBIAN_FRONTEND=noninteractive
apt-get -y update
apt-get -y dist-upgrade
apt-get -y clean
OS=`grep ^ID= /etc/*elease|cut -d= -f2`
OS=${OS//\"/}
VERSION_ID=`grep VERSION_ID /etc/*elease | cut -d= -f2`
VERSION_ID=${VERSION_ID//\"/}
VERSION_ID=${VERSION_ID%%.*}
OS_VER=$OS-$VERSION_ID

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

# put the local_vars.ymll in place
cp /root/local_vars.yml /opt/iiab/iiab/vars/

#apt-get -y install ansible
/opt/iiab/iiab/scripts/ansible

cd /opt/iiab/iiab/
./iiab-install

if [ $? -ne 0 ]; then
   echo "$OS_VER runansible FAILURE" >> /root/output.log
   exit 1
fi
cd /opt/iiab/iiab-admin-console/
./install

if [ $? -ne 0 ]; then
   echo "$OS_VER iiab-admin-console FAILURE" >> /root/output.log
   exit 1
fi

cd /opt/iiab/iiab-menu/
./cp-menus
   echo "$OS_VER SUCCESS" >> /root/output.log
