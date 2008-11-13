#!/bin/sh
#---------------------------------------------------------------------------------
# Check Parameters
#---------------------------------------------------------------------------------

prefix=$INSTALLDIR/devkitARM

PLATFORM=`uname -s`

case $PLATFORM in
  "Darwin" )
    CONFIG_EXTRA=env CFLAGS="-O -g -mmacosx-version-min=10.4 -isysroot /Developer/SDKs/MacOSX10.4u.sdk -arch i386 -arch ppc" LDFLAGS="-arch i386 -arch ppc"
    ;;
  "" )
    ;;
esac

#---------------------------------------------------------------------------------
# build and install binutils
#---------------------------------------------------------------------------------

mkdir -p $target/binutils
cd $target/binutils

if [ ! -f configured-binutils ]
then
  $CONFIG_EXTRA ../../$BINUTILS_SRCDIR/configure \
        --prefix=$prefix --target=$target --disable-nls \
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
cd $BUILDSCRIPTDIR

#---------------------------------------------------------------------------------
# build and install just the c compiler
#---------------------------------------------------------------------------------
mkdir -p $target/gcc
cd $target/gcc


if [ ! -f configured-gcc ]
then
  $CONFIG_EXTRA ../../$GCC_SRCDIR/configure \
        --enable-languages=c,c++ \
        --with-cpu=arm7tdmi\
        --enable-interwork --enable-multilib\
        --with-gcc --with-gnu-ld --with-gnu-as \
        --disable-shared --disable-threads --disable-win32-registry --disable-nls --disable-debug\
        --disable-libmudflap --disable-libssp --disable-libgomp \
        --disable-libstdcxx-pch \
        --target=$target \
        --with-newlib \
        --prefix=$prefix\
        --with-bugurl="http://wiki.devkitpro.org/index.php/Bug_Reports" --with-pkgversion="devkitARM release 24" \
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

cd $BUILDSCRIPTDIR

#---------------------------------------------------------------------------------
# build and install newlib
#---------------------------------------------------------------------------------
mkdir -p $target/newlib
cd $target/newlib

if [ ! -f configured-newlib ]
then
 ../../$NEWLIB_SRCDIR/configure \
        --disable-newlib-supplied-syscalls \
        --enable-newlib-mb \
        --target=$target \
        --prefix=$prefix \
        || { echo "Error configuring newlib"; exit 1; }
  touch configured-newlib
fi

if [ ! -f built-newlib ]
then
  $MAKE CFLAGS_FOR_TARGET=-DREENTRANT_SYSCALLS_PROVIDED || { echo "Error building newlib"; exit 1; }
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

cd $BUILDSCRIPTDIR
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

cd $BUILDSCRIPTDIR

#---------------------------------------------------------------------------------
# build and install the debugger
#---------------------------------------------------------------------------------
mkdir -p $target/gdb
cd $target/gdb

if [ ! -f configured-gdb ]
then
  $CONFIG_EXTRA ../../$GDB_SRCDIR/configure \
        --disable-nls --prefix=$prefix --target=$target --disable-werror \
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
