#!/bin/bash
#---------------------------------------------------------------------------------
#	devkitARM release 53-1
#	devkitPPC release 35
#	devkitA64 release 14
#---------------------------------------------------------------------------------

if [ 0 -eq 1 ] ; then
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
echo "Users should use devkitPro pacman to maintain toolchain installations where possible"
echo "See https://devkitpro.org/wiki/devkitPro_pacman"
echo
echo "Patches and improvements are of course welcome, please submit a PR"
echo "https://github.com/devkitPro/buildscripts/pulls"
echo



DKARM_RULES_VER=1.0.0
DKARM_CRTLS_VER=1.0.0

DKPPC_RULES_VER=1.0.0

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

CROSS_PARAMS="--build=`./config.guess`"

if [ ! -z $CROSSBUILD ]; then
	toolsprefix=$INSTALLDIR/$CROSSBUILD/tools
	prefix=$INSTALLDIR/$CROSSBUILD/$package
	toolsprefix=$INSTALLDIR/$CROSSBUILD/tools
	CROSS_PARAMS="$CROSS_PARAMS --host=$CROSSBUILD"
	CROSS_GCC_PARAMS="--with-gmp=$CROSSPATH --with-mpfr=$CROSSPATH --with-mpc=$CROSSPATH"
else
	toolsprefix=$INSTALLDIR/tools
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
		cppflags="-mmacosx-version-min=${OSXMIN} -I/usr/local/include"
		ldflags="-mmacosx-version-min=${OSXMIN} -L/usr/local/lib"
		if [ "x${OSXSDKPATH}x" != "xx" ]; then
			cppflags="$cppflags -isysroot ${OSXSDKPATH}"
			ldflags="$ldflags -Wl,-syslibroot,${OSXSDKPATH}"
		fi
		TESTCC=`cc -v 2>&1 | grep clang`
		if [ "x${TESTCC}x" != "xx" ]; then
			cppflags="$cppflags -fbracket-depth=512"
		fi
    ;;
	MINGW32* )
		cppflags="-D__USE_MINGW_ACCESS"
    ;;
esac

if [ ! -z $CROSSBUILD ] && grep -q "mingw" <<<"$CROSSBUILD" ; then
	cppflags="-D__USE_MINGW_ACCESS -D__USE_MINGW_ANSI_STDIO=1"
fi


BUILDSCRIPTDIR=$(pwd)
BUILDDIR=$(pwd)/.$package

if [ ! -z $CROSSBUILD ]; then
	BUILDDIR=$BUILDDIR-$CROSSBUILD
fi

patchdir=$(pwd)/$basedir/patches
scriptdir=$(pwd)/$basedir/scripts

archives="binutils-${BINUTILS_VER}.tar.xz gcc-${GCC_VER}.tar.xz newlib-${NEWLIB_VER}.tar.gz gdb-${GDB_VER}.tar.xz"

if [ $VERSION -eq 1 ]; then

	archives="devkitarm-rules-$DKARM_RULES_VER.tar.xz devkitarm-crtls-$DKARM_CRTLS_VER.tar.xz $archives"
fi

if [ $VERSION -eq 2 ]; then

	archives="binutils-${MN_BINUTILS_VER}.tar.bz2 devkitppc-rules-$DKPPC_RULES_VER.tar.xz $archives"
fi



if [ ! -z "$BUILD_DKPRO_SRCDIR" ] ; then
	SRCDIR="$BUILD_DKPRO_SRCDIR"
else
	SRCDIR=`pwd`
fi

cd "$SRCDIR"
for archive in $archives
do
	echo $archive
	if [ ! -f $archive ]; then
		$FETCH https://downloads.devkitpro.org/$archive || { echo "Error: Failed to download $archive"; exit 1; }
	fi
done

cd $BUILDSCRIPTDIR
mkdir -p $BUILDDIR
cd $BUILDDIR

extract_and_patch binutils $BINUTILS_VER xz
extract_and_patch gcc $GCC_VER xz
extract_and_patch newlib $NEWLIB_VER gz
extract_and_patch gdb $GDB_VER xz

if [ $VERSION -eq 2 ]; then
	extract_and_patch binutils $MN_BINUTILS_VER bz2
fi

#---------------------------------------------------------------------------------
# Build and install devkit components
#---------------------------------------------------------------------------------
if [ -f $scriptdir/build-gcc.sh ]; then . $scriptdir/build-gcc.sh || { echo "Error building toolchain"; exit 1; }; cd $BUILDSCRIPTDIR; fi

cd $BUILDSCRIPTDIR

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
