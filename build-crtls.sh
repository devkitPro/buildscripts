#!/usr/bin/env bash

#---------------------------------------------------------------------------------
# set env variables
#---------------------------------------------------------------------------------
export DEVKITPRO=$TOOLPATH
export DEVKITPPC=$DEVKITPRO/devkitPPC
export DEVKITARM=$DEVKITPRO/devkitARM

#---------------------------------------------------------------------------------
# Install the rules files
#---------------------------------------------------------------------------------
cd $BUILDDIR

if [ ! -f extracted-${_prefix}-rules ]; then
  tar -xvf $SRCDIR/${_prefix}-rules-${_rules_ver}.tar.gz || touch extracted-${_prefix}-rules
fi

cd ${_prefix}-rules-${_rules_ver}

if [ ! -f installed-${_prefix}-rules ]; then
  $MAKE install || touch installed-${_prefix}-rules
fi

#---------------------------------------------------------------------------------
# Install the linkscripts
#---------------------------------------------------------------------------------
if [ $VERSION -ne 3 ]; then
  cd $BUILDDIR

  if [ ! -f extracted-${_prefix}-crtls ]; then
    tar -xvf $SRCDIR/${_prefix}-crtls-${_crtls_ver}.tar.gz || touch extracted-${_prefix}-crtls
  fi

  cd ${_prefix}-crtls-${_crtls_ver}

  if [ ! -f installed-${_prefix}-crtls ]; then
    $MAKE install || touch installed-${_prefix}-crtls
  fi
fi
