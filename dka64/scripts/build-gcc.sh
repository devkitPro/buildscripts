#!/bin/sh
#---------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
# build and install binutils
#---------------------------------------------------------------------------------

mkdir -p $target/binutils
cd $target/binutils

if [ ! -f configured-binutils ]
then
	../../binutils-$BINUTILS_VER/configure \
        --prefix=$prefix --target=$target --disable-nls --disable-werror \
	--enable-lto --enable-plugins --enable-poison-system-directories \
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
	CFLAGS_FOR_TARGET="-O2 -ffunction-sections -fdata-sections" \
	CXXFLAGS_FOR_TARGET="-O2 -ffunction-sections -fdata-sections" \
	LDFLAGS_FOR_TARGET="" \
	../../gcc-$GCC_VER/configure \
		--enable-languages=c,c++,objc,lto \
		--with-gnu-as --with-gnu-ld --with-gcc \
		--with-march=armv8\
		--enable-cxx-flags='-ffunction-sections' \
		--disable-libstdcxx-verbose \
		--enable-poison-system-directories \
		--enable-multilib \
		--enable-threads --disable-win32-registry --disable-nls --disable-debug\
		--disable-libmudflap --disable-libssp --disable-libgomp \
		--disable-libstdcxx-pch \
		--enable-libstdcxx-time \
		--enable-libstdcxx-filesystem-ts \
		--target=$target \
		--with-newlib=yes \
		--with-headers=../../newlib-$NEWLIB_VER/newlib/libc/include \
		--prefix=$prefix \
		--enable-lto \
		--disable-tm-clone-registry \
		--disable-__cxa_atexit \
		--with-bugurl="https://github.com/devkitPro/buildscripts/issues" --with-pkgversion="devkitA64 release 22.1" \
		$CROSS_PARAMS \
		$CROSS_GCC_PARAMS \
		$EXTRA_GCC_PARAMS \
		|| { echo "Error configuring gcc"; exit 1; }
	touch configured-gcc
fi

if [ ! -f built-gcc ]
then
	$MAKE all-gcc || { echo "Error building gcc stage1"; exit 1; }
	touch built-gcc
fi

if [ ! -f installed-gcc ]
then
	$MAKE install-gcc || { echo "Error installing gcc"; exit 1; }
	touch installed-gcc
fi


unset CFLAGS
cd $BUILDDIR

OLD_CC=$CC
OLDCXX=$CXX
unset CC
unset CXX

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
	$MAKE || { echo "Error building newlib"; exit 1; }
	touch built-newlib
fi


if [ ! -f installed-newlib ]
then
	$MAKE install -j1 || { echo "Error installing newlib"; exit 1; }
	touch installed-newlib
fi

export CC=$OLD_CC
export CXX=$OLD_CXX

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
