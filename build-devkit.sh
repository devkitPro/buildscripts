#!/usr/bin/env bash
#---------------------------------------------------------------------------------
#	devkitARM release 65
#	devkitPPC release 46
#	devkitA64 release 27
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



DKARM_RULES_VER=1.5.1
DKARM_CRTLS_VER=1.2.5

DKPPC_RULES_VER=1.2.1

DKA64_RULES_VER=1.1.1

OSXMIN=${OSXMIN:-10.9}

#---------------------------------------------------------------------------------
# find proper patch
#---------------------------------------------------------------------------------
if [ -z "$PATCH" -a -x "$(which gpatch)" ]; then PATCH=$(which gpatch); fi
if [ -z "$PATCH" -a -x "$(which patch)" ]; then PATCH=$(which patch); fi
if [ -z "$PATCH" ]; then
  echo no patch found
  exit 1
fi
echo use $PATCH as patch
export PATCH

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
		$PATCH -p1 -d $1-$2 -i $patchdir/$1-$2.patch || { echo "Error patching $1"; exit 1; }
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
# Legacy versions of these scripts allowed the selection of a prefix which is
# no longer supported. Since adopting pacman and providing precompiled binaries
# of "portlibs" everything we distribute is intended to work within opt/devkitpro
#
# Rather than attempting to repackage our work for exotic linux distributions it
# would be much better for everyone concerned if efforts were made to provide
# pacman and whatever support is necessary to allow the binaries we distribute to
# work as expected.
#
# See https://github.com/devkitPro/pacman and https://devkitpro.org/wiki/devkitPro_pacman
#---------------------------------------------------------------------------------
INSTALLDIR=/opt/devkitpro

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

CROSS_PARAMS="--build=`./config.guess`"

if [ ! -z $CROSSBUILD ]; then
	export PATH=/opt/devkitpro/$package/bin:$PATH
	prefix=$INSTALLDIR/$CROSSBUILD/$package
	CROSS_PARAMS="$CROSS_PARAMS --host=$CROSSBUILD"
	CROSS_GCC_PARAMS="--with-gmp=$CROSSPATH --with-mpfr=$CROSSPATH --with-mpc=$CROSSPATH --with-isl=$CROSSPATH --with-zstd=$CROSSPATH"
else
	prefix=$INSTALLDIR/$package
fi

#---------------------------------------------------------------------------------
# Add installed devkit to the path, adjusting path on minsys
#---------------------------------------------------------------------------------
TOOLPATH=$(echo $INSTALLDIR | sed -e 's/^\([a-zA-Z]\):/\/\1/')
export PATH=$TOOLPATH/$package/bin:$PATH

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
		cppflags="-D__USE_MINGW_ACCESS -D__USE_MINGW_ANSI_STDIO=1"
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

archives="binutils-${BINUTILS_VER}.tar.xz gcc-${GCC_VER}.tar.xz newlib-${NEWLIB_VER}.tar.gz"

if [ $VERSION -eq 2 ]; then
	archives="binutils-${MN_BINUTILS_VER}.tar.bz2 $archives"
fi

if [ "$BUILD_DKPRO_SKIP_CRTLS" != "1" ]; then
	if [ $VERSION -eq 1 ]; then
		archives="devkitarm-rules-$DKARM_RULES_VER.tar.gz devkitarm-crtls-$DKARM_CRTLS_VER.tar.gz $archives"
	fi

	if [ $VERSION -eq 2 ]; then
		archives="devkitppc-rules-$DKPPC_RULES_VER.tar.gz $archives"
	fi

	if [ $VERSION -eq 3 ]; then
		archives="devkita64-rules-$DKA64_RULES_VER.tar.gz $archives"
	fi
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

if [ $VERSION -eq 2 ]; then extract_and_patch binutils $MN_BINUTILS_VER bz2; fi

#---------------------------------------------------------------------------------
# Build and install devkit components
#---------------------------------------------------------------------------------
if [ -f $scriptdir/build-gcc.sh ]; then . $scriptdir/build-gcc.sh || { echo "Error building toolchain"; exit 1; }; cd $BUILDSCRIPTDIR; fi


if [ "$BUILD_DKPRO_SKIP_CRTLS" != "1" ] && [ -f $scriptdir/build-crtls.sh ]; then
  . $scriptdir/build-crtls.sh || { echo "Error building crtls & rules"; exit 1; }; cd $BUILDSCRIPTDIR;
fi

cd $BUILDSCRIPTDIR

if [ "$BUILD_DKPRO_NO_STRIP_BINARIES" != "1" ]; then
	echo "stripping installed binaries"
	. ./strip_bins.sh
fi

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
