#!/bin/bash -x
# script to run a script on a cloned vi

# first remove any lingering set vm
vboxmanage controlvm debian9-test poweroff
vboxmanage unregistervm debian9-test --delete
vboxmanage clonevm debian9-starter --register --name debian9-test
vboxmanage  modifyvm debian9-test --natpf1 "ssh,tcp,,5022,,22"
vboxmanage startvm debian9-test --type headless

YMD=`date +"%y%m%d-%H:%M"`
scp -P 5022 ./iiab-debian.sh localhost:/root/iiab-debian.sh
# execute the following remotely on the VM
ssh -p 5022 localhost '/root/iiab-debian.sh|tee -a /root/output.log'
scp -P 5022 localhost:/root/output.log ./$YMD-debian.log
