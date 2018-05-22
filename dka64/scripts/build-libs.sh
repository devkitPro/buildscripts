#!/bin/sh

export DEVKITPRO=$TOOLPATH

cd $BUILDDIR/libnx-$LIBNX_VER
$MAKE || { echo "error building libnx"; exit 1; }
$MAKE install || { echo "error installing libnx"; exit 1; }
