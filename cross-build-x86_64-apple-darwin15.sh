#!/bin/bash

export CPPFLAGS=-I/opt/osx/x86_64-apple-darwin15/include
export LDFLAGS=-L/opt/osx/x86_64-apple-darwin15/lib

export OSXCROSS_PKG_CONFIG_USE_NATIVE_VARIABLES=1

export CC=x86_64-apple-darwin15-clang
export CXX=x86_64-apple-darwin15-clang++

export CROSSBUILD=x86_64-apple-darwin15
export CROSSPATH=/opt/osx/x86_64-apple-darwin15
export CROSSLIBPATH=$CROSSPATH/lib
export CROSSBINPATH=$CROSSPATH/bin
export PATH=/opt/osx/bin:$PATH
export PKG_CONFIG_PATH=
export PKG_CONFIG_LIBDIR=$CROSSLIBPATH/pkgconfig

