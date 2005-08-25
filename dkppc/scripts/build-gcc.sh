#!/bin/sh
#---------------------------------------------------------------------------------
# Check Parameters
#---------------------------------------------------------------------------------

prefix=$INSTALLDIR/devkitPPC

#---------------------------------------------------------------------------------
# build and install ppc binutils
#---------------------------------------------------------------------------------

mkdir -p $target/binutils
cd $target/binutils

../../$BINUTILS_SRCDIR/configure \
	--prefix=$prefix --target=$target --disable-nls --disable-shared --disable-debug \
	--with-gcc --with-gnu-as --with-gnu-ld --with-stabs \
	|| { echo "Error configuing ppc binutils"; exit 1; }


$MAKE || { echo "Error building ppc binutils"; exit 1; }
$MAKE install || { echo "Error installing ppc binutils"; exit 1; }

cd $BUILDSCRIPTDIR

#---------------------------------------------------------------------------------
# remove temp stuff to conserve disc space
#---------------------------------------------------------------------------------
rm -fr $target/binutils

#---------------------------------------------------------------------------------
# build and install mn10200 binutils
#---------------------------------------------------------------------------------

mkdir -p mn10200/binutils
cd mn10200/binutils

../../$BINUTILS_SRCDIR/configure \
	--prefix=$prefix --target=mn10200 --disable-nls --disable-shared --disable-debug \
	--with-gcc --with-gnu-as --with-gnu-ld --with-stabs \
	|| { echo "Error configuing mn10200 binutils"; exit 1; }


$MAKE || { echo "Error building mn10200 binutils"; exit 1; }
$MAKE install || { echo "Error installing mn10200 binutils"; exit 1; }

cd $BUILDSCRIPTDIR

#---------------------------------------------------------------------------------
# remove temp stuff to conserve disc space
#---------------------------------------------------------------------------------
rm -fr mn10200/binutils

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
	--disable-nls --disable-shared --enable-threads --disable-multilib --disable-debug\
	--disable-win32-registry\
	--target=$target \
	--with-newlib \
	--prefix=$prefix -v\
	2>&1 | tee gcc_configure.log

mkdir -p libiberty libcpp fixincludes

$MAKE all-gcc || { echo "Error building gcc"; exit 1; }
$MAKE install-gcc || { echo "Error installing gcc"; exit 1; }

#---------------------------------------------------------------------------------
# build and install newlib
#---------------------------------------------------------------------------------
cd $BUILDSCRIPTDIR
mkdir -p $target/newlib
cd $target/newlib
mkdir -p etc

$BUILDSCRIPTDIR/$NEWLIB_SRCDIR/configure	--target=$target \
						--prefix=$prefix \
						--disable-debug \
						|| { echo "Error configuring newlib"; exit 1; }

$MAKE || { echo "Error building newlib"; exit 1; }
$MAKE install || { echo "Error installing newlib"; exit 1; }

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

$MAKE || { echo "Error building g++"; exit 1; }
$MAKE install || { echo "Error installing g++"; exit 1; }

cd $BUILDSCRIPTDIR

#---------------------------------------------------------------------------------
# remove temp stuff to conserve disc space
#---------------------------------------------------------------------------------
rm -fr $target/gcc
rm -fr $GCC_SRCDIR
