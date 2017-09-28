#!/bin/bash 
# script to run a script on a cloned vi

# first remove any lingering set vm
vboxmanage controlvm centos-test poweroff
vboxmanage unregistervm centos-test --delete
vboxmanage clonevm centos-starter --register --name centos-test
vboxmanage  modifyvm centos-test --natpf1 "ssh,tcp,,4022,,22"
vboxmanage startvm centos-test --type headless

# give enough time for sshd to be running
YMD=`date +"%y%m%d-%H:%M"`
sleep 60
ssh -p 4022 localhost eth0 hi
scp -P 4022 ../../scripts/iiab.sh localhost:/root/iiab.sh
# copy the desired local_vars.yml
scp -P 4022 ../../scripts/local_vars.yml localhost:/root/local_vars.yml
# execute the following remotely on the VM
time ssh -p 4022 localhost '/root/iiab.sh > /root/output.log'
scp -P 4022 localhost:/root/output.log ./centos-$YMD.log
