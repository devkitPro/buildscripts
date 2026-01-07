#!/usr/bin/env bash
#---------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
# build and install the full compiler
#---------------------------------------------------------------------------------
mkdir -p ${BUILDDIR}/$target/gcc
cd ${BUILDDIR}/$target/gcc


if [ ! -f configured-gcc ]
then
	CPPFLAGS="$cppflags $CPPFLAGS" \
	LDFLAGS="$ldflags $LDFLAGS" \
	CFLAGS_FOR_TARGET="-O2 -ffunction-sections -fdata-sections" \
	CXXFLAGS_FOR_TARGET="-O2 -ffunction-sections -fdata-sections" \
	LDFLAGS_FOR_TARGET="" \
	../../gcc-$GCC_VER/configure \
		--target=$target \
		--prefix=$prefix \
		--enable-languages=c,c++,objc,lto \
		--with-gnu-as --with-gnu-ld --with-gcc \
		--enable-cxx-flags='-ffunction-sections' \
		--disable-libstdcxx-verbose \
		--enable-poison-system-directories \
		--enable-threads=posix --disable-win32-registry --disable-nls --disable-debug \
		--disable-libmudflap --disable-libssp --disable-libgomp \
		--disable-libstdcxx-pch \
		--enable-libstdcxx-time=yes \
		--enable-libstdcxx-filesystem-ts \
		--with-newlib=yes \
		--with-native-system-header-dir=/include \
		--with-sysroot=${prefix}/${target} \
		--enable-lto \
		--disable-tm-clone-registry \
		--disable-__cxa_atexit \
		--with-bugurl="https://devkitpro.org" \
		${_toolchain_options} \
		$CROSS_PARAMS \
		$CROSS_GCC_PARAMS \
		$EXTRA_GCC_PARAMS \
		|| { echo "Error configuring gcc"; exit 1; }
	touch configured-gcc
fi

if [ ! -f built-gcc ]
then
	$MAKE all-gcc || { echo "Error building gcc stage1"; exit 1; }
	touch built-gcc
fi

if [ ! -f installed-gcc ]
then
	$MAKE install-gcc || { echo "Error installing gcc stage 1"; exit 1; }
	touch installed-gcc
fi
