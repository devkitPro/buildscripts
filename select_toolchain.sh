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
    GCC_VER=14.2.0
    BINUTILS_VER=2.43.1
    NEWLIB_VER=4.4.0.20231231
    basedir='dkarm-eabi'
    package=devkitARM
    target=arm-none-eabi
    toolchain=DEVKITARM
  ;;
  "2" )
    GCC_VER=13.2.0
    BINUTILS_VER=2.42
    MN_BINUTILS_VER=2.24
    NEWLIB_VER=4.4.0.20231231
    basedir='dkppc'
    package=devkitPPC
    target=powerpc-eabi
    toolchain=DEVKITPPC
  ;;
  "3" )
    GCC_VER=14.2.0
    BINUTILS_VER=2.43.1
    NEWLIB_VER=4.4.0.20231231
    basedir='dka64'
    package=devkitA64
    target=aarch64-none-elf
    toolchain=DEVKITA64
  ;;
esac
