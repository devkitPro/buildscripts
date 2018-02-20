#!/bin/bash

export DEVKITPPC=$TOOLPATH/devkitPPC
export DEVKITPRO=$TOOLPATH

cd $BUILDDIR/libogc-$LIBOGC_VER

if [ ! -f installed ]; then
	echo "Building & installing libogc"
	$MAKE install || { echo "libogc install failed"; exit 1; }
	touch installed
fi

cd $BUILDDIR/libfat-$LIBFAT_VER

if [ ! -f installed ]; then
	echo "Building & installing libfat"
	$MAKE ogc-install || { echo "libfat install failed"; exit 1; }
	touch installed
fi

