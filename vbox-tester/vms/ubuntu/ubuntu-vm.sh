#!/bin/bash 
# script to run a script on a cloned vi

# first remove any lingering set vm
vboxmanage controlvm ubuntu18-test poweroff
vboxmanage unregistervm ubuntu18-test --delete
vboxmanage clonevm ubuntu18-starter --register --name ubuntu18-test
vboxmanage  modifyvm ubuntu18-test --natpf1 "ssh,tcp,,3022,,22"
vboxmanage startvm ubuntu18-test --type headless

YMD=`date +"%y%m%d-%H:%M"`
scp -P 3022 ../../scripts/iiab.sh localhost:/root/iiab.sh
# copy the desired local_vars.yml
scp -P 3022 ../../scripts/loca_vars.yml localhost:/root/local_vars.yml
# execute the following remotely on the VM
time ssh -p 3022 localhost '/root/iiab.sh > /root/output.log'
scp -P 3022 localhost:/root/output.log ./ubuntu18-$YMD.log
