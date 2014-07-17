# run this using python -i
# then type 'data' to display values

import logging
from gettext import gettext as _
from xmlrpclib import ServerProxy, Error
import socket
import os
import sys
import gconf
import dbus

from sugar.profile import get_profile

REGISTER_URL = 'http://schoolserver:8080/'

sn = 'SHF00000000'
uuid = '00000000-0000-0000-0000-000000000000'

profile = get_profile()

nick = 'testxo'

server = ServerProxy('http://schoolserver:8080/')

data = server.register(sn, nick, uuid, profile.pubkey)

print data["success"]
