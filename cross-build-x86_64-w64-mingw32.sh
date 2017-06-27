#!/bin/bash
export CROSSBUILD=x86_64-w64-mingw32
export CROSSPATH=/opt/mingw64/mingw
export CROSSLIBPATH=$CROSSPATH/lib
export CROSSBINPATH=$CROSSPATH/bin
export PATH=/opt/mingw64/bin:$PATH
export PKG_CONFIG_PATH=
export PKG_CONFIG_LIBDIR=$CROSSLIBPATH/pkgconfig

