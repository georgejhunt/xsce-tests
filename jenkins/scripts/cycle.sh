#!/bin/bash -x
# cycle.sh through all the VM's

SCRIPTDIR=$(dirname $0)
YMD=`date +"%y%m%d"`
pushd $SCRIIPTDIR
for VM in centos debian8 debian9 ubuntu fc18; do
   DONE=
   # check to see if we have a successful run on this date
   if [ -d ../../output/$YMD/ ]; then
      pushd ../../output/$YMD
      for fn in $VM*; do
        if [ -f $fn ]; then
		tail $fn |grep SUCCESS
		if [ $? -eq 0 ]; then 
		   echo $VM "SUCCESS -- skipping"
                   DONE=True
		   continue 
		fi
        fi
      done
      popd 
   fi
   if [ "$DONE" == "TRUE" ]; then continue; fi
   # move the the directory context
   pushd ../vms/$VM
   rm -f *.log
   echo processing $VM
   time ./$VM-vm.sh
   mkdir -p ../../output/$YMD
   cp *.log ../../output/$YMD/
   popd
done
popd
