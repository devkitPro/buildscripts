#!/bin/bash
#---------------------------------------------------------------------------------
#	devkitARM release 48
#	devkitPPC release 30
#	devkitA64 release 9
#---------------------------------------------------------------------------------

if [ 1 -eq 0 ] ; then
	echo "Please use the latest release buildscripts unless advised otherwise by devkitPro staff."
	echo "https://github.com/devkitPro/buildscripts/releases/latest"
	echo
	echo "The scripts in the git repository may be dependent on things which currently only exist"
	echo "on developer machines. This is not a bug, use stable releases."
	exit 1
fi

echo "Please note, these scripts are provided as a courtesy, toolchains built with them"
echo "are for personal use only and may not be distributed by entities other than devkitPro."
echo "See http://devkitpro.org/wiki/Trademarks"
echo
echo "Patches and improvements are of course welcome, please submit a PR"
echo "https://github.com/devkitPro/buildscripts/pulls"
echo


GENERAL_TOOLS_VER=1.0.2

LIBGBA_VER=0.5.1
GBATOOLS_VER=1.1.0

LIBNDS_VER=1.7.2
DEFAULT_ARM7_VER=0.7.4
DSWIFI_VER=0.4.2
MAXMOD_VER=1.0.11
FILESYSTEM_VER=0.9.14
LIBFAT_VER=1.1.3
DSTOOLS_VER=1.2.1
GRIT_VER=0.8.15
NDSTOOL_VER=2.1.1
MMUTIL_VER=1.8.7

DFU_UTIL_VER=0.9.1
STLINK_VER=1.2.3

GAMECUBE_TOOLS_VER=1.0.2
LIBOGC_VER=1.8.17
WIILOAD_VER=0.5.1

LIBCTRU_VER=1.5.0
CITRO3D_VER=1.4.0
CITRO2D_VER=1.0.0
TOOLS3DS_VER=1.1.4
LINK3DS_VER=0.5.2
PICASSO_VER=2.7.0
TEX3DS_VER=1.0.0

GP32_TOOLS_VER=1.0.3
LIBMIRKO_VER=0.9.8

SWITCH_TOOLS_VER=1.4.0
LIBNX_VER=1.2.1

OSXMIN=${OSXMIN:-10.9}

#---------------------------------------------------------------------------------
function extract_and_patch {
#---------------------------------------------------------------------------------
	if [ ! -f extracted-$1-$2 ]; then
		echo "extracting $1-$2"
		tar -xf "$SRCDIR/$1-$2.tar.$3" || { echo "Error extracting "$1; exit 1; }
		touch extracted-$1-$2
	fi
	if [[ ! -f patched-$1-$2 && -f $patchdir/$1-$2.patch ]]; then
		echo "patching $1-$2"
		patch -p1 -d $1-$2 -i $patchdir/$1-$2.patch || { echo "Error patching $1"; exit 1; }
		touch patched-$1-$2
	fi
}

if [ ! -z "$CROSSBUILD" ] ; then
	if [ ! -x $(which $CROSSBUILD-gcc) ]; then
		echo "error $CROSSBUILD-gcc not in PATH"
		exit 1
	fi
fi

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
. ./select_toolchain.sh

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

	read -e INSTALLDIR
	echo
fi

[ ! -z "$INSTALLDIR" ] && mkdir -p $INSTALLDIR && touch $INSTALLDIR/nonexistantfile && rm $INSTALLDIR/nonexistantfile || exit 1;

if test "`curl -V`"; then
	FETCH="curl -f -L -O"
elif test "`wget -V`"; then
	FETCH=wget
else
	echo "ERROR: Please make sure you have wget or curl installed."
	exit 1
fi


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
# Add installed devkit to the path, adjusting path on minsys
#---------------------------------------------------------------------------------
TOOLPATH=$(echo $INSTALLDIR | sed -e 's/^\([a-zA-Z]\):/\/\1/')
export PATH=$PATH:$TOOLPATH/$package/bin

if [ ! -z $CROSSBUILD ]; then
	prefix=$INSTALLDIR/$CROSSBUILD/$package
	CROSS_PARAMS="--build=`./config.guess` --host=$CROSSBUILD"
	CROSS_GCC_PARAMS="--with-gmp=$CROSSPATH --with-mpfr=$CROSSPATH --with-mpc=$CROSSPATH"
else
	prefix=$INSTALLDIR/$package
fi

if [ "$BUILD_DKPRO_AUTOMATED" != "1" ] ; then

	echo
	echo 'Ready to install '$package' in '$prefix
	echo
	echo 'press return to continue'

	read dummy
fi
PLATFORM=`uname -s`

case $PLATFORM in
	Darwin )
		cflags="-mmacosx-version-min=${OSXMIN} -I/usr/local/include"
		ldflags="-mmacosx-version-min=${OSXMIN} -L/usr/local/lib"
		if [ "x${OSXSDKPATH}x" != "xx" ]; then
			cflags="$cflags -isysroot ${OSXSDKPATH}"
			ldflags="$ldflags -Wl,-syslibroot,${OSXSDKPATH}"
		fi
		TESTCC=`cc -v 2>&1 | grep clang`
		if [ "x${TESTCC}x" != "xx" ]; then
			cflags="$cflags -fbracket-depth=512"
		fi
    ;;
	MINGW32* )
		cflags="-D__USE_MINGW_ACCESS"
    ;;
esac


BUILDSCRIPTDIR=$(pwd)
BUILDDIR=$(pwd)/.$package

if [ ! -z $CROSSBUILD ]; then
	BUILDDIR=$BUILDDIR-$CROSSBUILD
fi

patchdir=$(pwd)/$basedir/patches
scriptdir=$(pwd)/$basedir/scripts

archives="binutils-${BINUTILS_VER}.tar.bz2 gcc-${GCC_VER}.tar.xz newlib-${NEWLIB_VER}.tar.gz gdb-${GDB_VER}.tar.xz"

if [ $VERSION -eq 1 ]; then

	targetarchives="libnds-src-${LIBNDS_VER}.tar.bz2 libgba-src-${LIBGBA_VER}.tar.bz2
		libmirko-src-${LIBMIRKO_VER}.tar.bz2 dswifi-src-${DSWIFI_VER}.tar.bz2 maxmod-src-${MAXMOD_VER}.tar.bz2
		default-arm7-src-${DEFAULT_ARM7_VER}.tar.bz2 libfilesystem-src-${FILESYSTEM_VER}.tar.bz2
		libfat-src-${LIBFAT_VER}.tar.bz2 libctru-src-${LIBCTRU_VER}.tar.bz2  citro3d-src-${CITRO3D_VER}.tar.bz2
		citro2d-src-${CITRO2D_VER}.tar.bz2"

	hostarchives="gba-tools-$GBATOOLS_VER.tar.bz2 gp32-tools-$GP32_TOOLS_VER.tar.bz2
		dstools-$DSTOOLS_VER.tar.bz2 grit-$GRIT_VER.tar.bz2 ndstool-$NDSTOOL_VER.tar.bz2
		general-tools-$GENERAL_TOOLS_VER.tar.bz2 mmutil-$MMUTIL_VER.tar.bz2
		dfu-util-$DFU_UTIL_VER.tar.bz2 stlink-$STLINK_VER.tar.bz2 3dstools-$TOOLS3DS_VER.tar.bz2
		picasso-$PICASSO_VER.tar.bz2 tex3ds-$TEX3DS_VER.tar.bz2 3dslink-$LINK3DS_VER.tar.bz2"
fi

if [ $VERSION -eq 2 ]; then

	targetarchives="libogc-src-${LIBOGC_VER}.tar.bz2 libfat-src-${LIBFAT_VER}.tar.bz2"

	hostarchives="gamecube-tools-$GAMECUBE_TOOLS_VER.tar.bz2 wiiload-$WIILOAD_VER.tar.bz2 general-tools-$GENERAL_TOOLS_VER.tar.bz2"

	archives="binutils-${MN_BINUTILS_VER}.tar.bz2 $archives"
fi

if [ $VERSION -eq 3 ]; then

	targetarchives=" libnx-src-${LIBNX_VER}.tar.bz2"

	hostarchives="general-tools-$GENERAL_TOOLS_VER.tar.bz2 switch-tools-$SWITCH_TOOLS_VER.tar.bz2"

fi


if [ ! -z "$BUILD_DKPRO_SRCDIR" ] ; then
	SRCDIR="$BUILD_DKPRO_SRCDIR"
else
	SRCDIR=`pwd`
fi

cd "$SRCDIR"
for archive in $archives $targetarchives $hostarchives
do
	echo $archive
	if [ ! -f $archive ]; then
		$FETCH https://downloads.devkitpro.org/$archive || { echo "Error: Failed to download $archive"; exit 1; }
	fi
done

cd $BUILDSCRIPTDIR
mkdir -p $BUILDDIR
cd $BUILDDIR

extract_and_patch binutils $BINUTILS_VER bz2
extract_and_patch gcc $GCC_VER xz
extract_and_patch newlib $NEWLIB_VER gz
extract_and_patch gdb $GDB_VER xz

if [ $VERSION -eq 2 ]; then
	extract_and_patch binutils $MN_BINUTILS_VER bz2
fi

for archive in $targetarchives
do
	destdir=$(echo $archive | sed -e 's/\(.*\)-src-\(.*\)\.tar\.bz2/\1-\2/' )
	echo $destdir
	if [ ! -d $destdir ]; then
		mkdir -p $destdir
		bzip2 -cd "$SRCDIR/$archive" | tar -xf - -C $destdir || { echo "Error extracting "$archive; exit 1; }
	fi
done

for archive in $hostarchives
do
	destdir=$(echo $archive | sed -e 's/\(.*\)-src-\(.*\)\.tar\.bz2/\1-\2/' )
	if [ ! -d $destdir ]; then
		tar -xjf "$SRCDIR/$archive"
	fi
done

#---------------------------------------------------------------------------------
# Build and install devkit components
#---------------------------------------------------------------------------------
if [ -f $scriptdir/build-gcc.sh ]; then . $scriptdir/build-gcc.sh || { echo "Error building toolchain"; exit 1; }; cd $BUILDSCRIPTDIR; fi

if [ "$BUILD_DKPRO_SKIP_TOOLS" != "1" ] && [ -f $scriptdir/build-tools.sh ]; then
 . $scriptdir/build-tools.sh || { echo "Error building tools"; exit 1; }; cd $BUILDSCRIPTDIR;
fi

if [ "$BUILD_DKPRO_SKIP_LIBRARIES" != "1" ] && [ -f $scriptdir/build-libs.sh ]; then
  . $scriptdir/build-libs.sh || { echo "Error building libraries"; exit 1; }; cd $BUILDSCRIPTDIR;
fi

if [ ! -z $CROSSBUILD ] && grep -q "mingw" <<<"$CROSSBUILD" ; then
	cp -v	$CROSSBINPATH//libwinpthread-1.dll $prefix/bin
fi

echo "stripping installed binaries"
. ./strip_bins.sh

#---------------------------------------------------------------------------------
# Clean up temporary files and source directories
#---------------------------------------------------------------------------------

cd $BUILDSCRIPTDIR

if [ "$BUILD_DKPRO_AUTOMATED" != "1" ] ; then
	echo
	echo "Would you like to delete the build folders and patched sources? [Y/n]"
	read answer
else
	answer=y
fi

if [ "$answer" != "n" -a "$answer" != "N" ]; then

	echo "Removing patched sources and build directories"
	rm -fr $BUILDDIR
fi


echo
echo "note: Add the following to your environment;"
echo
echo "  DEVKITPRO=$TOOLPATH"
if [ "$toolchain" != "DEVKITA64" ]; then
echo "  $toolchain=$TOOLPATH/$package"
fi
echo
echo "add $TOOLPATH/tools/bin to your PATH"
echo
echo
