#!/bin/sh
#---------------------------------------------------------------------------------
# Build scripts for
#	devkitARM release 23b
#	devkitPPC release 15
#	devkitPSP release 12
#---------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
# specify some urls to download the source packages from
#---------------------------------------------------------------------------------
LIBOGC_VER=20080601
LIBGBA_VER=20060720
LIBNDS_VER=20080511
DEFAULT_ARM7_VER=20080416
DSWIFI_VER=0.3.4
LIBMIRKO_VER=0.9.7

LIBOGC="libogc-src-$LIBOGC_VER.tar.bz2"
LIBGBA="libgba-src-$LIBGBA_VER.tar.bz2"
LIBNDS="libnds-src-$LIBNDS_VER.tar.bz2"
DSWIFI="dswifi-src-$DSWIFI_VER.tar.bz2"
DEFAULT_ARM7="default_arm7-src-$DEFAULT_ARM7_VER.tar.bz2"
LIBMIRKO="libmirko-src-$LIBMIRKO_VER.tar.bz2"
DEVKITPRO_URL="http://downloads.sourceforge.net/devkitpro"

LIBOGC_URL="$DEVKITPRO_URL/$LIBOGC"
LIBGBA_URL="$DEVKITPRO_URL/$LIBGBA"
LIBNDS_URL="$DEVKITPRO_URL/$LIBNDS"
DSWIFI_URL="$DEVKITPRO_URL/$DSWIFI"
LIBMIRKO_URL="$DEVKITPRO_URL/$LIBMIRKO"
DEFAULT_ARM7_URL="$DEVKITPRO_URL/$DEFAULT_ARM7"

#---------------------------------------------------------------------------------
# Sane defaults for building toolchain
#---------------------------------------------------------------------------------
export CFLAGS="-O2 -pipe"
export CXXFLAGS="$CFLAGS"
unset LDFLAGS

#---------------------------------------------------------------------------------
# Look for automated configuration file to bypass prompts
#---------------------------------------------------------------------------------
 
echo -n "Looking for configuration file... "
if [ -f ./config.sh ]; then
  echo "Found."
  . ./config.sh
else
  echo "Not found"
fi


#---------------------------------------------------------------------------------
# Ask whether to download the source packages or not
#---------------------------------------------------------------------------------

VERSION=0

if [ ! -z "$BUILD_DKPRO_PACKAGE" ] ; then
	VERSION="$BUILD_DKPRO_PACKAGE"
fi

while [ $VERSION -eq 0 ]
do
  echo
  echo "This script will build and install your devkit. Please select the one you require"
  echo
  echo "1: build devkitARM (gba gp32 ds)"
  echo "2: build devkitPPC (gamecube wii)"
  echo "3: build devkitPSP (PSP)"
  read VERSION

  if [ "$VERSION" -ne 1 -a "$VERSION" -ne 2 -a "$VERSION" -ne 3 ]
  then
      VERSION=0
  fi
done

case "$VERSION" in
  "1" )
    GCC_VER=4.3.0
    BINUTILS_VER=2.18.50
    NEWLIB_VER=1.16.0
    GDB_VER=6.8
    LIBFAT_VER=20070127
    basedir='dkarm-eabi'
    package=devkitARM
    builddir=arm-eabi
    target=arm-eabi
    toolchain=DEVKITARM
  ;;
  "2" )
    GCC_VER=4.2.3
    BINUTILS_VER=2.18.50
    NEWLIB_VER=1.16.0
    GDB_VER=6.8
    LIBFAT_VER=20080530
    basedir='dkppc'
    package=devkitPPC
    builddir=powerpc-gekko
    target=powerpc-gekko
    toolchain=DEVKITPPC
  ;;
  "3" )
    GCC_VER=4.1.2
    BINUTILS_VER=2.16.1
    NEWLIB_VER=1.15.0
    GDB_VER=6.7.1
    basedir='dkpsp'
    package=devkitPSP
    builddir=psp
    target=psp
    toolchain=DEVKITPSP

    if test "`svn help`"
    then
      SVN="svn"
    else
     echo "ERROR: Please make sure you have 'subversion (svn)' installed."
     exit 1
    fi
  ;;
esac

GCC_CORE="gcc-core-$GCC_VER.tar.bz2"
GCC_GPP="gcc-g++-$GCC_VER.tar.bz2"
GCC_CORE_URL="http://ftp.gnu.org/gnu/gcc/gcc-$GCC_VER/$GCC_CORE"
GCC_GPP_URL="http://ftp.gnu.org/gnu/gcc/gcc-$GCC_VER/$GCC_GPP"
BINUTILS="binutils-$BINUTILS_VER.tar.bz2"
GDB="gdb-$GDB_VER.tar.bz2"
GDB_URL="http://ftp.gnu.org/gnu/gdb/$GDB"

case "$BINUTILS_VER" in
 "2.18.50" )
   BINUTILS_URL="ftp://sourceware.org/pub/binutils/snapshots/$BINUTILS"
 ;;
 * )  
   BINUTILS_URL="http://ftp.gnu.org/gnu/binutils/$BINUTILS"
 ;;
esac

NEWLIB="newlib-$NEWLIB_VER.tar.gz"
NEWLIB_URL="ftp://sources.redhat.com/pub/newlib/$NEWLIB"
LIBFAT="libfat-src-$LIBFAT_VER.tar.bz2"
LIBFAT_URL="$DEVKITPRO_URL/$LIBFAT"

DOWNLOAD=0

if [ ! -z "$BUILD_DKPRO_DOWNLOAD" ] ; then
	DOWNLOAD="$BUILD_DKPRO_DOWNLOAD"
fi

while [ $DOWNLOAD -eq 0 ]
do
  echo
  echo "The installation requires binutils-$BINUTILS_VER, gcc-$GCC_VER and newlib-$NEWLIB_VER.  Please select an option:"
  echo
  echo "1: I have already downloaded the source packages"
  echo "2: Download the packages for me (requires wget)"
  read DOWNLOAD

  if [ "$DOWNLOAD" -ne 1 -a "$DOWNLOAD" -ne 2 ]
  then
      DOWNLOAD=0
  fi
done

if [ "$DOWNLOAD" -eq 2 ]
then
  if test "`wget -V`"
  then
    WGET=wget
  else
    echo "ERROR: Please make sure you have 'wget' installed."
    exit 1
  fi
fi


#---------------------------------------------------------------------------------
# Get preferred installation directory and set paths to the sources
#---------------------------------------------------------------------------------

if [ ! -z "$BUILD_DKPRO_INSTALLDIR" ] ; then
	INSTALLDIR="$BUILD_DKPRO_INSTALLDIR"
else
	echo
	echo "Please enter the directory where you would like '$package' to be installed:"
	echo "for mingw/msys you must use <drive>:/<install path> or you will have include path problems"
	echo "this is the top level directory for devkitpro, i.e. e:/devkitPro"
	
	read INSTALLDIR
	echo
fi

[ ! -z "$INSTALLDIR" ] && mkdir -p $INSTALLDIR && touch $INSTALLDIR/nonexistantfile && rm $INSTALLDIR/nonexistantfile || exit 1;

if [ $DOWNLOAD -eq 1 ]
then
    FOUND=0
    while [ $FOUND -eq 0 ]
	  do
	  if [ ! -z "$BUILD_DKPRO_SRCDIR" ] ; then
		  SRCDIR="$BUILD_DKPRO_SRCDIR"
	  else
		  echo
		  echo "Please enter the path to the directory that contains the source packages:"
		  read SRCDIR
	  fi

      if [ ! -f $SRCDIR/$BINUTILS ]
      then
	  echo "Error: $BINUTILS not found in $SRCDIR"
	  exit 1
      else
	  FOUND=1
      fi

      if [ ! -f $SRCDIR/$GCC_GPP ]
      then
    	  echo "Error: $GCC_GPP not found in $SRCDIR"
	      exit 1
      else
	      FOUND=1
      fi

      if [ ! -f $SRCDIR/$GCC_CORE ]
      then
    	  echo "Error: $GCC_CORE not found in $SRCDIR"
	      exit 1
      else
	      FOUND=1
      fi

      if [ ! -f $SRCDIR/$NEWLIB ]
      then
	  echo "Error: $NEWLIB not found in $SRCDIR"
	  exit 1
      else
	  FOUND=1
      fi

      if [ ! -f $SRCDIR/$GDB ]
      then
        echo "Error: $GDB not found in $SRCDIR"
	    exit 1
      else
        FOUND=1
      fi

      if [ $VERSION -eq 1 ]
      then
        if [ ! -f $SRCDIR/$LIBGBA ]
        then
          echo "Error: $LIBGBA not found in $SRCDIR"
          exit 1
        else
          FOUND=1
        fi
        if [ ! -f $SRCDIR/$LIBNDS ]
        then
          echo "Error: $LIBNDS not found in $SRCDIR"
	        exit 1
        else
	        FOUND=1
        fi
        if [ ! -f $SRCDIR/$DSWIFI ]
        then
          echo "Error: $DSWIFI not found in $SRCDIR"
	        exit 1
        else
	        FOUND=1
        fi
        if [ ! -f $SRCDIR/$LIBMIRKO ]
        then
          echo "Error: $LIBMIRKO not found in $SRCDIR"
	        exit 1
        else
	        FOUND=1
        fi
        if [ ! -f $SRCDIR/$DEFAULT_ARM7 ]
        then
          echo "Error: $DEFAULT_ARM7 not found in $SRCDIR"
	        exit 1
        else
	        FOUND=1
        fi
      fi

    if [ $VERSION -eq 2 ]
    then
      if [ ! -f $SRCDIR/$LIBOGC ]
      then
        echo "Error: $LIBOGC not found in $SRCDIR"
	      exit 1
      else
	      FOUND=1
      fi
    fi


    if [ $VERSION -eq 1 -o $VERSION -eq 2 ]
    then
      if [ ! -f $SRCDIR/$LIBFAT ]
      then
        echo "Error: $LIBFAT not found in $SRCDIR"
        exit 1
      else
	      FOUND=1
      fi
    fi



    done

else

    if [ ! -f downloaded_sources ]
    then
      $WGET --passive-ftp -c $BINUTILS_URL || { echo "Error: Failed to download "$BINUTILS; exit 1; }

      $WGET -c $GCC_CORE_URL || { echo "Error: Failed to download "$GCC_CORE; exit 1; }

      $WGET -c $GCC_GPP_URL || { echo "Error: Failed to download "$GCC_GPP; exit 1; }

      $WGET -c $GDB_URL || { echo "Error: Failed to download "$GDB; exit 1; }

      $WGET --passive-ftp -c $NEWLIB_URL || { echo "Error: Failed to download "$NEWLIB; exit 1; }

      if [ $VERSION -eq 2 ]
      then
       $WGET -c $LIBOGC_URL || { echo "Error: Failed to download "$LIBOGC; exit 1; }
      fi

      if [ $VERSION -eq 1 -o $VERSION -eq 2 ]
      then
        $WGET -c $LIBFAT_URL || { echo "Error: Failed to download "$LIBFAT; exit 1; }
      fi

      if [ $VERSION -eq 1 ]
      then
        $WGET -c $LIBNDS_URL || { echo "Error: Failed to download "$LIBNDS; exit 1; }
        $WGET -c $LIBGBA_URL || { echo "Error: Failed to download "$LIBGBA; exit 1; }
        $WGET -c $DSWIFI_URL || { echo "Error: Failed to download "$DSWIFI; exit 1; }
        $WGET -c $LIBMIRKO_URL || { echo "Error: Failed to download "$LIBMIRKO; exit 1; }
        $WGET -c $DEFAULT_ARM7_URL || { echo "Error: Failed to download "$DEFAULT_ARM7; exit 1; }
      fi
      SRCDIR=`pwd`
      touch downloaded_sources
    fi
fi

BINUTILS_SRCDIR="binutils-$BINUTILS_VER"
GCC_SRCDIR="gcc-$GCC_VER"
GDB_SRCDIR="gdb-$GDB_VER"
NEWLIB_SRCDIR="newlib-$NEWLIB_VER"
LIBOGC_SRCDIR="libogc-$LIBOGC_VER"
LIBGBA_SRCDIR="libgba-$LIBGBA_VER"
LIBFAT_SRCDIR="libfat-$LIBFAT_VER"
DSWIFI_SRCDIR="dswifi-$DSWIFI_VER"
LIBNDS_SRCDIR="libnds-$LIBNDS_VER"
LIBMIRKO_SRCDIR="libmirko-$LIBMIRKO_VER"
DEFAULT_ARM7_SRCDIR="default_arm7-$DEFAULT_ARM7_VER"


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
# find proper gawk
#---------------------------------------------------------------------------------
if [ -z "$GAWK" -a -x "$(which gawk)" ]; then GAWK=$(which gawk); fi
if [ -z "$GAWK" -a -x "$(which awk)" ]; then GAWK=$(which awk); fi
if [ -z "$GAWK" ]; then
  echo no awk found
  exit 1
fi
echo use $GAWK as gawk
export GAWK

#---------------------------------------------------------------------------------
# find makeinfo, needed for newlib
#---------------------------------------------------------------------------------
if [ ! -x $(which makeinfo) ]; then
  echo makeinfo not found
  exit 1
fi

#---------------------------------------------------------------------------------
# Add installed devkit to the path, adjusting path on minsys
#---------------------------------------------------------------------------------
TOOLPATH=$(echo $INSTALLDIR | sed -e 's/^\([a-zA-Z]\):/\/\1/')
export PATH=$PATH:$TOOLPATH/$package/bin

if [ "$BUILD_DKPRO_AUTOMATED" != "1" ] ; then
	
	echo
	echo 'Ready to install '$package' in '$INSTALLDIR
	echo
	echo 'press return to continue'
	
	read dummy
fi

patchdir=$(pwd)/$basedir/patches
scriptdir=$(pwd)/$basedir/scripts

#---------------------------------------------------------------------------------
# Extract source packages
#---------------------------------------------------------------------------------

BUILDSCRIPTDIR=$(pwd)

if [ ! -f extracted_archives ]
then
  echo "Extracting $BINUTILS"
  tar -xjf $SRCDIR/$BINUTILS || { echo "Error extracting "$BINUTILS; exit 1; }

  echo "Extracting $GCC_CORE"
  tar -xjf $SRCDIR/$GCC_CORE || { echo "Error extracting "$GCC_CORE; exit 1; }

  echo "Extracting $GCC_GPP"
  tar -xjf $SRCDIR/$GCC_GPP || { echo "Error extracting "$GCC_GPP; exit 1; }

  echo "Extracting $NEWLIB"
  tar -xzf $SRCDIR/$NEWLIB || { echo "Error extracting "$NEWLIB; exit 1; }

  echo "Extracting $GDB"
  tar -xjf $SRCDIR/$GDB || { echo "Error extracting "$GCC_GPP; exit 1; }

  if [ $VERSION -eq 2 ]
  then
    echo "Extracting $LIBOGC"
    mkdir -p $LIBOGC_SRCDIR
    bzip2 -cd $SRCDIR/$LIBOGC | tar -xf - -C $LIBOGC_SRCDIR  || { echo "Error extracting "$LIBOGC; exit 1; }
  fi

  if [ $VERSION -eq 1 ]
  then
    echo "Extracting $LIBNDS"
    mkdir -p $LIBNDS_SRCDIR
    bzip2 -cd $SRCDIR/$LIBNDS | tar -xf - -C $LIBNDS_SRCDIR  || { echo "Error extracting "$LIBNDS; exit 1; }

    echo "Extracting $LIBGBA"
    mkdir -p $LIBGBA_SRCDIR
    bzip2 -cd $SRCDIR/$LIBGBA | tar -xf - -C $LIBGBA_SRCDIR || { echo "Error extracting "$LIBGBA; exit 1; }


    echo "Extracting $LIBFAT"
    mkdir -p $LIBFAT_SRCDIR
    bzip2 -cd $SRCDIR/$LIBFAT | tar -xf - -C $LIBFAT_SRCDIR || { echo "Error extracting "$LIBFAT; exit 1; }

    echo "Extracting $DSWIFI"
    mkdir -p $DSWIFI_SRCDIR
    bzip2 -cd $SRCDIR/$DSWIFI | tar -xf - -C $DSWIFI_SRCDIR || { echo "Error extracting "$DSWIFI; exit 1; }

    echo "Extracting $LIBMIRKO"
    mkdir -p $LIBMIRKO_SRCDIR
    bzip2 -cd $SRCDIR/$LIBMIRKO | tar -xf - -C $LIBMIRKO_SRCDIR || { echo "Error extracting "$LIBMIRKO; exit 1; }

    echo "Extracting $DEFAULT_ARM7"
    mkdir -p $DEFAULT_ARM7_SRCDIR
    bzip2 -cd $SRCDIR/$DEFAULT_ARM7 | tar -xf - -C $DEFAULT_ARM7_SRCDIR || { echo "Error extracting "$DEFAULT_ARM7; exit 1; }

  fi

  touch extracted_archives

fi

#---------------------------------------------------------------------------------
# apply patches
#---------------------------------------------------------------------------------
if [ ! -f patched_sources ]
then

  if [ -f $patchdir/binutils-$BINUTILS_VER.patch ]
  then
    patch -p1 -d $BINUTILS_SRCDIR -i $patchdir/binutils-$BINUTILS_VER.patch || { echo "Error patching binutils"; exit 1; }
  fi

  if [ -f $patchdir/gcc-$GCC_VER.patch ]
  then
    patch -p1 -d $GCC_SRCDIR -i $patchdir/gcc-$GCC_VER.patch || { echo "Error patching gcc"; exit 1; }
  fi

  if [ -f $patchdir/newlib-$NEWLIB_VER.patch ]
  then
    patch -p1 -d $NEWLIB_SRCDIR -i $patchdir/newlib-$NEWLIB_VER.patch || { echo "Error patching newlib"; exit 1; }
  fi

  if [ -f $patchdir/gdb-$GDB_VER.patch ]
  then
    patch -p1 -d $GDB_SRCDIR -i $patchdir/gdb-$GDB_VER.patch || { echo "Error patching gdb"; exit 1; }
  fi

  touch patched_sources
fi

#---------------------------------------------------------------------------------
# Build and install devkit components
#---------------------------------------------------------------------------------
if [ -f $scriptdir/build-gcc.sh ]; then . $scriptdir/build-gcc.sh || { echo "Error building toolchain"; exit 1; }; cd $BUILDSCRIPTDIR; fi
if [ -f $scriptdir/build-crtls.sh ]; then . $scriptdir/build-crtls.sh || { echo "Error building crtls"; exit 1; }; cd $BUILDSCRIPTDIR; fi
if [ -f $scriptdir/build-tools.sh ]; then . $scriptdir/build-tools.sh || { echo "Error building tools"; exit 1; }; cd $BUILDSCRIPTDIR; fi

#---------------------------------------------------------------------------------
# strip binaries
# strip has trouble using wildcards so do it this way instead
#---------------------------------------------------------------------------------
for f in $INSTALLDIR/$package/bin/* \
         $INSTALLDIR/$package/$target/bin/* \
         $INSTALLDIR/$package/libexec/gcc/$target/$GCC_VER/*
do
  # exclude dll for windows, directories & the gccbug text file
  if  ! [[ "$f" == *.dll || -d $f || "$f" == *-gccbug ]] 
  then
    strip $f
  fi
done

#---------------------------------------------------------------------------------
# strip debug info from libraries
#---------------------------------------------------------------------------------
find $INSTALLDIR/$package/lib/gcc/$target -name *.a -exec $target-strip -d {} \;
find $INSTALLDIR/$package/$target -name *.a -exec $target-strip -d {} \;

#---------------------------------------------------------------------------------
# Clean up temporary files and source directories
#---------------------------------------------------------------------------------

if [ "$BUILD_DKPRO_AUTOMATED" != "1" ] ; then
	
	echo
	echo "Would you like to delete the build folders and patched sources? [Y/n]"
	read answer
	
	if [ "$answer" != "n" -a "$answer" != "N" ]
	then
	echo "Removing patched sources and build directories"
	
	rm -fr $target
	rm -fr $BINUTILS_SRCDIR
	rm -fr $NEWLIB_SRCDIR
	rm -fr $GCC_SRCDIR
	
	rm -fr $LIBOGC_SRCDIR $LIBGBA_SRCDIR $LIBNDS_SRCDIR $LIBMIRKO_SRCDIR $DSWIFI_SRCDIR $LIBFAT_SRCDIR $GDB_SRCDIR $DEFAULT_ARM7_SRCDIR
	rm -fr mn10200
	rm -fr pspsdk
	rm -fr extracted_archives patched_sources checkout-psp-sdk
	
	fi
fi

if [ "$BUILD_DKPRO_AUTOMATED" != "1" ] ; then
	echo
	echo "Would you like to delete the downloaded source packages? [y/N]"
	read answer
	
	if [ "$answer" = "y" -o "$answer" = "Y" ]
	then
		echo "removing archives"
		rm -f $SRCDIR/$BINUTILS $SRCDIR/$GCC_CORE $SRCDIR/$GCC_GPP $SRCDIR/$NEWLIB
		if [ $VERSION -eq 1 -o $VERSION -eq 4 ]
		then
		rm -f  $SRCDIR/$LIBGBA $SRCDIR/$LIBNDS $SRCDIR/$LIBMIRKO
		fi
		if [ $VERSION -eq 2 ]
		then
		rm -f  $SRCDIR/$LIBOGC
		fi
	fi
fi

echo
echo "note: Add the following to your environment;  DEVKITPRO=$TOOLPATH $toolchain=$TOOLPATH/$package"
echo
