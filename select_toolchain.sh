#!/bin/bash
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
    GCC_VER=4.6.3
    BINUTILS_VER=2.22
    NEWLIB_VER=1.20.0
    GDB_VER=7.4
    basedir='dkarm-eabi'
    package=devkitARM
    builddir=arm-eabi
    target=arm-eabi
    toolchain=DEVKITARM
  ;;
  "2" )
    GCC_VER=4.6.2
    BINUTILS_VER=2.22
    NEWLIB_VER=1.20.0
    GDB_VER=7.4
    basedir='dkppc'
    package=devkitPPC
    builddir=powerpc-eabi
    target=powerpc-eabi
    toolchain=DEVKITPPC
  ;;
  "3" )
    GCC_VER=4.6.2
    BINUTILS_VER=2.22
    NEWLIB_VER=1.20.0
    GDB_VER=7.4
    basedir='dkpsp'
    package=devkitPSP
    builddir=psp
    target=psp
    toolchain=DEVKITPSP
  ;;
esac