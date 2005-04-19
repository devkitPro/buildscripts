#!/bin/sh
#---------------------------------------------------------------------------------

prefix=$INSTALLDIR

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

#---------------------------------------------------------------------------------
# remove temp stuff to conserve disc space
#---------------------------------------------------------------------------------
rm -fr $target/binutils
rm -fr $BINUTILS_SRCDIR

#---------------------------------------------------------------------------------
# build and install just the c compiler
#---------------------------------------------------------------------------------
cd $BUILDSCRIPTDIR
mkdir -p $target/gcc
cd $target/gcc

../../$GCC_SRCDIR/configure \
	--enable-languages=c,c++ \
	--with-cpu=750\
	--with-gcc --with-gnu-ld --with-gnu-as --with-stabs \
	--disable-nls --disable-shared --enable-threads --disable-multilib\
	--enable-serial-configure \
	--disable-win32-registry\
	--target=$target \
	--with-newlib \
	--prefix=$prefix -v\
	2>&1 | tee gcc_configure.log

$MAKE all-gcc | tee gcc_make.log 2>&1
$MAKE install-gcc | tee gcc_install.log 2>&1

#---------------------------------------------------------------------------------
# build and install newlib
#---------------------------------------------------------------------------------
cd $BUILDSCRIPTDIR
mkdir -p $target/newlib
cd $target/newlib

../../$NEWLIB_SRCDIR/configure --target=$target --prefix=$prefix | tee newlib_configure.log 2>&1

$MAKE all | tee newlib_make.log 2>&1
$MAKE install | tee newlib_install.log 2>&1

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

#---------------------------------------------------------------------------------
# remove temp stuff to conserve disc space
#---------------------------------------------------------------------------------
rm -fr $target/gcc
rm -fr $GCC_SRCDIR
