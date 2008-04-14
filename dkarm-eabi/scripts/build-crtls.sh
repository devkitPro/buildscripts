#!/bin/sh

export DEVKITARM=$TOOLPATH/devkitARM
export DEVKITPRO=$TOOLPATH

#---------------------------------------------------------------------------------
# copy base rulesets
#---------------------------------------------------------------------------------
cp -v dkarm-eabi/rules/* $DEVKITARM

#---------------------------------------------------------------------------------
# Install and build the gba crt
#---------------------------------------------------------------------------------

cp -v $(pwd)/dkarm-eabi/crtls/* $DEVKITARM/arm-eabi/lib/
cd $DEVKITARM/arm-eabi/lib/
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


echo "building libnds ..."
cd $LIBNDS_SRCDIR
$MAKE install INSTALLDIR=$TOOLPATH 
cd $BUILDSCRIPTDIR

echo "building libgba ..."
cd $LIBGBA_SRCDIR
$MAKE install INSTALLDIR=$TOOLPATH
cd $BUILDSCRIPTDIR

echo "building libfat ..."
cd $LIBFAT_SRCDIR
$MAKE install INSTALLDIR=$TOOLPATH 
cd $BUILDSCRIPTDIR

echo "building dswifi ..."
cd $DSWIFI_SRCDIR
$MAKE install INSTALLDIR=$TOOLPATH 
cd $BUILDSCRIPTDIR

echo "building default arm7 ..."
cd $DEFAULT_ARM7_SRCDIR
$MAKE install INSTALLDIR=$TOOLPATH 
cd $BUILDSCRIPTDIR

echo "building libmirko ..."
cd $LIBMIRKO_SRCDIR
$MAKE install INSTALLDIR=$TOOLPATH
cd $BUILDSCRIPTDIR
