#!/bin/bash 
# script to run a script on a cloned vi

# first remove any lingering set vm
vboxmanage controlvm debian-test poweroff
vboxmanage unregistervm debian-test --delete
vboxmanage clonevm debian-starter --register --name debian-test
vboxmanage  modifyvm debian-test --natpf1 "ssh,tcp,,2022,,22"
vboxmanage startvm debian-test --type headless

YMD=`date +"%y%m%d-%H:%M"`
scp -P 2022 ../../scripts/iiab.sh localhost:/root/iiab.sh
# copy the desired local_vars.yml
scp -P 2022 ../../scripts/loca_vars.yml localhost:/root/local_vars.yml
# execute the following remotely on the VM
time  ssh -p 2022 localhost '/root/iiab.sh > /root/output.log'
scp -P 2022 localhost:/root/output.log ./debian8-$YMD.log
