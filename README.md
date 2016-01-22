Test basic XSCE functionality
=============================

Scripts run on both client and server for testing.

Run on Server
-------------

It is probably best to run the tests on the server first. This will make the server's configuration available to the client as it is testing. It will let the client skip over tests that would fail because the services are not enabled on the server.

On the server, as root, do the following:

    1. cd /root
    2. clone the tests "git clone https://github.com/XSCE/xsce-tests --depth 1
    3. Go into run-on-server folder, install test with "./runansible" script.
    4. Do the test "xsce-cmdsrv-ctl TEST"

If you have enabled openvpn, and can see your server at http://xscenet.net, you can ask the openvpn server at xscenet.net to perform the client test, and provide you with a report. (this feature is not currently available)

Testing on a remote server will never be quite as complete a test as running the client tests locally on an XO, because the wifi connection will not be tested, and the paths through the server's software are not identical.

Run on XO1
----------

This includes a tinycore linux bootable USB image to install test scripts on an xo.

  Copy files in the "Run-on-XO" directory to a usb stick, insert in an xo, and boot (without depressing the four buttons).
  Enter the console by pressing Ctrl-Alt-F2 (F2 is the Friends key)
  or start a terminal session
  and run the following Commands:

      * cd testing
      * ./connect <access point ssid> (assumes no password) or use the network neighborhood to connect to schoolserver Access Point.
      * ./xo-test-xsce.sh


Install Manually
----------------

It is also possible to simply copy the test scripts into the proper directories and run them.

On the target machine:

    * cd /root
    * git clone https://github.com/XSCE/xsce-tests --depth 1
    * cd xsce-tests/Run-on-XO/testing
    * ./setup (copies scripts to /home/olpc)
    * ./connect <access point ssid> (assumes no password) if you don't already have a network connection
    * ./xo-test-xsce


Tests Performed:

( if server test data is available:)
* openvpn: Can the server connect to http://xscenet.net?
* vnstat: Are network statistics being collecter for Lan and WAN?
* teamviewer: Is the teamviewer running?
* handle: Has an identifying handle been assigned?
* uuid: What is the unique identifier of this server?

( regardless of whether tests have been run on server)
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
* activitiy-server: call up the page showing activities available
* ka-lite: Khan Academy with exercises
* owncloud: easy interface to shared documents stored on server
* elgg: Social networking
* rachel: Large amounts of freely available content
* pathagar: Book repository for student, teacher, generated content
* kiwix: indexed access to wikipedia in many languages
* xovis: see if http://schoolserver:5984/xovis/_design/xovis-couchapp/index.html exists
* IIAB: main page and several items of content.
*       content will fail if not present

A list of tests and results should scroll down the screen.


Credits
-------

Based on the work of Miguel Gonzalez and others.
