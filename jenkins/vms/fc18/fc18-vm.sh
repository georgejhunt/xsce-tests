#!/bin/bash -x
# script to run a script on a cloned vi

# first remove any lingering set vm
vboxmanage controlvm f18-test poweroff
vboxmanage unregistervm f18-test --delete
vboxmanage clonevm f18-clone-this --register --name f18-test
vboxmanage  modifyvm f18-test --natpf1 "ssh,tcp,,6022,,22"
vboxmanage startvm centos-test --type headless

# give enough time for sshd to be running
YMD=`date +"%y%m%d-%H:%M"`
#sleep 60
#ssh -p 6022 localhost etho hi
scp -P 6022 ../../scripts/iiab.sh localhost:/root/iiab.sh
# execute the following remotely on the VM
ssh -p 6022 localhost '/root/iiab.sh|tee -a /root/output.log'
scp -P 6022 localhost:/root/output.log ./fc18-$YMD.log
