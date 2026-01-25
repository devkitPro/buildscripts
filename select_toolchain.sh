#!/bin/bash
VERSION=0
case "$BUILD_DKPRO_PACKAGE" in
  "1" )
    VERSION=1
  ;;
  "2" )
    VERSION=2
  ;;
  "3" )
    VERSION=3
  ;;
esac

while [ $VERSION -eq 0 ]
do
  echo
  echo "Please select the toolchain you require"
  echo
  echo "1: devkitARM (gba gp32 ds 3ds)"
  echo "2: devkitPPC (gamecube wii wii-u)"
  echo "3: devkitA64 (switch)"
  read VERSION

  if [ "$VERSION" -ne 1 -a "$VERSION" -ne 2 -a "$VERSION" -ne 3 ]
  then
      VERSION=0
  fi
done

case "$VERSION" in
  "1" )
    BINUTILS_VER=2.45.1
    GCC_VER=15.2.0
    NEWLIB_VER=4.5.0.20241231
    BINUTILS_PKGREL=2
    GCC_PKGREL=6
    NEWLIB_PKGREL=5
    basedir='dkarm-eabi'
    package=devkitARM
    target=arm-none-eabi
    toolchain=DEVKITARM
    _prefix=devkitarm
    _toolchain_options='--with-march=armv4t --enable-interwork --enable-multilib --with-pkgversion="devkitARM"'
    _rules_ver=${DKARM_RULES_VER}
    _crtls_ver=${DKARM_CRTLS_VER}
  ;;
  "2" )
    BINUTILS_VER=2.45.1
    GCC_VER=15.2.0
    MN_BINUTILS_VER=2.24
    NEWLIB_VER=4.6.0.20260123
    BINUTILS_PKGREL=2
    GCC_PKGREL=7
    NEWLIB_PKGREL=1
    basedir='dkppc'
    package=devkitPPC
    target=powerpc-eabi
    toolchain=DEVKITPPC
    _prefix=devkitppc
    cppflags="-DSTDINT_LONG32=0 ${cppflags}"
    _toolchain_options='--with-cpu=750 --disable-multilib --with-pkgversion="devkitPPC"'
    _rules_ver=${DKPPC_RULES_VER}
    _crtls_ver=${DKPPC_CRTLS_VER}
  ;;
  "3" )
    GCC_VER=15.2.0
    BINUTILS_VER=2.45.1
    NEWLIB_VER=4.5.0.20241231
    BINUTILS_PKGREL=2
    GCC_PKGREL=3
    NEWLIB_PKGREL=5
    basedir='dka64'
    package=devkitA64
    target=aarch64-none-elf
    toolchain=DEVKITA64
    _prefix=devkita64
    _toolchain_options='--with-march=armv8 --enable-multilib --with-pkgversion="devkitA64"'
    _rules_ver=${DKA64_RULES_VER}
    _crtls_ver=${DKA64_CRTLS_VER}
  ;;
esac
