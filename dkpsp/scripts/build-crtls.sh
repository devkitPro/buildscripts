#!/bin/sh

#---------------------------------------------------------------------------------
# Install and build the pspsdk
#---------------------------------------------------------------------------------

echo "building pspsdk ..."
cd pspsdk

./configure || { echo "ERROR RUNNING PSPSDK CONFIGURE"; exit 1; }

$MAKE || { echo "ERROR BUILDING PSPSDK"; exit 1; }

$MAKE install || { echo "ERROR INSTALLING PSPSDK"; exit 1; }

cd $BUILDSCRIPTDIR
rm -fr pspsdk

cd $BUILDSCRIPTDIR


