#!/bin/sh

DEVKITARM=$TOOLPATH/devkitARM

#---------------------------------------------------------------------------------
# Install and build the gba crt
#---------------------------------------------------------------------------------

cp $(pwd)/dka-crtls/* $DEVKITARM/arm-elf/lib/
cd $DEVKITARM/arm-elf/lib/
$MAKE CRT=gba
$MAKE CRT=gp32
$MAKE CRT=er
$MAKE CRT=gp32_gpsdk
$MAKE CRT=ds_arm7
$MAKE CRT=ds_arm9
$MAKE CRT=ds_cart


#---------------------------------------------------------------------------------
# copy base rulesets
#---------------------------------------------------------------------------------
cd $BUILDSCRIPTDIR
cp dka-rules/* $DEVKITARM

cd $LIBNDS_SRCDIR
echo "building libnds ..."
$MAKE install INSTALLDIR=$TOOLPATH 

echo "building libgba ..."
cd $BUILDSCRIPTDIR
cd $LIBGBA_SRCDIR
$MAKE install INSTALLDIR=$TOOLPATH
