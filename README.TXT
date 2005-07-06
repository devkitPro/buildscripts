DevkitPro build scripts
--------------------------

This readme will guide you through building devkitARM, devkitPPC or devkitPSP from source using a set of scripts.

To use these scripts under minsys and MinGW you will need some additional packages over and above the base install.

The minsys developer toolkit

http://prdownloads.sourceforge.net/mingw/msysDTK-1.0.1.exe?download

Bison, Flex and Wget from the gnuwin32 project

http://sourceforge.net/projects/gnuwin32/


Two other packages are required on all platforms, these should be built and installed before building the toolchain(s). It appears there is no UPX version for OS X, the scripts will report an error but this is non fatal.

upx

http://upx.sourceforge.net/

libelf

http://www.mr511.de/software/

Downloading the source packages
-------------------------------

When you run the build script it will ask you to choose from one of two options, one for if you have already downloaded the source packages and another for if you want it to download them for you (using wget).  If you choose option one and want to get the source packages for yourself then you can find them at the urls listed below;

binutils 2.16.1  - http://ftp.gnu.org/gnu/binutils/binutils-2.16.1.tar.bz2
gcc-core 3.4.4 - http://ftp.gnu.org/gnu/gcc/gcc-3.4.4/gcc-core-3.4.4.tar.bz2
gcc-g++ 3.4.4 - http://ftp.gnu.org/gnu/gcc/gcc-3.4.4/gcc-g++-3.4.4.tar.bz2
newlib 1.13.0  - ftp://sources.redhat.com/pub/newlib/newlib-1.13.0.tar.gz

libogc, libgba and libnds can be found in the sourceforge project.

http://sourceforge.net/projects/devkitpro

the pspsdk can be found at

http://ps2dev.org/files/pspsdk-1.0+beta.tar.gz

The top level shell script has now been unified and offers the option of devkitARM, devkitPPC or devkitPSP.

Building the devkits
--------------------

Simply run the "build-devkit.sh" script in the same directory as this text file as shown below, then follow the prompts;

./build-devkit.sh

Once the script finds the source packages they will be decompressed and the build process will begin.  When its finished you have the option to delete all temporary files, sources and their source packages.


Using devkitARM
---------------

All you need to do now to use devkitARM is make sure that your freshly built tools are in your PATH, something like this;

export PATH=$PATH:<path to devkitARM>/bin

(Obviously replace <path to devkitARM> with the full path to the devkitARM installation directory)

to use the built in crt0 and linkscript use arm-elf-gcc to link your project

Several specs files are built in for the various platforms

	-specs=gba.specs for a normal GBA cart image.
	-specs=gba_mb.specs for a GBA multiboot image.
	-specs=gba_er for an eReader GBA binary.
	-specs=ds_arm9 for a DS arm9 binary.
	-specs=ds_arm7 for a DS arm7 binary.
	-specs=ds_cart for a DS arm7 binary which runs from GBA cart.
	-specs=gp32.specs for standard GP32 app.
	-specs=gp32_gpsdk.specs for official gamepark SDK GP32 app.
	
Getting started
---------------

The best thing to do next is test the compiler, so go to http://www.devkit.tk and download "libgba" from the downloads section and also "PCXview" from the sample code section.



Using devkitPPC
---------------

All you need to do now to use devkitPPC is make sure that your freshly built tools are in your PATH, something like this;

export PATH=$PATH:<path to devkitPPC>/bin

(Obviously replace <path to devkitPPC> with the full path to the devkitPPC installation directory)

to use the built in crt0 and linkscript use powerpc-elf-gcc to link your project, using the command line switch -mgcn for a bare bones system, -mogc to use libogc and the multi-threaded microkernel.



Credits
-------

* Thanks to WinterMute for bringing us devkitARM, the website is http://www.devkit.tk
* Build scripts written by WinterMute and tied together by GreenGianT
* Thanks to Mr Spiv, Honkey Kong and JoostP for OS X testing
* libogc written and supplied by Shagkur. Additional code by WinterMute
* libgba by WinterMute
* libmirko by Mr Mirko
* b2fxec by Mr Spiv
* scripts made BSD compatible by o2addict
* Dovoto and Joat for DS libraries

  - efnet #gbadev forever!

History
-------------------------------------------------------------------------------------
planned for release 14
-------------------------------------------------------------------------------------
	* rework libraries to allow armv5 arch
	* BFLT support 
	* system libraries for ARM stdio

-------------------------------------------------------------------------------------
20th June 2005 release 13
-------------------------------------------------------------------------------------
	* updated to binutils 2.16.1
	* fixed errors in gba crtls
	* updated nds crtls
	* allow arm9 to write SRAM
	* addition of pineight tools
	* added Mr Spiv's gpd & dsd
	* ndstool updated
	* bin2o rule updated to include extension in name

-------------------------------------------------------------------------------------
21st May 2005 - release 12
-------------------------------------------------------------------------------------
	* update to newlib 1.13.0
	* Nintendo DS support
	* newest libogc

-------------------------------------------------------------------------------------
18th February 2005 - devkitPPC release 11 beta 2
-------------------------------------------------------------------------------------
	* patch for http://gcc.gnu.org/bugzilla/show_bug.cgi?id=9571
	* updated to latest libogc
	* added stub library to allow linking without libogc
 
-------------------------------------------------------------------------------------
21st January 2005 - release 11 beta 1
-------------------------------------------------------------------------------------
	* updated to gcc 3.4.3
	* reverted msvc format errors for compatibility with dev-cpp & vham editors
	* fix iwram overlay section alignment for GBA
	* patched for http://gcc.gnu.org/bugzilla/show_bug.cgi?id=16343

-------------------------------------------------------------------------------------
28th July 2004 - release 8
-------------------------------------------------------------------------------------
	* updated to gcc 3.4.1
	* win32 native b2fxec added & cygwin1.dll removed

-------------------------------------------------------------------------------------
26th June 2004 - devkitPPC release 7
-------------------------------------------------------------------------------------
	* libogc added to devkitPPC
	* updated specs file with -mogc switch for linking

-------------------------------------------------------------------------------------
12th June 2004 - devkitARM release 6a
-------------------------------------------------------------------------------------
	* long calls patch added
	* -save-temps fixed (again)
	* binutils 2.15.0
	* specs file and crt0 for e-reader
	* specs file and crt0 for gamepark gp32 libraries

-------------------------------------------------------------------------------------
8th May 2004 - devkitARM release 6
-------------------------------------------------------------------------------------
	* updated to gcc 3.4.0
	* reverted to binutils 2.14.0

-------------------------------------------------------------------------------------
12th April 2004 - devkitARM release 5.
-------------------------------------------------------------------------------------
    * built in crt0 and linkscript for gp32 added. Use -specs=gp32.specs when linking
    * Mr Spiv's b2fxec included
    * DarkFader's gbafix included
    * linux build available for download

-------------------------------------------------------------------------------------
15th March 2004 - devkitARM Release 4
-------------------------------------------------------------------------------------
    * updated to binutils 2.15.90
    * more msdev error output conversion
    * -save-temps fixed

-------------------------------------------------------------------------------------
26th February 2004 - devkitARM Release 3a
-------------------------------------------------------------------------------------
    * updated to newlib 1.12.0
    * crt0, linkscript and runtime library support added to DevkitARM

-------------------------------------------------------------------------------------
20th February 2004
-------------------------------------------------------------------------------------
    * updated to gcc 3.3.3

-------------------------------------------------------------------------------------
14th February 2004 - devkitARM Release 2
-------------------------------------------------------------------------------------
    * crt0, linkscript and runtime library support added to DevkitPPC
    * adjusted error output for msdev
    * Fixed minor problem with include paths

-------------------------------------------------------------------------------------
16th January 2004 - devkitARM release 1
-------------------------------------------------------------------------------------
    * Initial build supporting arm target
    * Required link script and crt0
    * no built in support for runtime libraries
