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

mkdir -p rules
cd rules
tar -xvf $SRCDIR/devkitppc-rules-$DKPPC_RULES_VER.tar.xz
make install
