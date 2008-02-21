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

if [ ! -f configured-binutils ]
then
  ../../$BINUTILS_SRCDIR/configure \
	--prefix=$prefix --target=$target --disable-nls --disable-shared --disable-debug \
	--with-gcc --with-gnu-as --with-gnu-ld \
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
cd $BUILDSCRIPTDIR


#---------------------------------------------------------------------------------
# build and install mn10200 binutils
#---------------------------------------------------------------------------------

mkdir -p mn10200/binutils
cd mn10200/binutils

if [ ! -f configured-binutils ]
then
  ../../$BINUTILS_SRCDIR/configure \
	--prefix=$prefix --target=mn10200 --disable-nls --disable-shared --disable-debug \
	--with-gcc --with-gnu-as --with-gnu-ld \
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

for f in	$INSTALLDIR/devkitPPC/mn10200/bin/*
do
	strip $f
done

cd $BUILDSCRIPTDIR

#---------------------------------------------------------------------------------
# build and install just the c compiler
#---------------------------------------------------------------------------------
mkdir -p $target/gcc
cd $target/gcc

if [ ! -f configured-gcc ]
then
  CFLAGS=-D__USE_MINGW_ACCESS ../../$GCC_SRCDIR/configure \
	--enable-languages=c,c++ \
	--with-cpu=750\
	--without-headers\
	--disable-nls --disable-shared --enable-threads --disable-multilib \
	--disable-win32-registry\
    --disable-libstdcxx-pch \
	--target=$target \
	--with-newlib \
	--prefix=$prefix\
	2>&1 | tee gcc_configure.log
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

#---------------------------------------------------------------------------------
# build and install newlib
#---------------------------------------------------------------------------------
cd $BUILDSCRIPTDIR
mkdir -p $target/newlib
cd $target/newlib

if [ ! -f configured-newlib ]
then
  $BUILDSCRIPTDIR/$NEWLIB_SRCDIR/configure \
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
  $MAKE install || { echo "Error installing newlib"; exit 1; }
  touch installed-newlib
fi

cd $BUILDSCRIPTDIR

#---------------------------------------------------------------------------------
# build and install the final compiler
#---------------------------------------------------------------------------------

cd $BUILDSCRIPTDIR
cd $target/gcc

if [ ! -f built-gpp ]
then
  $MAKE || { echo "Error building g++"; exit 1; }
  touch built-gpp
fi

if [ ! -f installed-gpp ]
then
  $MAKE install || { echo "Error installing g++"; exit 1; }
  touch installed-gpp
fi

cd $BUILDSCRIPTDIR

#---------------------------------------------------------------------------------
# build and install the debugger
#---------------------------------------------------------------------------------
mkdir -p $target/gdb
cd $target/gdb

if [ ! -f configured-gdb ]
then
  ../../$GDB_SRCDIR/configure \
        --disable-nls --prefix=$prefix --target=$target \
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

