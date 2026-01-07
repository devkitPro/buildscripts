#!/usr/bin/env bash
#---------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
# build and install the full compiler
#---------------------------------------------------------------------------------
mkdir -p ${BUILDDIR}/$target/gcc
cd ${BUILDDIR}/$target/gcc


if [ ! -f built-gcc-stage2 ]
then
	$MAKE || { echo "Error building gcc stage2"; exit 1; }
	touch built-gcc-stage2
fi

if [ ! -f installed-gcc-stage2 ]
then
	$MAKE install-strip || { echo "Error installing gcc"; exit 1; }
	touch installed-gcc-stage2
fi
