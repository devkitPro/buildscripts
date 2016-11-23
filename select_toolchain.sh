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
  echo "1: devkitARM (gba gp32 ds)"
  echo "2: devkitPPC (gamecube wii)"
  echo "3: devkitPSP (PSP)"
  read VERSION

  if [ "$VERSION" -ne 1 -a "$VERSION" -ne 2 -a "$VERSION" -ne 3 ]
  then
      VERSION=0
  fi
done

case "$VERSION" in
  "1" )
    GCC_VER=5.3.0
    BINUTILS_VER=2.25.1
    NEWLIB_VER=2.2.0
    GDB_VER=7.10
    basedir='dkarm-eabi'
    package=devkitARM
    target=arm-none-eabi
    toolchain=DEVKITARM
  ;;
  "2" )
    GCC_VER=6.2.0
    BINUTILS_VER=2.27
    NEWLIB_VER=2.0.0
    GDB_VER=7.11
    basedir='dkppc'
    package=devkitPPC
    target=powerpc-eabi
    toolchain=DEVKITPPC
  ;;
  "3" )
    GCC_VER=4.9.3
    BINUTILS_VER=2.22
    NEWLIB_VER=1.20.0
    GDB_VER=7.4
    basedir='dkpsp'
    package=devkitPSP
    target=psp
    toolchain=DEVKITPSP
  ;;
esac
