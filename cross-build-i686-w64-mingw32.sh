#!/bin/bash
export CROSSBUILD=i686-w64-mingw32
export CROSSLIBPATH=/opt/i686-w64-mingw32/mingw/lib
export CROSSBINPATH=/opt/i686-w64-mingw32/mingw/bin
export PATH=/opt/i686-w64-mingw32/bin:$PATH
export PKG_CONFIG_PATH=$CROSSLIBPATH/pkgconfig

