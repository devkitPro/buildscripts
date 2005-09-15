#!/bin/sh
make -C tools clean
DATESTRING=$(date +%Y)$(date +%m)$(date +%d)
chmod +x build-devkit.sh
tar --exclude=*CVS* --exclude=*.log --exclude=*.bz2 -cvjf buildscripts-$DATESTRING.tar.bz2 *
