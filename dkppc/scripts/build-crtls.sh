#!/bin/sh

export DEVKITPPC=$TOOLPATH/devkitPPC
export DEVKITPRO=$TOOLPATH

#---------------------------------------------------------------------------------
# Install and build the gamecube crt and libogc
#---------------------------------------------------------------------------------

echo "installing linkscripts ..."
cp `pwd`/dkppc/crtls/*.ld $DEVKITPPC/$target/lib/
#---------------------------------------------------------------------------------
# copy base rulesets
#---------------------------------------------------------------------------------
cp `pwd`/dkppc/rules/* $DEVKITPPC

cd $LIBOGC_SRCDIR
if [ ! -f built-libogc ]
then
  echo "building libogc ..."
  $MAKE
  touch built-libogc
fi

if [ ! -f installed-libogc ]
then
  echo "installing libogc ..."
  $MAKE install
  touch installed-libogc
fi

cd $LIBFAT_SRCDIR
if [ ! -f built-libfat ]
then
  echo "building libfat ..."
  $MAKE install INSTALLDIR=$TOOLPATH 
  touch built-libfat
fi


cd $BUILDSCRIPTDIR



