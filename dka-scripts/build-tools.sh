#!/bin/sh

prefix=$INSTALLDIR/devkitARM

gcc -O2 tools/gba/gbafix.c

if [  -f a.out ]
	then
		exeext=
		rm a.out
else
	if [  -f a.exe ]
	then
		exeext=.exe
		rm a.exe
	else
		echo "Error: Failed to build tools"
		exit -1
	fi
fi

export DEVKITARM=$TOOLPATH/devkitARM
export DEVKITPRO=$TOOLPATH
export LIBNDS=$TOOLPATH/libnds

$MAKE -C tools/gba
$MAKE -C tools/gba install PREFIX=$DEVKITARM/bin

$MAKE -C tools/general
$MAKE -C tools/general install PREFIX=$DEVKITARM/bin

$MAKE -C tools/nds/ndstool
$MAKE -C tools/nds/ndstool install PREFIX=$DEVKITARM/bin
$MAKE -C tools/nds/dsbuild
$MAKE -C tools/nds/dsbuild install PREFIX=$DEVKITARM/bin

cp tools/general/alignbin $DEVKITARM/bin/alignbin

# Awaiting Mr_Spiv's permission to add to project
#$MAKE -C tools/gp32/b2fxec
#cp tools/gp32/b2fxec/b2fxec$exeext $prefix/bin/b2fxec$exeext
#$MAKE -C tools/gp32/b2fxec clean

$MAKE -C tools clean
