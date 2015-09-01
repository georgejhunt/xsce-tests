#!/bin/bash 
# test script which runs on server and reports via http

# script layout 1.variables 2.functions 3.main

# variables ###################################################

TESTRESULTS=server-test
LOGBASE=/library/test
mkdir -p ${LOGBASE}
LOGFILE=${LOGBASE}/${TESTRESULTS}.ini
set -u

# functions ###################################################

function log() {
 echo  "\"$1\" : \"$2\"," >> $LOGFILE
 echo  "\"$1\" : \"$2\"," 
}

function test_openvpn() {
  if `ping -c 1 10.8.0.1 | grep unknown`
    then
        log openvpn FAILED
    else
        log openvpn OK
  fi
}	

function test_teamviewer() {
  systemctl status teamviewerd | grep running > /dev/null
  if [ $? ]; then
    log teamviewer OK
  else 
    log teamviewer FAILED
  fi
} 

function test_vnstat() {
  LAN=`cat /etc/sysconfig/xs_lan_device`
  WAN=`cat /etc/sysconfig/xs_wan_device`
  if [ ! -z "$LAN" ]; then
    vnstat | grep "$LAN" 
    if [ $? -ne 0 ]; then
      log vnstat-lan FAILED
    else
      log vnstat-lan OK
    fi
  fi
  if [ ! -z "$WAN" ]; then
    vnstat | grep "$WAN" 
    if [ $? -ne 0 ]; then
      log vnstat-wan FAILED
    else
      log vnstat-wan OK
    fi
  fi
}

function report_handle() {
  HANDLE=`cat /etc/xsce/handle`
  log handle ${HANDLE}
}
function report_uuid() {
  HANDLE=`grep xsce_uuid /etc/xsce/xsce.ini |gawk '{print $3}'`
  log xsce_uuid ${HANDLE}
}

# main ###################################################

rm -rf ${LOGFILE}
test_openvpn
test_vnstat
test_teamviewer
report_handle
report_uuid
