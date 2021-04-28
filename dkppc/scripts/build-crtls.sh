#!/bin/sh

#---------------------------------------------------------------------------------
# set env variables
#---------------------------------------------------------------------------------
export DEVKITPRO=$TOOLPATH
export DEVKITPPC=$DEVKITPRO/devkitPPC

#---------------------------------------------------------------------------------
# Install the rules files
#---------------------------------------------------------------------------------
cd $BUILDDIR

tar -xvf $SRCDIR/devkitppc-rules-$DKPPC_RULES_VER.tar.gz
cd devkitppc-rules-$DKPPC_RULES_VER
make install
