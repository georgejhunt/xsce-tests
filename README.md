xsce-tests
==========

Scripts to test basic xsce functionality.  Scripts are planned for both client and server side testing.

Run on XO
---------

This includes a tinycore bootable script to install test scripts on an xo and configure it to a minimal system
with only terminal and browser.

Copy files to a usb stick, insert in an xo, and boot (without depressing the four buttons).

Enter the console by pressing Ctrl-Alt-F2 (F2 is the Friends key) and run the following Commands:

* cd testing
* ./connect <access point ssid> (assumes no password)
* ./xo-test-xsce

If you prefer to ssh into the xo, you can run ./start-sshd

Tests Performed:

* dhcpd - done by connect script
* dns: ping schoolserver, ping translate.google.com
* httpd: access portal page
* idmgr: 
* squid
* dansguardian
* moodle

A list of tests and results should scroll down the screen.


Credits
-------

Based on the work of Miguel Gonzalez and others.
