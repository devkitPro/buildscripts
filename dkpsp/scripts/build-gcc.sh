#!/bin/sh

#---------------------------------------------------------------------------------
# build and install binutils
#---------------------------------------------------------------------------------

mkdir -p $target/binutils
cd $target/binutils

if [ ! -f configured-binutils ]
then
	CFLAGS=$cflags LDFLAGS=$ldflags ../../binutils-$BINUTILS_VER/configure \
	--prefix=$prefix --target=$target --disable-nls --disable-debug \
	--enable-lto --enable-plugins \
	--disable-dependency-tracking  --disable-werror \
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
	--disable-multilib\
	--with-gcc --with-gnu-ld --with-gnu-as\
	--disable-shared --disable-win32-registry --disable-nls\
	--enable-cxx-flags="-G0" \
	--disable-libstdcxx-pch \
	--target=$target \
	--with-newlib \
	--enable-lto $plugin_ld \
	--with-headers=../../newlib-$NEWLIB_VER/newlib/libc/include \
	--prefix=$prefix \
	--disable-dependency-tracking \
	--with-bugurl="http://wiki.devkitpro.org/index.php/Bug_Reports" --with-pkgversion="devkitPSP release 17" \
	$CROSS_PARAMS \
	|| { echo "Error configuring gcc"; exit 1; }
	touch configured-gcc
fi


if [ ! -f built-gcc ]
then
	$MAKE all-gcc || { echo "Error building gcc"; exit 1; }
	touch built-gcc
fi


if [ ! -f installed-gcc ]
then
	$MAKE install-gcc || { echo "Error installing gcc"; exit 1; }
	touch installed-gcc
fi

unset CFLAGS
cd $BUILDDIR/pspsdk-$PSPSDK_VER

if [ ! -f bootstrap-sdk ]
then
	./bootstrap || { echo "ERROR RUNNING PSPSDK BOOTSTRAP"; exit 1; }
	touch bootstrap-sdk
fi

if [ ! -f configure-sdk ]
then
	./configure --with-pspdev="$prefix" $CROSS_PARAMS || { echo "ERROR RUNNING PSPSDK CONFIGURE"; exit 1; }
	touch configure-sdk
fi

if [ ! -f install-sdk-data ]
then
	$MAKE install-data || { echo "ERROR INSTALLING PSPSDK HEADERS"; exit 1; }
	touch install-sdk-data
fi

cd $BUILDDIR

#---------------------------------------------------------------------------------
# build and install newlib
#---------------------------------------------------------------------------------
mkdir -p $target/newlib
cd $target/newlib

if [ ! -f configured-newlib ]
then
	../../newlib-$NEWLIB_VER/configure \
	--target=$target \
	--prefix=$prefix \
	--disable-dependency-tracking \
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

cd $BUILDDIR


#---------------------------------------------------------------------------------
# build and install the final compiler
#---------------------------------------------------------------------------------

cd $target/gcc

if [ ! -f built-g++ ]
then
	$MAKE || { echo "Error building g++"; exit 1; }
	touch built-g++
fi

if [ ! -f installed-g++ ]
then
	$MAKE install || { echo "Error installing g++"; exit 1; }
	touch installed-g++
fi

cd $BUILDDIR/pspsdk-$PSPSDK_VER

#---------------------------------------------------------------------------------
# build and install the psp sdk
#---------------------------------------------------------------------------------
echo "building pspsdk ..."

if [ ! -f built-sdk ]
then
	$MAKE || { echo "ERROR BUILDING PSPSDK"; exit 1; }
	touch built-sdk
fi

if [ ! -f installed-sdk ]
then
	$MAKE install || { echo "ERROR INSTALLING PSPSDK"; exit 1; }
	touch installed-sdk
fi

cd $BUILDDIR

#---------------------------------------------------------------------------------
# build and install the debugger
#---------------------------------------------------------------------------------
mkdir -p $target/gdb
cd $target/gdb

if [ ! -f configured-gdb ]
then
	CFLAGS=$cflags LDFLAGS=$ldflags ../../gdb-$GDB_VER/configure \
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

