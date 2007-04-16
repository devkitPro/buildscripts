#!/bin/sh
#---------------------------------------------------------------------------------
# Check Parameters
#---------------------------------------------------------------------------------

prefix=$INSTALLDIR/devkitARM

#---------------------------------------------------------------------------------
# build and install binutils
#---------------------------------------------------------------------------------

mkdir -p $target/binutils
cd $target/binutils

../../$BINUTILS_SRCDIR/configure \
	--prefix=$prefix --target=$target --disable-nls --disable-shared --disable-debug \
	--disable-threads --with-gcc --with-gnu-as --with-gnu-ld \
	|| { echo "Error configuring binutils"; exit 1; }

$MAKE || { echo "Error building binutils"; exit 1; }
$MAKE install || { echo "Error installing binutils"; exit 1; }

cd $BUILDSCRIPTDIR

#---------------------------------------------------------------------------------
# remove temp stuff to conserve disc space
#---------------------------------------------------------------------------------
rm -fr $target/binutils
rm -fr $BINUTILS_SRCDIR

#---------------------------------------------------------------------------------
# build and install just the c compiler
#---------------------------------------------------------------------------------
mkdir -p $target/gcc
cd $target/gcc


CFLAGS=-D__USE_MINGW_ACCESS ../../$GCC_SRCDIR/configure \
	--enable-languages=c,c++ \
	--with-cpu=arm7tdmi\
	--enable-interwork --enable-multilib\
	--with-gcc --with-gnu-ld --with-gnu-as \
	--disable-shared --disable-threads --disable-win32-registry --disable-nls --disable-debug\
	--disable-libmudflap --disable-libssp \
	--target=$target \
	--with-newlib \
	--prefix=$prefix\
	|| { echo "Error configuring gcc"; exit 1; }

mkdir -p libiberty libcpp fixincludes

$MAKE all-gcc || { echo "Error building gcc"; exit 1; }
$MAKE install-gcc || { echo "Error installing gcc"; exit 1; }

cd $BUILDSCRIPTDIR

#---------------------------------------------------------------------------------
# build and install newlib
#---------------------------------------------------------------------------------
mkdir -p $target/newlib
cd $target/newlib
mkdir -p etc

CFLAGS=-DREENTRANT_SYSCALLS_PROVIDED ../../$NEWLIB_SRCDIR/configure \
	--disable-newlib-supplied-syscalls \
	--disable-debug \
	--target=$target \
	--prefix=$prefix \
	|| { echo "Error configuring newlib"; exit 1; }

$MAKE || { echo "Error building newlib"; exit 1; }
$MAKE install || { echo "Error installing newlib"; exit 1; }

#---------------------------------------------------------------------------------
# remove temp stuff to conserve disc space
#---------------------------------------------------------------------------------
rm -fr $target/newlib
rm -fr $NEWLIB_SRCDIR

#---------------------------------------------------------------------------------
# build and install the final compiler
#---------------------------------------------------------------------------------

cd $BUILDSCRIPTDIR
cd $target/gcc

$MAKE || { echo "Error building g++"; exit 1; }
$MAKE install || { echo "Error installing g++"; exit 1; }

cd $BUILDSCRIPTDIR

#---------------------------------------------------------------------------------
# remove temp stuff to conserve disc space
#---------------------------------------------------------------------------------
rm -fr $target/gcc
rm -fr $GCC_SRCDIR
