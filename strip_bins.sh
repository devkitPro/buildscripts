#!/bin/bash
#---------------------------------------------------------------------------------
# strip binaries
# strip has trouble using wildcards so do it this way instead
#---------------------------------------------------------------------------------

for f in $INSTALLDIR/$package/bin/* \
         $INSTALLDIR/$package/$target/bin/* \
         $INSTALLDIR/$package/libexec/gcc/$target/$GCC_VER/*
do
  # exclude dll for windows, so for linux/osx, directories .la files, embedspu script & the gccbug text file
  if  ! [[ "$f" == *.dll || "$f" == *.so || -d $f || "$f" == *.la || "$f" == *-embedspu || "$f" == *-gccbug ]]
  then
    strip $f
  fi
done

#---------------------------------------------------------------------------------
# strip debug info from libraries
#---------------------------------------------------------------------------------
find $INSTALLDIR/$package/lib/gcc/$target -name *.a -exec $target-strip -d {} \;
find $INSTALLDIR/$package/$target -name *.a -exec $target-strip -d {} \;
