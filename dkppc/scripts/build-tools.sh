#!/bin/sh


export DEVKITPPC=$TOOLPATH/devkitPPC
export DEVKITPRO=$TOOLPATH

$MAKE -C tools/gamecube
$MAKE -C tools/gamecube install PREFIX=$DEVKITPPC/bin


$MAKE -C tools clean
