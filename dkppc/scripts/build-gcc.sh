#!/bin/sh
#---------------------------------------------------------------------------------
# Check Parameters
#---------------------------------------------------------------------------------

prefix=$INSTALLDIR/devkitPPC

#---------------------------------------------------------------------------------
# build and install binutils
#---------------------------------------------------------------------------------

mkdir -p $target/binutils
cd $target/binutils

../../$BINUTILS_SRCDIR/configure \
	--prefix=$prefix --target=$target --disable-nls --disable-shared --disable-debug \
	--with-gcc --with-gnu-as --with-gnu-ld --with-stabs \
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
	--with-cpu=750\
	--with-gcc --with-gnu-ld --with-gnu-as --with-stabs \
	--with-included-gettext --without-headers\
	--disable-nls --disable-shared --enable-threads --disable-multilib\
	--disable-win32-registry\
	--target=$target \
	--with-newlib \
	--prefix=$prefix -v\
	2>&1 | tee gcc_configure.log

mkdir -p libiberty libcpp fixincludes

$MAKE all-gcc | tee gcc_make.log 2>&1
$MAKE install-gcc | tee gcc_install.log 2>&1

#---------------------------------------------------------------------------------
# build and install newlib
#---------------------------------------------------------------------------------
cd $BUILDSCRIPTDIR
mkdir -p $target/newlib
cd $target/newlib
mkdir -p etc

$BUILDSCRIPTDIR/$NEWLIB_SRCDIR/configure	--target=$target \
											--prefix=$prefix \
											--enable-serial-configure \
											| tee newlib_configure.log 2>&1

$MAKE all | tee newlib_make.log
$MAKE install | tee newlib_install.log

cd $BUILDSCRIPTDIR

#---------------------------------------------------------------------------------
# remove temp stuff to conserve disc space
#---------------------------------------------------------------------------------
rm -fr $target/newlib
rm -fr $NEWLIB_SRCDIR

#---------------------------------------------------------------------------------
# build and install the final compiler
#---------------------------------------------------------------------------------

cd $target/gcc

$MAKE | tee gcc_final_make.log 2>&1
$MAKE install | tee gcc_final_install.log 2>&1

cd $BUILDSCRIPTDIR

#---------------------------------------------------------------------------------
# remove temp stuff to conserve disc space
#---------------------------------------------------------------------------------
rm -fr $target/gcc
rm -fr $GCC_SRCDIR
