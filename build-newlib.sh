#!/usr/bin/env bash
#---------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
# build and install newlib
#---------------------------------------------------------------------------------

unset CFLAGS
cd $BUILDDIR

OLD_CC=$CC
OLDCXX=$CXX
unset CC
unset CXX

#---------------------------------------------------------------------------------
# build and install newlib
#---------------------------------------------------------------------------------
mkdir -p ${BUILDDIR}/$target/newlib
cd ${BUILDDIR}/$target/newlib

_target_cflags="-O2 -ffunction-sections -fdata-sections"

if [ $VERSION -eq 2 ]; then
	_target_cflags="${_target_cflags} -DCUSTOM_MALLOC_LOCK"
fi

if [ ! -f configured-newlib ]
then
        CFLAGS_FOR_TARGET="${_target_cflags}" \
        ../../newlib-$NEWLIB_VER/configure \
        --disable-newlib-supplied-syscalls \
        --enable-newlib-mb \
        --disable-newlib-wide-orient \
        --enable-newlib-register-fini \
        --target=$target \
        --prefix=$prefix \
        || { echo "Error configuring newlib"; exit 1; }
        touch configured-newlib
fi

if [ ! -f built-newlib ]
then
        $MAKE || { echo "Error building newlib"; exit 1; }
        touch built-newlib
fi


if [ ! -f installed-newlib ]
then
        $MAKE install -j1 || { echo "Error installing newlib"; exit 1; }
        touch installed-newlib
fi

export CC=$OLD_CC
export CXX=$OLD_CXX
