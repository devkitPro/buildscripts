#!/bin/bash
#---------------------------------------------------------------------------------
# Check Parameters
#---------------------------------------------------------------------------------

prefix=$INSTALLDIR/devkitPPC

PLATFORM=`uname -s`

case $PLATFORM in
  Darwin )	
    cflags="-mmacosx-version-min=10.4 -isysroot /Developer/SDKs/MacOSX10.4u.sdk -arch i386 -arch ppc"
	ldflags="-mmacosx-version-min=10.4 -arch i386 -arch ppc -Wl,-syslibroot,/Developer/SDKs/MacOSX10.4u.sdk"
    ;;
  MINGW32* )
    cflags="-D__USE_MINGW_ACCESS"
# horrid hack to get -flto to work on windows
    plugin_ld="--with-plugin-ld=ld"
    ;;
esac

#---------------------------------------------------------------------------------
# build and install ppc binutils
#---------------------------------------------------------------------------------

mkdir -p $target/binutils
cd $target/binutils

if [ ! -f configured-binutils ]
then
  CFLAGS=$cflags LDFLAGS=$ldflags ../../$BINUTILS_SRCDIR/configure \
	--prefix=$prefix --target=$target --disable-nls --disable-shared --disable-debug \
	--disable-werror \
	--with-gcc --with-gnu-as --with-gnu-ld --disable-dependency-tracking \
	--disable-werror \
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
  CFLAGS=$cflags LDFLAGS=$ldflags ../../$BINUTILS_SRCDIR/configure \
	--prefix=$prefix --target=mn10200 --disable-nls --disable-shared --disable-debug \
	--disable-werror \
	--disable-dependency-tracking --with-gcc --with-gnu-as --with-gnu-ld \
	--disable-werror \
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
  cp -r $BUILDSCRIPTDIR/$NEWLIB_SRCDIR/newlib/libc/include $INSTALLDIR/devkitPPC/$target/sys-include
  CFLAGS="$cflags" LDFLAGS="$ldflags" CFLAGS_FOR_TARGET="-O2" LDFLAGS_FOR_TARGET="" ../../$GCC_SRCDIR/configure \
  --enable-languages=c,c++,objc \
  --enable-lto $plugin_ld\
  --with-cpu=750 \
  --disable-nls --disable-shared --enable-threads --disable-multilib \
  --disable-win32-registry \
  --disable-libstdcxx-pch \
  --target=$target \
  --with-newlib \
  --prefix=$prefix\
  --disable-dependency-tracking \
  --with-bugurl="http://wiki.devkitpro.org/index.php/Bug_Reports" --with-pkgversion="devkitPPC release 24" \
  2>&1 | tee gcc_configure.log
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
  rm -fr $INSTALLDIR/devkitPPC/$target/sys-include
fi

#---------------------------------------------------------------------------------
# build and install newlib
#---------------------------------------------------------------------------------
cd $BUILDSCRIPTDIR
mkdir -p $target/newlib
cd $target/newlib

unset CFLAGS
unset LDFLAGS

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
mkdir -p $target/gcc
cd $target/gcc

if [ ! -f built-gcc-stage2 ]
then
  $MAKE all || { echo "Error building gcc stage2"; exit 1; }
  touch built-gcc-stage2
fi

if [ ! -f installed-gcc-stage2 ]
then
  $MAKE install || { echo "Error installing gcc stage2"; exit 1; }
  touch installed-gcc-stage2
fi


cd $BUILDSCRIPTDIR

#---------------------------------------------------------------------------------
# build and install the debugger
#---------------------------------------------------------------------------------
mkdir -p $target/gdb
cd $target/gdb

PLATFORM=`uname -s`


if [ ! -f configured-gdb ]
then
  CFLAGS="$cflags" LDFLAGS="$ldflags" ../../$GDB_SRCDIR/configure \
  --disable-nls --prefix=$prefix --target=$target --disable-werror --disable-dependency-tracking\
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

