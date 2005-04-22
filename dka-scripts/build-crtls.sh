#!/bin/sh

DEVKITARM=$INSTALLDIR

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
