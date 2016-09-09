#!/bin/bash
#
# conceptually removed from XSCE, this script can function in many contexts
#   -- even when it is not removed, but rather, talks to the server as localhost

# Perform the following tests:
# - dhcpd - done by connect script
# - httpd
# - moodle: access to login
# - munin: access to login
# - ajenti: access
# - ejabberd: access to login
# - xovis: access
# - activity-server
# - Kalite
# - kiwix
# - owncloud
# - elgg
# - pathagar
# - dns: ping schoolserver, ping
# - idmgr
# - Authserver shows registration
# - squid: caching (filtering is off by default)
# - dansguardian: filtering
# - backup: does a backup
# - samba
# - awstats
# - wordpress
# - dokuwiki
# - phpmyadmin
# - cups
# - calibre
# - schooltool
# - sugarizer
# - IIAB: main page and several items of content.
#   content will fail if not present

# done on the server

# - monit
# - openvpn
# - vnstat
# - teamviewer

##################  Define variables, determine context ##############
TRUE=0
FALSE=-1

# Hard code the default admin password
AdminPW=g0adm1n

# if no parameter, assume target is schoolserver across LAN
if [ $# == 0 ]; then
  ping -c 2 172.18.96.1 > /dev/null
  if [ $? -eq 0 ]; then
    SCHOOLSERVER=172.18.96.1
  else
    SCHOOLSERVER=localhost
  fi
else
  SCHOOLSERVER=$1
fi

# complain and abort if SCHOOLERVER is not reachable
ping -c 1 $SCHOOLSERVER > /dev/null
if [ $? -ne 0 ]; then
  echo "Cannot communicate with SCHOOLSERVER at $SCHOOLSERVER . . .quitting"
  exit 1
fi

# where is this script located?`
scriptdir=$(cd `dirname ${0}`; pwd)

# create an intermediates file for this server device
intermediatedir=$scriptdir/$SCHOOLSERVER
LOGFILE=$intermediatedir/testresults
rm -rf $intermediatedir
mkdir $intermediatedir

#determine if the ini file is available to refine the tests performed
curl -s -u xsce-admin:$AdminPW http://${SCHOOLSERVER}/test/xsce.ini > $intermediatedir/xsce.ini

lines=`cat xsce.ini | wc | gawk '{print $1}'`
if [ $lines -lt 10 ];then
  haveini=FALSE
else
  haveni=TRUE
  cat $intermediatedir/xsce.ini | $scriptdir/ini2bash.py > $LOGFILE
  cat $intermediatedir/xsce.ini | $scriptdir/ini2map.py > $intermediatedir/xsce.ini.map

# now create a bash array with this information
  declare -A settings=`cat $intermediatedir/xsce.ini.map`

# get the results of the tests that are done on the server.
  curl -s http://${SCHOOLSERVER}/test/server-test.ini > $intermediatedir/server-test.ini
fi

# Define colors for results
NORMAL=$(tput sgr0)
GREEN=$(tput setaf 2; tput bold)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)

###############################  Functions  ###############################

function red() {
    echo -e "$RED$*$NORMAL"
}

function green() {
    echo -e "$GREEN$*$NORMAL"
}

function yellow() {
    echo -e "$YELLOW$*$NORMAL"
}

function log() {
 echo  "\"$1\" : \"$2\"," >> $LOGFILE
}

# dhcpd - verify
function ip_range() {
echo -n "[XSCE] Test got address from server ..."
if `ifconfig | grep -q 172.18`
  then
      log dhcpd OK
      green OK
  else
      log dhcpd FAILED
      red FAILED!
fi
}

# - dns: ping schoolserver, translate.google.com
function test_dns() {
echo -n "[XSCE] Test resolve schoolserver ..."
if `ping -c 1 ${SCHOOLSERVER} | grep unknown &> /dev/null`
  then
      log ping_schoolserver FAILED
      red FAILED!
  else
      log ping_schoolserver OK
      green OK
fi
}
function test_external_dns() {
echo -n "[XSCE] Test resolve translate.google.com ..."
if `ping -c 1 translate.google.com | grep unknown`
  then
      log dns_external FAILED
      red FAILED!
  else
      log dns_external OK
      green OK
fi
}

# - httpd: access home page
function test_httpd() {
echo -n "[XSCE] Test schoolserver http access..."
if `curl -s -I http://${SCHOOLSERVER} | grep -is "Location: http://${SCHOOLSERVER}/xs-portal" > /dev/null`
then
      log httpd OK
    green OK
    else
      log httpd FAILED
    red FAILED!
fi
}


# - idmgr

function test_idmgr() {
echo -n "[XSCE] Test idmgr registration..."
su - olpc -c "python /home/olpc/testing/idmgr-test.py >/home/olpc/testing/idmgr-test.result"
rc=`cat /home/olpc/testing/idmgr-test.result`

if [ "$rc" == "OK" ]
then
      log idmgr_registration OK
    green OK
    else
      log idmgr_registration FAILED
    red FAILED!
fi
}

function test_registration() {
echo -n "[XSCE] Test if xo is registered via Authserver..."
if `wget -qO - http://${SCHOOLSERVER}:5000/  | grep -is "SHF00000000" > /dev/null`
then
      log authserver OK
    green OK
    else
      log authserver FAILED
    red FAILED!
fi

}

# squid
function test_squid_cache() {
if [ ! $haveini == TRUE ] || [ ${settings[squid_squid_enabled]} == "True" ]; then
  echo -n "[XSCE] Test squid proxy settings..."
  if `curl -Is http://one.laptop.org//sites/default/files/charlotte2.jpg | grep X-Cache | grep -q schoolserver`
  then
      log squid OK
      green OK
  else
      log squid FAILED
      red FAILED!
  fi

  echo -n "[XSCE] Test squid proxy caching settings..."
  if `curl -Is http://one.laptop.org//sites/default/files/charlotte2.jpg | grep X-Cache | grep schoolserver | grep -q HIT`
  then
      log squid_cache OK
      green OK
  else
      log squid_cache FAILED
      red FAILED!
  fi
fi
}

# - dansguardian
function test_dansguardian() {
if [ ! $haveini == TRUE ] || [ ${settings[dansguardian_dansguardian_enabled]} == "True" ]; then
  echo -n "[XSCE] Test dansguardian settings..."
  if `wget -qO - http://www.pornhub.com | grep -is dansguardian > /dev/null`
  then
        log dansguardian OK
      green OK
      else
        log dansguardian FAILED
      red FAILED!
  fi
fi
}

# - moodle
function test_moodle() {
if [ ! $haveini == TRUE ] || [ ${settings[moodle_moodle_enabled]} == "True" ]; then
  echo -n "[XSCE] Test schoolserver moodle access..."
  if `curl -Is http://${SCHOOLSERVER}/moodle/ | grep -is "moodle/login" > /dev/null`
  then
      log moodle OK
      green OK
  else
      log moodle FAILED
      red FAILED!
  fi
fi
}

function test_activity_server() {
  echo -n "[XSCE] Test schoolserver activity_server..."
  if `curl -Is http://${SCHOOLSERVER}/activities/ | grep -is "HTTP/1.1 200 OK" > /dev/null`
  then
    log activity_server OK
    green OK
  else
    log activity_server FAILED
    red FAILED!
  fi
}

function test_pathagar() {
if [ ! $haveini == TRUE ] || [ ${settings[pathagar_pathagar_enabled]} == "True" ]; then
  echo -n "[XSCE] Test Pathagar..."
  if `curl -Is http://${SCHOOLSERVER}/books/ | grep -is "HTTP/1.1 302 FOUND" > /dev/null`
  then
      log pathagar OK
      green OK
  else
      log pathagar FAILED
      red FAILED!
  fi
fi
}

function test_kalite() {
  if [ ! $haveini == TRUE ] || [ ${settings[kalite_kalite_enabled]} == "True" ]; then
    echo -n "[XSCE] Test Kalite..."
    if `curl -Is http://${SCHOOLSERVER}:8008 | grep -is "HTTP/1.1 200 OK" > /dev/null`
    then
        log kalite OK
        green OK
    else
        log kalite FAILED
        red FAILED!
    fi
  fi
}

function test_kiwix() {
  if [ ! $haveini == TRUE ] || [ ${settings[kiwix_kiwix_enabled]} == "True" ]; then
  echo -n "[XSCE] Test Kiwix..."
# the kiwix server returns a blank header, even when serving
  lines=`curl -s http://${SCHOOLSERVER}:3000 | wc | gawk '{print $1}'`
    if [ $lines -gt 10 ]
    then
        log kiwix OK
        green OK
    else
        log kiwix FAILED
        red FAILED!
    fi
  fi
}

function test_rachel() {
  if [ ! $haveini == TRUE ] || [ ${settings[rachel_rachel_enabled]} == "True" ]; then
    echo -n "[XSCE] Test rachel..."
    if `curl -Is http://${SCHOOLSERVER}/rachel/ | grep -is "HTTP/1.1 200 OK" > /dev/null`
    then
        log rachel OK
        green OK
    else
        log rachel FAILED
        red FAILED!
    fi
  fi
}


function test_elgg() {
  if [ ! $haveini == TRUE ] || [ ${settings[elgg_elgg_enabled]} == "True" ]; then
    echo -n "[XSCE] Test elgg..."
    if `curl -Is http://${SCHOOLSERVER}/elgg/ | grep -is "HTTP/1.1 200 OK" > /dev/null`
    then
        log elgg OK
        green OK
    else
        log elgg FAILED
        red FAILED!
    fi
  fi
}

function test_owncloud() {
  if [ ! $haveini == TRUE ] || [ ${settings[owncloud_owncloud_enabled]} == "True" ]; then
    echo -n "[XSCE] Test owncloud..."
    if `curl -Is http://${SCHOOLSERVER}/owncloud/ | grep -is "HTTP/1.1 200 OK" > /dev/null`
    then
        log owncloud OK
        green OK
    else
        log owncloud FAILED
        red FAILED!
    fi
  fi
}

# - ds-backup
function test_backup() {
  echo -n "[XSCE] Test backup..."
  su - olpc -c "python /home/olpc/testing/ds-backup-test.py >/home/olpc/testing/backup-test.result"
  rc=`cat /home/olpc/testing/backup-test.result`

  if [ "$rc" == "OK" ]
  then
      log backup OK
      green OK
  else
      log backup FAILED
      red FAILED!
  fi
}

# - ejabberd
function test_ejabberd() {
  if [ ! $haveini == TRUE ] || [ ${settings[ejabberd_ejabberd_enabled]} == "True" ]; then
    echo -n "[XSCE] Test ejabberd running..."

    if `curl -Is http://${SCHOOLSERVER}:5280/admin | grep -is 'realm="ejabberd"' > /dev/null`
    then
        log ejabberd OK
        green OK
    else
        log ejabberd FAILED
        red FAILED!
    fi
  fi
}

# Samba
function test_samba(){
  if [ ! $haveini == TRUE ] || [ ${settings[samba_samba_enabled]} == "True" ]; then
    mkdir -p /tmp/smb
    if  mount -t cifs  -o username=smbuser,password=smbuser //${SCHOOLSERVER}/public /tmp/smb
       then
      echo "this is a test" > /tmp/smb/test
      stored=`cat /tmp/smb/test`
      if [ "$stored" == "this is a test" ]; then
        rm /tmp/smb/test
        umount /tmp/smb
        log samba OK
        green OK
      else
        log samba FAILED
        red FAILED!
      fi
    else
        log samba FAILED
        red FAILED!
    fi
    rmdir /tmp/smb
  fi
}



# munin

function test_munin() {
  if [ ! $haveini == TRUE ] || [ ${settings[munin_munin_enabled]} == "True" ]; then
    echo -n "[XSCE] Test munin access..."
    if `curl -Is http://${SCHOOLSERVER}/munin  | grep -is 'realm="Munin"' > /dev/null`
    then
        log munin OK
        green OK
    else
        log munin FAILED
        red FAILED!
    fi
  fi
}

# ajenti

function test_ajenti() {
  if [ ! $haveini == TRUE ] || [ ${settings[ajenti_ajenti_enabled]} == "True" ]; then
    echo -n "[XSCE] Test ajenti access..."
    if `curl -Is http://${SCHOOLSERVER}:9990 | grep -is "HTTP/1.1 200 OK" > /dev/null`
    then
        log ajenti OK
        green OK
    else
        log ajenti FAILED
        red FAILED!
    fi
  fi
}

# xovis

function test_xovis() {
  if [ ! $haveini == TRUE ] || [ ${settings[xovis_xovis_enabled]} == "True" ]; then
    echo -n "[XSCE] Test xovis access..."
    if `curl -Is http://${SCHOOLSERVER}:5984/xovis/_design/xovis-couchapp/index.html | grep -is "HTTP/1.1 200 OK" > /dev/null`
    then
        log xovis OK
        green OK
    else
        log xovis FAILED
        red FAILED!
    fi
  fi
}

function test_awstats() {
  if [ ! $haveini == TRUE ] || [ ${settings[awstats_awstats_enabled]} == "True" ]; then
    echo -n "[XSCE] Test awstats..."
    if `curl -Is http://${SCHOOLSERVER}/awstats/awstats.pl | grep -is "HTTP/1.1 200 OK" > /dev/null`
    then
        log awstats OK
        green OK
    else
        log awstats FAILED
        red FAILED!
    fi
  fi
}

function iiab_presence() {
  if [ ! $haveini == TRUE ] || [ ${settings[pathagar_pathagar_enabled]} == "True" ]; then
    echo -n "[IIAB] Test main iiab page..."
    if `curl -Is http://${SCHOOLSERVER}/iiab/ | grep -is "HTTP/1.1 200 OK" > /dev/null`
    then
        log iiab OK
        green OK
    else
        log iiab FAILED
        red FAILED!
    fi

    echo -n "[IIAB] Test wikipedia page..."
    if `curl -Is http://${SCHOOLSERVER}/iiab/zim/wikipedia_gn_all_01_2013/A/Pirane.html | grep -is "HTTP/1.1 200 OK" > /dev/null`
    then
        log iiab_wikipedia OK
        green OK
    else
        log iiab_wikipedia FAILED
        red FAILED!
    fi

    echo -n "[IIAB] Test khan akademy video..."
    if `curl -Is http://${SCHOOLSERVER}/iiab/video/khanvideo/1/1/2/3.webm | grep -is "HTTP/1.1 200 OK" > /dev/null`
    then
        log iiab_khan OK
        green OK
    else
        log iiab_khan FAILED
        red FAILED!
    fi

    echo -n "[IIAB] Test map link..."
    if `curl -Is http://${SCHOOLSERVER}/iiab/maps/tile/6/31/29.png | grep -is "HTTP/1.1 200 OK" > /dev/null`
    then
        log iiab_map OK
        green OK
    else
        log iiab_map FAILED
        red FAILED!
    fi

    echo -n "[IIAB] Test book search..."
    if `curl -Is http://${SCHOOLSERVER}/iiab/books/search?q=moby+dick | grep -is "HTTP/1.1 200 OK" > /dev/null`
    then
        log iiab_search OK
        green OK
    else
        log iiab_search FAILED
        red FAILED!
    fi

    echo -n "[IIAB] Test book download..."
    if `curl -Is http://${SCHOOLSERVER}/iiab/books/epub/2701.epub | grep -is "HTTP/1.1 200 OK" > /dev/null`
    then
        log iiab_book OK
        green OK
    else
        log iiab_book FAILED
        red FAILED!
    fi
  fi
}

################################################################################
# everythin above this is functions, and variables
# Main
testmode=${settings["xsce_network_mode_applied"]}
# default to gateway mode
if [ -z "$testmode" ]; then
  testmode="gateway"
fi

# Are we running on an XO platform
if [ -f /proc/device-tree/mfg-data/MN ]
then
  XO_VERSION=`cat /proc/device-tree/mfg-data/MN`
else
  XO_VERSION="none"
fi

echo
echo "Starting Tests in $testmode mode on XO model $XO_VERSION"

# Do the following regardless of testmode
test_httpd
test_moodle
test_munin
if [ "x$ajenti_name" != "x" ];then
  test_ajenti
fi
test_ejabberd
#test_xovis
test_activity_server
test_kalite
test_owncloud
test_elgg
test_rachel
test_pathagar
test_kiwix
#test_samba -- fc18 XO kernel does not have cifs configured

if [ "$testmode" == "LanController" -o "$testmode" == "Gateway" ]; then
  ip_range
  test_dns
fi

if [ "$testmode" == "Gateway" ]; then
  test_external_dns
  test_dansguardian
  test_squid_cache
fi

if [ "$XO_VERSION" != "none" ];then
  test_idmgr
  test_registration
  test_backup
fi

echo
echo "IIAB Tests"

iiab_presence

echo [server] >>$LOGFILE
cat server-test.ini >> $LOGFILE
cat footer >> $LOGFILE
