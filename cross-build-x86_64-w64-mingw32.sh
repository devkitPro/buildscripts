#!/bin/bash
export CROSSBUILD=x86_64-w64-mingw32
export CROSSLIBPATH=/opt/mingw64/mingw/lib
export CROSSBINPATH=/opt/mingw64/mingw/bin
export PATH=/opt/mingw64/bin:$PATH
export PKG_CONFIG_PATH=
export PKG_CONFIG_LIBDIR=$CROSSLIBPATH/pkgconfig

