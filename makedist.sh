#!/bin/sh
DATESTRING=$(date +%Y)$(date +%m)$(date +%d)
cd .. && tar	--exclude=*CVS* --exclude=.svn --exclude=.git --exclude=*.log --exclude=*.bz2 \
				--exclude=*.gz --exclude=config.sh --exclude=.devkitARM* --exclude=.devkitPPC* \
				--exclude=.devkitA64* --exclude=.gitignore \
				-cvjf buildscripts-$DATESTRING.tar.bz2 buildscripts
