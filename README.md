xsce-tests
==========

Scripts to test basic xsce functionality.  Scripts are planned for both client and server side testing.

Run on XO1
----------

This includes a tinycore bootable script to install test scripts on an xo and configure it to a minimal system
with only terminal and browser.

Copy files to a usb stick, insert in an xo, and boot (without depressing the four buttons).

Enter the console by pressing Ctrl-Alt-F2 (F2 is the Friends key)

or start a terminal session

and run the following Commands:

* cd testing
* ./connect <access point ssid> (assumes no password)
* ./xo-test-xsce

If you prefer to ssh into the xo, you can run ./start-sshd

Install Manually
----------------

It is also possible to simply copy the test scripts into the proper directories and run them.

On the target machine git clone https://github.com/XSCE/xsce-tests --depth 1

mkdir /root/testing
cp xsce-tests/Run-on-XO/testing/root/* /root/testing
chmod 755 /root/testing/*

To run the XO-specific tests, which will be marked as FAIL otherwise:

mkdir /home/olpc/testing
cp xsce-tests/Run-on-XO/testing/olpc/* /home/olpc/testing
chmod 755 /home/olpc/testing/*
chown -R olpc:olpc /home/olpc/testing

If you want to remove the XO tests edit /root/testing/xo-test-xsce and comment out things that fail.

Now you can:

* cd /root/testing
* ./connect <access point ssid> (assumes no password) if you don't already have a network connection
* ./xo-test-xsce

Tests Performed:

* dhcpd - done by connect script
* dns: ping schoolserver, ping translate.google.com
* httpd: access portal page
* idmgr: register SHF00000000 id ('killed' message is expected)
* Authserver: get result from Authserver (schoolserver.lan:5000) to see if SHF00000000 id is registered
* squid: retrieve a jpg twice and see if there is a cache hit the second time
* dansguardian: see if http://en.wikipedia.org/wiki/Pornography blocked
* moodle: see if schoolserver/moodle redirects to moodle/login
* munin: see if schoolserver/munin redirects to munin/login
* ajenti: see if  schoolserver:9990 exists
* backup: perform a backup for user SHF00000000
* ejabberd: see if  schoolserver:5280/admin redirects to login
* xovis: see if http://schoolserver:5984/xovis/_design/xovis-couchapp/index.html exists
* IIAB: main page and several items of content.
*       content will fail if not present

A list of tests and results should scroll down the screen.


Credits
-------

Based on the work of Miguel Gonzalez and others.
