#!/bin/sh
#---------------------------------------------------------------------------------
# Build scripts for devkitARM/devkitPPC release 12
#---------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
# specify some urls to download the source packages from
#---------------------------------------------------------------------------------
BINUTILS_VER=2.15
GCC_VER=3.4.3
NEWLIB_VER=1.13.0
LIBOGC_VER=20050419
LIBGBA_VER=20050505
LIBNDS_VER=20050505

BINUTILS="binutils-$BINUTILS_VER.tar.bz2"
GCC_CORE="gcc-core-$GCC_VER.tar.bz2"
GCC_GPP="gcc-g++-$GCC_VER.tar.bz2"
NEWLIB="newlib-$NEWLIB_VER.tar.gz"
LIBOGC="libogc-src-$LIBOGC_VER.tar.bz2"
LIBGBA="libgba-src-$LIBGBA_VER.tar.bz2"
LIBNDS="libnds-src-$LIBNDS_VER.tar.bz2"

BINUTILS_URL="http://ftp.gnu.org/gnu/binutils/$BINUTILS"
GCC_CORE_URL="http://ftp.gnu.org/gnu/gcc/gcc-$GCC_VER/$GCC_CORE"
GCC_GPP_URL="http://ftp.gnu.org/gnu/gcc/gcc-$GCC_VER/$GCC_GPP"
LIBOGC_URL="http://osdn.dl.sourceforge.net/sourceforge/devkitpro/$LIBOGC"
LIBGBA_URL="http://osdn.dl.sourceforge.net/sourceforge/devkitpro/$LIBGBA"
LIBNDS_URL="http://osdn.dl.sourceforge.net/sourceforge/devkitpro/$LIBNDS"
NEWLIB_URL="ftp://sources.redhat.com/pub/newlib/$NEWLIB"

#---------------------------------------------------------------------------------
# Ask whether to download the source packages or not
#---------------------------------------------------------------------------------

VERSION=0

while [ $VERSION -eq 0 ]
do
  echo
  echo "This script will build and install your devkit. Please select the one you require"
  echo
  echo "1: build devkitARM (gba gp32 ds)"
  echo "2: build devkitPPC (gamecube)"
  read VERSION

  if [ "$VERSION" -ne 1 -a "$VERSION" -ne 2 ]
  then
      VERSION=0
  fi
done

if [ $VERSION -eq 1 ]
then
  scriptdir='./dka-scripts'
  package='devkitARM'
  builddir=arm-elf
  target=arm-elf
else
  scriptdir='./dkp-scripts'
  package='devkitPPC'
  builddir=powerpc-gekko
  target=powerpc-gekko
fi

DOWNLOAD=0

while [ $DOWNLOAD -eq 0 ]
do
  echo
  echo "The installation requires binutils-$BINUTILS_VER, gcc$GCC_VER and newlib-$NEWLIB_VER.  Please select an option:"
  echo
  echo "1: I have already downloaded the source packages"
  echo "2: Download the packages for me (requires wget)"
  read DOWNLOAD

  if [ "$DOWNLOAD" -ne 1 -a "$DOWNLOAD" -ne 2 ]
  then
      DOWNLOAD=0
  fi
done


#---------------------------------------------------------------------------------
# Get preferred installation directory and set paths to the sources
#---------------------------------------------------------------------------------
echo
echo "Please enter the directory where you would like '$package' to be installed:"
echo "for mingw/msys you must use <drive>:/<install path> or you will have include path problems"
echo "this is the top level directory for devkitpro"

read INSTALLDIR
echo

[ ! -z "$INSTALLDIR" ] && mkdir -p $INSTALLDIR && touch $INSTALLDIR/nonexistantfile && rm $INSTALLDIR/nonexistantfile || exit 1

if [ $DOWNLOAD -eq 1 ]
then
    FOUND=0
    while [ $FOUND -eq 0 ]
    do
      echo
      echo "Please enter the path to the directory that contains the source packages:"
      read SRCDIR

      if [ ! -f $SRCDIR/$BINUTILS ]
      then
	  echo "Error: $BINUTILS not found in $SRCDIR"
	  exit
      else
	  FOUND=1
      fi

      if [ ! -f $SRCDIR/$GCC_GPP ]
      then
    	  echo "Error: $GCC_GPP not found in $SRCDIR"
	      exit
      else
	      FOUND=1
      fi

      if [ ! -f $SRCDIR/$GCC_CORE ]
      then
    	  echo "Error: $GCC_CORE not found in $SRCDIR"
	      exit
      else
	      FOUND=1
      fi

      if [ ! -f $SRCDIR/$NEWLIB ]
      then
	  echo "Error: $NEWLIB not found in $SRCDIR"
	  exit
      else
	  FOUND=1
      fi
    
    if [ $VERSION -eq 2 ]
    then
      if [ ! -f $SRCDIR/$LIBOGC ]
      then
        echo "Error: $LIBOGC not found in $SRCDIR"
	      exit
      else
	      FOUND=1
      fi

    fi

    done

else

    wget -c $BINUTILS_URL
    if [ ! -f $BINUTILS ]
    then
	echo "Error: Failed to download "$BINUTILS
	exit
    fi

    wget -c $GCC_CORE_URL
    if [ ! -f $GCC_CORE ]
    then
	echo "Error: Failed to download "$GCC_CORE
	exit
    fi

    wget -c $GCC_GPP_URL
    if [ ! -f $GCC_GPP ]
    then
	echo "Error: Failed to download "$GCC_GPP
	exit
    fi

    wget --passive-ftp -c $NEWLIB_URL
    if [ ! -f $NEWLIB ]
    then
	echo "Error: Failed to download "$NEWLIB
	exit
	fi

	if [ $VERSION -eq 2 ]
	then
		wget -c $LIBOGC_URL
		if [ ! -f $LIBOGC ]
		then
			echo "Error: Failed to download "$LIBOGC
			exit
		fi   
	fi

	if [ $VERSION -eq 1 ]
	then
		wget -c $LIBNDS_URL
		if [ ! -f $LIBNDS ]
		then
			echo "Error: Failed to download "$LIBNDS
			exit
		fi   
		wget -c $LIBGBA_URL
		if [ ! -f $LIBGBA ]
		then
			echo "Error: Failed to download "$LIBGBA
			exit
		fi   
	fi
	SRCDIR=`pwd`
fi

BINUTILS_SRCDIR="binutils-$BINUTILS_VER"
GCC_SRCDIR="gcc-$GCC_VER"
NEWLIB_SRCDIR="newlib-$NEWLIB_VER"
LIBOGC_SRCDIR="libogc-$LIBOGC_VER"
LIBGBA_SRCDIR="libgba-$LIBGBA_VER"
LIBNDS_SRCDIR="libnds-$LIBNDS_VER"

echo
echo 'Ready to install '$package' in '$INSTALLDIR
echo
echo 'press return to continue'

read dummy



#---------------------------------------------------------------------------------
# find proper make
#---------------------------------------------------------------------------------

if [ -z "$MAKE" -a -x "$(which gnumake)" ]; then MAKE=$(which gnumake); fi
if [ -z "$MAKE" -a -x "$(which gmake)" ]; then MAKE=$(which gmake); fi
if [ -z "$MAKE" -a -x "$(which make)" ]; then MAKE=$(which make); fi
if [ -z "$MAKE" ]; then
  echo no make found
  exit 1
fi
echo use $MAKE as make
export MAKE


#---------------------------------------------------------------------------------
# Extract source packages
#---------------------------------------------------------------------------------

BUILDSCRIPTDIR=$(pwd)

echo "Extracting $BINUTILS"
tar -xjvf $SRCDIR/$BINUTILS

echo "Extracting $GCC_CORE"
tar -xjvf $SRCDIR/$GCC_CORE

echo "Extracting $GCC_GPP"
tar -xjvf $SRCDIR/$GCC_GPP

echo "Extracting $NEWLIB"
tar -xzvf $SRCDIR/$NEWLIB

if [ $VERSION -eq 2 ]
then
  echo "Extracting $LIBOGC"
  mkdir -p $LIBOGC_SRCDIR
  bzip2 -cd $SRCDIR/$LIBOGC | tar -xv -C $LIBOGC_SRCDIR
fi

if [ $VERSION -eq 1 ]
then
  echo "Extracting $LIBNDS"
  mkdir -p $LIBNDS_SRCDIR
  bzip2 -cd $SRCDIR/$LIBNDS | tar -xv -C $LIBNDS_SRCDIR
  echo "Extracting $LIBGBA"
  mkdir -p $LIBGBA_SRCDIR
  bzip2 -cd $SRCDIR/$LIBGBA | tar -xv -C $LIBGBA_SRCDIR
fi


#---------------------------------------------------------------------------------
# apply patches
#---------------------------------------------------------------------------------
patch -p1 -d $BINUTILS_SRCDIR -i $(pwd)/patches/devkit-binutils-2.15.patch
patch -p1 -d $GCC_SRCDIR -i $(pwd)/patches/devkit-gcc-3.4.3.patch
patch -p1 -d $NEWLIB_SRCDIR -i $(pwd)/patches/devkit-newlib-1.13.0.patch


#---------------------------------------------------------------------------------
# only necessary when Darwin gcc is 3.1 or earlier, to add a check for this here
#---------------------------------------------------------------------------------
#if test $(uname -s | grep Darwin)
#then
#  export CFLAGS = "-O2 -pipe -no-cpp-precomp -DHAVE_DESIGNATED_INITIALIZERS=0"
#  export LDFLAGS=''
#
#else

  export CFLAGS='-O2 -pipe'
  export LDFLAGS='-s'

#fi

export CXXFLAGS='-O2 -pipe'
export DEBUG_FLAGS=''

#---------------------------------------------------------------------------------
# Add installed devkit to the path, adjusting path on minsys
#---------------------------------------------------------------------------------
TOOLPATH=$(echo $INSTALLDIR | sed -e 's/^\([a-zA-Z]\):/\/\1/')
export PATH=$PATH:$TOOLPATH/$package/bin

#---------------------------------------------------------------------------------
# Build and install devkit components
#---------------------------------------------------------------------------------
if [ -f $scriptdir/build-gcc.sh ]; then . $scriptdir/build-gcc.sh ; cd $BUILDSCRIPTDIR; fi
if [ -f $scriptdir/build-crtls.sh ]; then . $scriptdir/build-crtls.sh ; cd $BUILDSCRIPTDIR; fi
if [ -f $scriptdir/build-tools.sh ]; then . $scriptdir/build-tools.sh ; cd $BUILDSCRIPTDIR; fi

strip $INSTALLDIR/$package/bin/*
strip $INSTALLDIR/$package/$target/bin/*
strip $INSTALLDIR/$package/libexec/gcc/$target/$GCC_VER/*
rm -fr $INSTALLDIR/$package/include/c++/$GCC_VER/$target/bits/stdc++.h.gch

#---------------------------------------------------------------------------------
# Clean up temporary files and source directories
#---------------------------------------------------------------------------------

echo "Removing patched sources and build directories"

rm -fr $target
rm -fr $BINUTILS_SRCDIR
rm -fr $NEWLIB_SRCDIR
rm -fr $GCC_SRCDIR
rm -fr $LIBOGC_SRCDIR $LIBGBA_SRCDIR $LIBNDS_SRCDIR

echo
echo "Would you like to delete the source packages? [y/N]"
read answer

if [ "$answer" = "y" -o "$answer" = "Y" ]
then
    echo "rm -f $BINUTILS $GCC_CORE $GCC_GPP $NEWLIB"
    rm -f $SRCDIR/$BINUTILS $SRCDIR/$GCC_CORE $SRCDIR/$GCC_GPP $SRCDIR/$NEWLIB
fi

echo
echo "note: Add the following to your PATH variable;  $INSTALLDIR/$package/bin"
echo
