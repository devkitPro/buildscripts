#!/bin/sh
make -C tools clean
DATESTRING=$(date +%Y)$(date +%m)$(date +%d)
chmod +x build-devkit.sh
cd .. && tar --exclude=*CVS* --exclude=.svn --exclude=*.log --exclude=*.bz2 --exclude=*.gz --exclude=config.sh -cvjf buildscripts-$DATESTRING.tar.bz2 buildscripts
