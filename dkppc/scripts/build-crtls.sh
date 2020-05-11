#!/bin/sh

#---------------------------------------------------------------------------------
# set env variables
#---------------------------------------------------------------------------------
export DEVKITPRO=$TOOLPATH
export DEVKITARM=$DEVKITPRO/devkitARM

#---------------------------------------------------------------------------------
# Install the rules files
#---------------------------------------------------------------------------------
cd $BUILDDIR

mkdir -p rules
cd rules
tar -xvf $SRCDIR/devkitarm-rules-$DKARM_RULES_VER.tar.xz
make install
