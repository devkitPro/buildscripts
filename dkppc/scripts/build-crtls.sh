#!/bin/sh

export DEVKITPPC=$TOOLPATH/devkitPPC

#---------------------------------------------------------------------------------
# Install and build the gamecube crt and libogc
#---------------------------------------------------------------------------------

echo "installing linkscripts ..."
cp `pwd`/dkppc/crtls/*.ld $DEVKITPPC/$target/lib/
#---------------------------------------------------------------------------------
# copy base rulesets
#---------------------------------------------------------------------------------
cp `pwd`/dkppc/rules/gamecube_rules dkppc/rules/base_rules $DEVKITPPC

echo "building libogc ..."
cd $LIBOGC_SRCDIR
$MAKE
echo "installing libogc ..."
$MAKE install



