#!/bin/sh

DEVKITPPC=$INSTALLDIR

#---------------------------------------------------------------------------------
# Install and build the gamecube crt and libogc
#---------------------------------------------------------------------------------

echo "installing specs ..."
cp `pwd`/dkp-crtls/gcn* $DEVKITPPC/$target/lib/
cp `pwd`/dkp-crtls/ogc.ld $DEVKITPPC/$target/lib/
cp `pwd`/dkp-crtls/specs $DEVKITPPC/lib/gcc/$target/$GCC_VER/specs

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


