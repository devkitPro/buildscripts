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

tar -xvf $SRCDIR/devkitarm-rules-$DKARM_RULES_VER.tar.gz
cd devkitarm-rules-$DKARM_RULES_VER
$MAKE install

#---------------------------------------------------------------------------------
# Install and build the crt0 files
#---------------------------------------------------------------------------------
cd $BUILDDIR

tar -xvf $SRCDIR/devkitarm-crtls-$DKARM_CRTLS_VER.tar.gz
cd devkitarm-crtls-$DKARM_CRTLS_VER
$MAKE install

