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
	--disable-threads --with-gcc --with-gnu-as --with-gnu-ld --with-stabs \
	2>&1 | tee binutils_configure.log
	

$MAKE | tee binutils_make.log 2>&1
$MAKE install | tee binutils_install.log 2>&1

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


../../$GCC_SRCDIR/configure \
	--enable-languages=c,c++ \
	--with-cpu=arm7tdmi\
	--enable-interwork --enable-multilib\
	--with-gcc --with-gnu-ld --with-gnu-as --with-stabs \
	--disable-shared --disable-threads --disable-win32-registry --disable-nls\
	--target=$target \
	--with-newlib \
	--prefix=$prefix -v\
	2>&1 | tee gcc_configure.log

$MAKE all-gcc | tee gcc_make.log 2>&1
$MAKE install-gcc | tee gcc_install.log 2>&1

cd $BUILDSCRIPTDIR

#---------------------------------------------------------------------------------
# build and install newlib
#---------------------------------------------------------------------------------
mkdir -p $target/newlib
cd $target/newlib

$BUILDSCRIPTDIR/$NEWLIB_SRCDIR/configure	--target=$target \
											--prefix=$prefix \
											--enable-serial-configure \
											--enable-newlib-mb \
											| tee newlib_configure.log 2>&1

$MAKE all | tee newlib_make.log 2>&1
$MAKE install | tee newlib_install.log 2>&1

cd $BUILDSCRIPTDIR

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

$MAKE | tee gcc_final_make.log 2>&1
$MAKE install | tee gcc_final_install.log 2>&1

cd $BUILDSCRIPTDIR

#---------------------------------------------------------------------------------
# remove temp stuff to conserve disc space
#---------------------------------------------------------------------------------
rm -fr $target/gcc
rm -fr $GCC_SRCDIR
