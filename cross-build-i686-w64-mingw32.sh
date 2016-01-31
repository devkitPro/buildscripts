#!/bin/bash
export CROSSBUILD=i686-w64-mingw32
export CROSSLIBPATH=/opt/mingw32/mingw/lib
export CROSSBINPATH=/opt/mingw32/mingw/bin
export PATH=/opt/mingw32/bin:$PATH
export PKG_CONFIG_PATH=
export PKG_CONFIG_LIBDIR=$CROSSLIBPATH/pkgconfig
