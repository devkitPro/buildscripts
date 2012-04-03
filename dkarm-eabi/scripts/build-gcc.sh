#!/bin/sh
#---------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
# build and install binutils
#---------------------------------------------------------------------------------

mkdir -p $target/binutils
cd $target/binutils

if [ ! -f configured-binutils ]
then
	CFLAGS=$cflags LDFLAGS=$ldflags ../../binutils-$BINUTILS_VER/configure \
        --prefix=$prefix --target=$target --disable-nls --disable-dependency-tracking --disable-werror \
	--enable-lto --enable-plugins \
	$CROSS_PARAMS \
        || { echo "Error configuring binutils"; exit 1; }
	touch configured-binutils
fi

if [ ! -f built-binutils ]
then
  $MAKE || { echo "Error building binutils"; exit 1; }
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
  CFLAGS="$cflags" LDFLAGS="$ldflags" CFLAGS_FOR_TARGET="-O2" LDFLAGS_FOR_TARGET="" ../../gcc-$GCC_VER/configure \
        --enable-languages=c,c++,objc \
        --with-march=armv4t\
        --enable-interwork --enable-multilib\
        --with-gcc --with-gnu-ld --with-gnu-as \
        --disable-dependency-tracking \
        --disable-threads --disable-win32-registry --disable-nls --disable-debug\
        --disable-libmudflap --disable-libssp --disable-libgomp \
        --disable-libstdcxx-pch \
        --target=$target \
        --with-newlib \
	--with-headers=$BUILDDIR/newlib-$NEWLIB_VER/newlib/libc/include \
        --prefix=$prefix \
        --enable-lto $plugin_ld\
        --with-bugurl="http://wiki.devkitpro.org/index.php/Bug_Reports" --with-pkgversion="devkitARM release 38" \
	$CROSS_PARAMS \
        || { echo "Error configuring gcc"; exit 1; }
  touch configured-gcc
fi

if [ ! -f built-gcc-stage1 ]
then
	$MAKE all-gcc || { echo "Error building gcc stage1"; exit 1; }
	touch built-gcc-stage1
fi

if [ ! -f installed-gcc-stage1 ]
then
	$MAKE install-gcc || { echo "Error installing gcc"; exit 1; }
	touch installed-gcc-stage1
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
	CFLAGS_FOR_TARGET="-DREENTRANT_SYSCALLS_PROVIDED -D__DEFAULT_UTF8__ -O2" ../../newlib-$NEWLIB_VER/configure \
	--disable-newlib-supplied-syscalls \
	--enable-newlib-mb \
	--enable-newlib-io-long-long \
	--target=$target \
	--prefix=$prefix \
	|| { echo "Error configuring newlib"; exit 1; }
	touch configured-newlib
fi

if [ ! -f built-newlib ]
then
	$MAKE || { echo "Error building newlib"; exit 1; }
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

if [ ! -f built-gcc-stage2 ]
then
	$MAKE || { echo "Error building gcc stage2"; exit 1; }
	touch built-gcc-stage2
fi

if [ ! -f installed-gcc-stage2 ]
then
	$MAKE install || { echo "Error installing gcc stage2"; exit 1; }
	touch installed-gcc-stage2
fi

cd $BUILDDIR

#---------------------------------------------------------------------------------
# build and install the debugger
#---------------------------------------------------------------------------------
mkdir -p $target/gdb
cd $target/gdb

PLATFORM=`uname -s`

if [ ! -f configured-gdb ]
then
	CFLAGS="$cflags" LDFLAGS="$ldflags" ../../gdb-$GDB_VER/configure \
	--disable-nls --prefix=$prefix --target=$target --disable-werror \
	--disable-dependency-tracking \
	$CROSS_PARAMS \
	|| { echo "Error configuring gdb"; exit 1; }
	touch configured-gdb
fi

if [ ! -f built-gdb ]
then
	$MAKE || { echo "Error building gdb"; exit 1; }
	touch built-gdb
fi

if [ ! -f installed-gdb ]
then
	$MAKE install || { echo "Error installing gdb"; exit 1; }
	touch installed-gdb
fi

