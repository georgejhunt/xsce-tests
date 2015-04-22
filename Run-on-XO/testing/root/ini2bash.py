#!/usr/bin/env python

"""
Read STDIN parsing it as an INI file configuration and emit the same
as a BASH 4 map. Usage in BASH 4 scripts:
    declare -A config=`cat cfg.ini | ./ini2bash.py database`
    echo ${config["dbname"]}
"""

import sys
import ConfigParser
ipaddr="192.168.123.11"
docuuid=""

def parse_ini():
    config = ConfigParser.RawConfigParser()
    config.readfp(sys.stdin)
    return config


def emit_bashmap(config):
    print "{"
    for sec in config.sections():
        for pair in config.items(sec):
            k, v = pair
            print "%s_%s : %s," % (sec, k, v)


def main():
    config = parse_ini()
    emit_bashmap(config)

if __name__ == "__main__":
    main()
