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

g++ tools/bmp2bin.cpp -o $prefix/bin/bmp2bin$exeext -static -O2 -s -D__LITTLE_ENDIAN__
gcc tools/gbafix.c -o $prefix/bin/gbafix$exeext -static -O2 -s

cd tools/b2fxec
$MAKE -C tools/gp32/b2fxec
cp b2fxec$exeext $prefix/bin/b2fxec$exeext
$MAKE -C tools/gp32/b2fxec clean
