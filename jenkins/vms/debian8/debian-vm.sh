#!/bin/bash -x
# script to run a script on a cloned vi

# first remove any lingering set vm
vboxmanage controlvm debian-test poweroff
vboxmanage unregistervm debian-test --delete
vboxmanage clonevm debian-starter --register --name debian-test
vboxmanage  modifyvm debian-test --natpf1 "ssh,tcp,,2022,,22"
vboxmanage startvm debian-test --type headless

YMD=`date +"%y%m%d-%H:%M"`
scp -P 2022 ../../scripts/iiab.sh localhost:/root/iiab.sh
# execute the following remotely on the VM
ssh -p 2022 localhost '/root/iiab.sh|tee -a /root/output.log'
scp -P 2022 localhost:/root/output.log ./debian8-$YMD.log
