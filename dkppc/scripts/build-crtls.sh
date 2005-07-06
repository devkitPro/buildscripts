#!/bin/sh

DEVKITPPC=$INSTALLDIR/devkitPPC

#---------------------------------------------------------------------------------
# Install and build the gamecube crt and libogc
#---------------------------------------------------------------------------------

echo "installing specs ..."
cp `pwd`/dkppc/crtls/gcn* $DEVKITPPC/$target/lib/
cp `pwd`/dkpppc/crtls/ogc.ld $DEVKITPPC/$target/lib/
cp `pwd`/dkppc/crtls/specs $DEVKITPPC/lib/gcc/$target/$GCC_VER/specs

echo "building libogc ..."
cd $LIBOGC_SRCDIR
$MAKE
echo "installing libogc ..."
$MAKE install

#---------------------------------------------------------------------------------
# copy base rulesets
#---------------------------------------------------------------------------------
cd $BUILDSCRIPTDIR
cp dkp-rules/* $DEVKITPPC


