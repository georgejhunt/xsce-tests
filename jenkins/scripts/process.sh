#!/bin/bash -x
# script to run run cycle, and save the results

YMD=`date +"%y%m%d"`
mkdir -p output/$YMD
./cycle.sh | tee -a output/$YMD/script.log
