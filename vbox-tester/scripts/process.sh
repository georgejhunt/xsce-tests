#!/bin/bash -x
# script to run run cycle, and save the results

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
YMD=`date +"%y%m%d"`
mkdir -p $SCRIPTDIR/../output/$YMD
./cycle.sh | tee -a $SCRIPTDIR/../output/$YMD/script.log
