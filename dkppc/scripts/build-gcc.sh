#!/bin/bash
#---------------------------------------------------------------------------------
# Check Parameters
#---------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
# build and install ppc binutils
#---------------------------------------------------------------------------------

mkdir -p $target/binutils
cd $target/binutils

if [ ! -f configured-binutils ]
then
	CFLAGS=$cflags LDFLAGS=$ldflags ../../binutils-$BINUTILS_VER/configure \
	--prefix=$prefix --target=$target --disable-nls --disable-shared --disable-debug \
	--disable-werror \
	--enable-poison-system-directories \
	--enable-plugins --enable-lto \
	--disable-werror $CROSS_PARAMS \
	|| { echo "Error configuing ppc binutils"; exit 1; }
	touch configured-binutils
fi

if [ ! -f built-binutils ]
then
	$MAKE || { echo "Error building ppc binutils"; exit 1; }
	touch built-binutils
fi

if [ ! -f installed-binutils ]
then
	$MAKE install || { echo "Error installing ppc binutils"; exit 1; }
	touch installed-binutils
fi
cd $BUILDDIR


#---------------------------------------------------------------------------------
# build and install mn10200 binutils
#---------------------------------------------------------------------------------

mkdir -p mn10200/binutils
cd mn10200/binutils

if [ ! -f configured-binutils ]
then
	CFLAGS=$cflags LDFLAGS=$ldflags ../../binutils-$MN_BINUTILS_VER/configure \
	--prefix=$prefix --target=mn10200 --disable-nls --disable-debug \
	--disable-multilib \
	--disable-werror $CROSS_PARAMS \
	|| { echo "Error configuing mn10200 binutils"; exit 1; }
	touch configured-binutils
fi

if [ ! -f built-binutils ]
then
	$MAKE || { echo "Error building mn10200 binutils"; exit 1; }
	touch built-binutils
fi

if [ ! -f installed-binutils ]
then
	$MAKE install || { echo "Error installing mn10200 binutils"; exit 1; }
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
	--enable-languages=c,c++,objc \
	--enable-lto $plugin_ld \
	--with-cpu=750 \
	--disable-nls --disable-shared --enable-threads --disable-multilib \
	--disable-win32-registry \
	--disable-libstdcxx-pch \
	--disable-libstdcxx-verbose \
	--enable-cxx-flags='-ffunction-sections -fdata-sections' \
	--target=$target \
	--with-newlib \
	--with-headers=../../newlib-$NEWLIB_VER/newlib/libc/include \
	--prefix=$prefix\
	--with-system-zlib\
	--with-bugurl="http://wiki.devkitpro.org/index.php/Bug_Reports" --with-pkgversion="devkitPPC release 29-1" \
	$CROSS_PARAMS \
	|| { echo "Error configuring gcc stage 1"; exit 1; }
	touch configured-gcc
fi

if [ ! -f built-gcc-stage1 ]
then
	$MAKE all-gcc || { echo "Error building gcc stage1"; exit 1; }
	touch built-gcc-stage1
fi

if [ ! -f installed-gcc-stage1 ]
then
	$MAKE install-gcc || { echo "Error installing gcc stage1"; exit 1; }
	touch installed-gcc-stage1
fi

#---------------------------------------------------------------------------------
# build and install newlib
#---------------------------------------------------------------------------------
cd $BUILDDIR
mkdir -p $target/newlib
cd $target/newlib

unset CFLAGS
unset LDFLAGS

if [ ! -f configured-newlib ]
then
	CFLAGS_FOR_TARGET="-O2 -ffunction-sections -fdata-sections" \
	../../newlib-$NEWLIB_VER/configure \
	--target=$target \
	--prefix=$prefix \
	--enable-newlib-mb \
	--enable-newlib-hw-fp \
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
	$MAKE install -j1 || { echo "Error installing newlib"; exit 1; }
	touch installed-newlib
fi

#---------------------------------------------------------------------------------
# build and install the final compiler
#---------------------------------------------------------------------------------

cd $BUILDDIR

cd $target/gcc

if [ ! -f built-stage2 ]
then
	$MAKE all || { echo "Error building gcc stage2"; exit 1; }
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

if [ ! -f configured-gdb ]
then
	CFLAGS="$cflags" LDFLAGS="$ldflags" ../../gdb-$GDB_VER/configure \
	--disable-nls --prefix=$prefix --target=$target --disable-werror \
	$CROSS_PARAMS || { echo "Error configuring gdb"; exit 1; }
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

