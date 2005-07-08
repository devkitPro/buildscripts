#!/bin/sh

#---------------------------------------------------------------------------------
# Install and build the pspsdk
#---------------------------------------------------------------------------------

echo "building pspsdk ..."
cd $PSPSDK_SRCDIR
./configure || { echo "Error configuring pspsdk"; exit 1; }
$MAKE || { echo "Error building pspsdk"; exit 1; } 
echo "installing pspsdk ..."
$MAKE install || { echo "Error installing pspsdk"; exit 1; }

cd $BUILDSCRIPTDIR


