#!/bin/bash -x
# script to run a script on a cloned vi

# first remove any lingering set vm
vboxmanage controlvm centos-test poweroff
vboxmanage unregistervm centos-test --delete
vboxmanage clonevm centos-starter --register --name centos-test
vboxmanage  modifyvm centos-test --natpf1 "ssh,tcp,,4022,,22"
vboxmanage startvm centos-test --type headless

# give enough time for sshd to be running
sleep 60
ssh -p 4022 localhost etho hi
scp -P 4022 ./iiab-centos.sh localhost:/root/iiab-centos.sh
# execute the following remotely on the VM
ssh -p 4022 localhost '/root/iiab-centos.sh|tee -a /root/output.log'
scp -P 4022 localhost:/root/output.log ./centos-output.log
