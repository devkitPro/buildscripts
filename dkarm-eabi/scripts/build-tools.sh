#!/bin/sh


export DEVKITARM=$TOOLPATH/devkitARM
export DEVKITPRO=$TOOLPATH

$MAKE -C tools/gba
$MAKE -C tools/gba install PREFIX=$DEVKITARM/bin

$MAKE -C tools/gp32
$MAKE -C tools/gp32 install PREFIX=$DEVKITARM/bin

$MAKE -C tools/nds/
$MAKE -C tools/nds/ install PREFIX=$DEVKITARM/bin

$MAKE -C tools clean
