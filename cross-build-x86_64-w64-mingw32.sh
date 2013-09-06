#!/bin/bash
export CROSSBUILD=x86_64-w64-mingw32
export CROSSLIBPATH=/opt/x86_64-mingw-w64/mingw/lib
export CROSSBINPATH=/opt/x86_64-mingw-w64/mingw/bin
export PATH=/opt/x86_64-mingw-w64/bin:$PATH
export PKG_CONFIG_PATH=$CROSSLIBPATH/pkgconfig

