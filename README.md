xsce-tests
==========

Scripts to test basic xsce functionality.  Scripts are planned for both client and server side testing.

Run on XO
---------

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

Tests Performed:

* dhcpd - done by connect script
* dns: ping schoolserver, ping translate.google.com
* httpd: access portal page
* idmgr: register SHF00000000 id ('killed' message is expected)
         get result from ajenti (schoolserver.lan:5000) to see if SHF00000000 id is registered
* squid: retrieve a jpg twice and see if there is a cache hit the second time
* dansguardian: see if http://en.wikipedia.org/wiki/Pornography blocked
* moodle: see if schoolserver.lan/moodle redirects to moodle/login
* ajenti: retrieve schoolserver.lan:5000 to see if exists

A list of tests and results should scroll down the screen.


Credits
-------

Based on the work of Miguel Gonzalez and others.
