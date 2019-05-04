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
<<<<<<< HEAD:vbox-tester/vms/debian9/debian9-vm.sh
#scp -P 5022 ../../scripts/loca_vars.yml localhost:/root/local_vars.yml
=======
scp -P 5022 ../../scripts/local_vars.yml localhost:/root/local_vars.yml
>>>>>>> 613919db6a431b84b5ac84d5ade1559182b8f819:vbox-tester/vms/debian9/debian9-vm.sh
# execute the following remotely on the VM
time ssh -p 5022 localhost '/root/iiab.sh > /root/output.log'
scp -P 5022 localhost:/root/output.log ./debian9-$YMD.log
