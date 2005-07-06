#!/bin/sh

#---------------------------------------------------------------------------------
# Install and build the pspsdk
#---------------------------------------------------------------------------------

echo "building pspsdk ..."
cd $PSPSDK_SRCDIR
./configure
$MAKE
echo "installing pspsdk ..."
$MAKE install

cd $BUILDSCRIPTDIR


