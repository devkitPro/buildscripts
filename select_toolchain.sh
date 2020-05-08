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
    GCC_VER=10.1.0
    BINUTILS_VER=2.32
    NEWLIB_VER=3.3.0
    GDB_VER=8.2.1
    basedir='dkarm-eabi'
    package=devkitARM
    target=arm-none-eabi
    toolchain=DEVKITARM
  ;;
  "2" )
    GCC_VER=8.4.0
    BINUTILS_VER=2.32
    MN_BINUTILS_VER=2.17
    NEWLIB_VER=3.3.0
    GDB_VER=8.2.1
    basedir='dkppc'
    package=devkitPPC
    target=powerpc-eabi
    toolchain=DEVKITPPC
  ;;
  "3" )
    GCC_VER=10.1.0
    BINUTILS_VER=2.32
    NEWLIB_VER=3.3.0
    GDB_VER=9.1
    basedir='dka64'
    package=devkitA64
    target=aarch64-none-elf
    toolchain=DEVKITA64
  ;;
esac
