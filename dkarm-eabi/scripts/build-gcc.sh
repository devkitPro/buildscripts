#!/bin/sh
#---------------------------------------------------------------------------------

numcores=`getconf _NPROCESSORS_ONLN`

numjobs=$(($numcores * 2 + 1))

#---------------------------------------------------------------------------------
# build and install binutils
#---------------------------------------------------------------------------------

mkdir -p $target/binutils
cd $target/binutils

if [ ! -f configured-binutils ]
then
	CFLAGS=$cflags LDFLAGS=$ldflags ../../binutils-$BINUTILS_VER/configure \
        --prefix=$prefix --target=$target --disable-nls --disable-werror \
	--enable-lto --enable-plugins --enable-poison-system-directories \
	$CROSS_PARAMS \
        || { echo "Error configuring binutils"; exit 1; }
	touch configured-binutils
fi

if [ ! -f built-binutils ]
then
  $MAKE -j$numjobs || { echo "Error building binutils"; exit 1; }
  touch built-binutils
fi

if [ ! -f installed-binutils ]
then
  $MAKE install || { echo "Error installing binutils"; exit 1; }
  touch installed-binutils
fi
cd $BUILDDIR

#---------------------------------------------------------------------------------
# build and install just the c compiler
#---------------------------------------------------------------------------------
mkdir -p $target/gcc
cd $target/gcc

if [ ! -f configured-gcc ]
then
	CFLAGS="$cflags" \
	CXXFLAGS="$cflags" \
	LDFLAGS="$ldflags" \
	CFLAGS_FOR_TARGET="-O2 -ffunction-sections -fdata-sections" \
	CXXFLAGS_FOR_TARGET="-O2 -ffunction-sections -fdata-sections" \
	LDFLAGS_FOR_TARGET="" \
	../../gcc-$GCC_VER/configure \
		--enable-languages=c,c++,objc,obj-c++ \
		--with-gnu-as --with-gnu-ld --with-gcc \
		--with-march=armv4t\
		--enable-cxx-flags='-ffunction-sections' \
		--disable-libstdcxx-verbose \
		--enable-poison-system-directories \
		--enable-interwork --enable-multilib \
		--enable-threads --disable-win32-registry --disable-nls --disable-debug\
		--disable-libmudflap --disable-libssp --disable-libgomp \
		--disable-libstdcxx-pch \
		--target=$target \
		--with-newlib \
		--with-headers=../../newlib-$NEWLIB_VER/newlib/libc/include \
		--prefix=$prefix \
		--enable-lto $plugin_ld\
		--with-system-zlib \
		--with-bugurl="http://wiki.devkitpro.org/index.php/Bug_Reports" --with-pkgversion="devkitARM release 46" \
		$CROSS_PARAMS \
		|| { echo "Error configuring gcc"; exit 1; }
	touch configured-gcc
fi

if [ ! -f built-gcc ]
then
	$MAKE all-gcc -j$numjobs || { echo "Error building gcc stage1"; exit 1; }
	touch built-gcc
fi

if [ ! -f installed-gcc ]
then
	$MAKE install-gcc || { echo "Error installing gcc"; exit 1; }
	touch installed-gcc
fi


unset CFLAGS
cd $BUILDDIR

#---------------------------------------------------------------------------------
# build and install newlib
#---------------------------------------------------------------------------------
mkdir -p $target/newlib
cd $target/newlib

if [ ! -f configured-newlib ]
then
	CFLAGS_FOR_TARGET="-O2 -ffunction-sections -fdata-sections" \
	../../newlib-$NEWLIB_VER/configure \
	--disable-newlib-supplied-syscalls \
	--enable-newlib-mb \
	--disable-newlib-wide-orient \
	--target=$target \
	--prefix=$prefix \
	|| { echo "Error configuring newlib"; exit 1; }
	touch configured-newlib
fi

if [ ! -f built-newlib ]
then
	$MAKE -j$numjobs || { echo "Error building newlib"; exit 1; }
	touch built-newlib
fi


if [ ! -f installed-newlib ]
then
	$MAKE install || { echo "Error installing newlib"; exit 1; }
	touch installed-newlib
fi

#---------------------------------------------------------------------------------
# build and install the final compiler
#---------------------------------------------------------------------------------

cd $BUILDDIR

cd $target/gcc

if [ ! -f built-stage2 ]
then
	$MAKE all -j$numjobs || { echo "Error building gcc stage2"; exit 1; }
	touch built-stage2
fi

if [ ! -f installed-stage2 ]
then
	$MAKE install || { echo "Error installing gcc stage2"; exit 1; }
	touch installed-stage2
fi

rm -fr $prefix/$target/sys-include

cd $BUILDDIR

#---------------------------------------------------------------------------------
# build and install the debugger
#---------------------------------------------------------------------------------
mkdir -p $target/gdb
cd $target/gdb

PLATFORM=`uname -s`

if [ ! -f configured-gdb ]
then
	CFLAGS="$cflags" \
	CXXFLAGS="$cflags" \
	LDFLAGS="$ldflags" \
	../../gdb-$GDB_VER/configure \
	--disable-nls --prefix=$prefix --target=$target --disable-werror \
	$CROSS_PARAMS \
	|| { echo "Error configuring gdb"; exit 1; }
	touch configured-gdb
fi

if [ ! -f built-gdb ]
then
	$MAKE -j$numjobs || { echo "Error building gdb"; exit 1; }
	touch built-gdb
fi

if [ ! -f installed-gdb ]
then
	$MAKE install || { echo "Error installing gdb"; exit 1; }
	touch installed-gdb
fi

