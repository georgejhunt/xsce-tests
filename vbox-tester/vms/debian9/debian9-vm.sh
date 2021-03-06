#!/bin/bash 
# script to run a script on a cloned vi

# first remove any lingering set vm
vboxmanage controlvm debian9-test poweroff
vboxmanage unregistervm debian9-test --delete
vboxmanage clonevm debian9-starter --register --name debian9-test
vboxmanage  modifyvm debian9-test --natpf1 "ssh,tcp,,5022,,22"
vboxmanage startvm debian9-test --type headless

YMD=`date +"%y%m%d-%H:%M"`
scp -P 5022 ../../scripts/iiab.sh localhost:/root/iiab.sh
# copy the desired local_vars.yml
if [ -f ./local_vars.yml ]; then
   scp -P 5022 ./local_vars.yml localhost:/root/local_vars.yml
else
   scp -P 5022 ../../scripts/local_vars.yml localhost:/root/local_vars.yml
fi
# execute the following remotely on the VM
time ssh -p 5022 localhost '/root/iiab.sh > /root/output.log'
scp -P 5022 localhost:/root/output.log ./logs/debian9-$YMD.log
