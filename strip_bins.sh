#!/bin/bash
#---------------------------------------------------------------------------------
# strip binaries
# strip has trouble using wildcards so do it this way instead
#---------------------------------------------------------------------------------

if [ ! -z $CROSSBUILD ]; then
	HOST_STRIP=$CROSSBUILD-strip
else
	HOST_STRIP=strip
fi

for f in $prefix/bin/* \
         $prefix/$target/bin/* \
         $prefix/$package/libexec/gcc/$target/$GCC_VER/*
do
  # exclude dll for windows, so for linux/osx, directories .la files, embedspu script & the gccbug text file
  if  ! [[ "$f" == *.dll || "$f" == *.so || -d $f || "$f" == *.la || "$f" == *-embedspu || "$f" == *-gccbug ]]
  then
    $HOST_STRIP $f
  fi
done

#---------------------------------------------------------------------------------
# strip debug info from libraries
#---------------------------------------------------------------------------------
find $prefix/lib/gcc/$target -name *.a -exec $target-strip -d {} \;
find $prefix/$package/$target -name *.a -exec $target-strip -d {} \;
