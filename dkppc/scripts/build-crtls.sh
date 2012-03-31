#!/bin/bash

export DEVKITPPC=$TOOLPATH/devkitPPC
export DEVKITPRO=$TOOLPATH

#---------------------------------------------------------------------------------
# Install and build the gamecube crt and libogc
#---------------------------------------------------------------------------------

echo "installing linkscripts ..."
cp $BUILDSCRIPTDIR/dkppc/crtls/*.ld $DEVKITPPC/$target/lib/
#---------------------------------------------------------------------------------
# copy base rulesets
#---------------------------------------------------------------------------------
cp $BUILDSCRIPTDIR/dkppc/rules/* $DEVKITPPC
