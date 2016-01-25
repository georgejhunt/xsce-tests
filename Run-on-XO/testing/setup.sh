#!/bin/bash -x
# copy files to be run by olpc

mkdir /home/olpc/testing
cp olpc/* /home/olpc/testing
chmod -R 755 /home/olpc/testing
chown -R olpc:olpc /home/olpc/testing
