#!/bin/bash 
# cycle.sh through all the VM's

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
YMD=`date +"%y%m%d"`
pushd $SCRIIPTDIR > /dev/null
for VM in centos debian8 debian9 ubuntu fc18; do
   DONE=
   # check to see if we have a successful run on this date
   if [ -d $SCRIPTDIR/../output/$YMD/ ]; then
      pushd $SCRIPTDIR/../output/$YMD > /dev/null
      LIST=$(ls $VM*) 2> /dev/null
      LINES=$(echo $LIST | wc | cut -d" " -f1)
      if [ "$LINES" != "0" ];then
	 for fn in $LIST; do
	   if [ -f $fn ]; then
		   tail $fn |grep SUCCESS > /dev/null
		   if [ $? -eq 0 ]; then 
		      echo "$fn SUCCESS -- skipping"
		      DONE=TRUE
		      break 
		   fi
	   fi
	 done
      fi
      popd > /dev/null
   fi
   if [ "$DONE" != "TRUE" ];then
      # move the the directory context
      pushd $SCRIPTDIR/../vms/$VM 2>&1 > /dev/null
      ls *.log 2> /dev/null
      if [ $? -eq 0 ]; then
	 rm -f *.log
      fi
      echo processing $VM
      time ./$VM-vm.sh
      mkdir -p ../../output/$YMD
      ls *.log  2> /dev/null
      if [ $? -eq 0 ]; then
	 cp *.log ../../output/$YMD/
      fi
      popd > /dev/null
   fi
done
popd 2> /dev/null

