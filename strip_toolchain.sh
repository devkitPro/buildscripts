#!/bin/bash

echo -n "Looking for configuration file... "
if [ -f ./config.sh ]; then
  echo "Found."
  . ./config.sh
else
  echo "Not found"
fi

if [ ! -z "$BUILD_DKPRO_PACKAGE" ] ; then
	VERSION="$BUILD_DKPRO_PACKAGE"
fi

. ./select_toolchain.sh

if [ ! -z "$BUILD_DKPRO_INSTALLDIR" ] ; then
	INSTALLDIR="$BUILD_DKPRO_INSTALLDIR"
elif [ ! -z "$DEVKITPRO" ]; then
	INSTALLDIR="$DEVKITPRO"
else
  echo "please set install dir in config.sh or set $DEVKITPRO"
fi

#---------------------------------------------------------------------------------
# Add installed devkit to the path, adjusting path on minsys
#---------------------------------------------------------------------------------
TOOLPATH=$(echo $INSTALLDIR | sed -e 's/^\([a-zA-Z]\):/\/\1/')
export PATH=$PATH:$TOOLPATH/$package/bin

. ./strip_bins.sh
