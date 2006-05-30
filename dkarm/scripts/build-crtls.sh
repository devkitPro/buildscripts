#!/bin/sh

export DEVKITARM=$TOOLPATH/devkitARM
export DEVKITPRO=$TOOLPATH

#---------------------------------------------------------------------------------
# Install and build the gba crt
#---------------------------------------------------------------------------------

cp $(pwd)/dkarm/crtls/* $DEVKITARM/arm-elf/lib/
cd $DEVKITARM/arm-elf/lib/
$MAKE CRT=gba
$MAKE CRT=gp32
$MAKE CRT=er
$MAKE CRT=gp32_gpsdk
$MAKE CRT=ds_arm7
$MAKE CRT=ds_arm9
$MAKE CRT=ds_cart

cd $BUILDSCRIPTDIR

$MAKE -C tools/general
$MAKE -C tools/general install PREFIX=$DEVKITARM/bin

#---------------------------------------------------------------------------------
# copy base rulesets
#---------------------------------------------------------------------------------
cp dkarm/rules/* $DEVKITARM

cd $LIBNDS_SRCDIR
echo "building libnds ..."
$MAKE install INSTALLDIR=$TOOLPATH 

echo "building libgba ..."
cd $BUILDSCRIPTDIR
cd $LIBGBA_SRCDIR
$MAKE install INSTALLDIR=$TOOLPATH
cd $BUILDSCRIPTDIR

echo "building libmirko ..."
cd $LIBMIRKO_SRCDIR
$MAKE install INSTALLDIR=$TOOLPATH
cd $BUILDSCRIPTDIR
