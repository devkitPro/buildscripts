#!/bin/sh

prefix=$INSTALLDIR

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

g++ tools/general/bmp2bin.cpp -o $prefix/bin/bmp2bin$exeext -static -O2 -s -D__LITTLE_ENDIAN__
gcc tools/gba/gbafix.c -o $prefix/bin/gbafix$exeext -static -O2 -s
g++ tools/nds/ndstool.cpp -o $prefix/bin/ndstool$exeext -static -O2 -s
cp tools/general/alignbin $prefix/bin/alignbin

# Awaiting Mr_Spiv's permission to add to project
#$MAKE -C tools/gp32/b2fxec
#cp tools/gp32/b2fxec/b2fxec$exeext $prefix/bin/b2fxec$exeext
#$MAKE -C tools/gp32/b2fxec clean
