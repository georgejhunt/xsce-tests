#!/usr/bin/env python

"""
Read STDIN parsing it as an INI file configuration and emit the same
as a BASH 4 map. Usage in BASH 4 scripts:
    declare -A config=`cat cfg.ini | ./ini2bash.py database`
    echo ${config["dbname"]}
"""

import sys
import ConfigParser


def parse_ini():
    config = ConfigParser.RawConfigParser()
    config.readfp(sys.stdin)
    return config


def emit_bashmap(config):
    print '(',
    for sec in config.sections():
        for pair in config.items(sec):
            k, v = pair
            if v[0] == '"':
                if v[1] == '"':
                    print '["%s_%s"]=%s' % (sec, k, v[1:-1]),
                else:
                    print '["%s_%s"]=%s' % (sec, k, v),
            else:
                print '["%s_%s"]="%s"' % (sec, k, v),
    print ')'


def main():
    config = parse_ini()
    emit_bashmap(config)

if __name__ == "__main__":
    main()
