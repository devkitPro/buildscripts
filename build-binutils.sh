#!/bin/sh
#---------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
# build and install binutils
#---------------------------------------------------------------------------------

mkdir -p $target/binutils
pushd $target/binutils

if [ ! -f configured-binutils ]
then
        CPPFLAGS="$cppflags $CPPFLAGS" LDFLAGS="$ldflags $LDFLAGS" ../../binutils-$BINUTILS_VER/configure \
        --prefix=$prefix --target=$target \
        --disable-nls --disable-werror \
        --disable-shared --disable-debug \
        --enable-lto --enable-plugins \
        --enable-poison-system-directories \
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
popd
