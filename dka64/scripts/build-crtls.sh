#!/bin/sh

#---------------------------------------------------------------------------------
# set env variables
#---------------------------------------------------------------------------------
export DEVKITPRO=$TOOLPATH

#---------------------------------------------------------------------------------
# Install the rules files
#---------------------------------------------------------------------------------
cd $BUILDDIR

mkdir -p rules
cd rules
tar -xvf $SRCDIR/devkita64-rules-$DKA64_RULES_VER.tar.xz
patch -p1 < $SRCDIR/dka64/patches/devkita64-rules.patch
make install
