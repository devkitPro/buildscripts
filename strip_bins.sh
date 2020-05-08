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
         $prefix/libexec/gcc/$target/$GCC_VER/*
do
	# exclude dll for windows, so for linux/osx, directories .la files, embedspu script & the gccbug text file
	if  ! [[ "$f" == *.dll || "$f" == *.so || -d $f || "$f" == *.la || "$f" == *-embedspu || "$f" == *-gccbug ]]
	then
		$HOST_STRIP $f
	fi
	if [[ "$f" == *.dll ]]
	then
		$HOST_STRIP -d $f
	fi
done

if [ $VERSION -eq 2 ]; then
	for f in	$prefix/mn10200/bin/*
	do
		$HOST_STRIP $f
	done
fi


#---------------------------------------------------------------------------------
# strip debug info from libraries
#---------------------------------------------------------------------------------
find $prefix/lib/gcc/$target -name *.a -exec $target-strip -d {} \;
find $prefix/$target -name *.a -exec $target-strip -d {} \;

