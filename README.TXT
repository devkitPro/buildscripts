Devkit r11 build scripts
--------------------------

This readme will guide you through building devkitARM or devkitPPC from source using a set of scripts.

To use these scripts under minsys and MinGW you will need some additional packages over and above the base install.

The minsys developer toolkit

http://prdownloads.sf.net/mingw/msysDTK-1.0.1.exe?download

Bison, Flex and Wget from the gnuwin32 project

http://sourceforge.net/projects/gnuwin32/

Downloading the source packages
-------------------------------

When you run the build script it will ask you to choose from one of two options, one for if you have already downloaded the source packages and another for if you want it to download them for you (using wget).  If you choose option one and want to get the source packages for yourself then you can find them at the urls listed below;

binutils 2.15  - http://ftp.gnu.org/gnu/binutils/binutils-2.15.tar.bz2
gcc-core 3.4.2 - ftp://ftp.gwdg.de/pub/misc/gcc/releases/gcc-3.4.3/gcc-core-3.4.2.tar.bz2
gcc-g++ 3.4.2  - ftp://ftp.gwdg.de/pub/misc/gcc/releases/gcc-3.4.3/gcc-g++-3.4.2.tar.bz2
newlib 1.12.0  - ftp://sources.redhat.com/pub/newlib/newlib-1.12.0.tar.gz

The top level shell script has now been unified and offers the option of devkitARM or devkitPPC.

Building devkitARM
------------------

Simply run the "build-devkit.sh" script in the same directory as this text file as shown below, then follow the prompts;

./build-devkit.sh

Once the script finds the source packages they will be decompressed and the build process will begin.  When its finished you have the option to delete all temporary files, sources and their source packages.


Using devkitARM
---------------

All you need to do now to use devkitARM is make sure that your freshly built tools are in your PATH, something like this;

export PATH=$PATH:<path to devkitARM>/bin

(Obviously replace <path to devkitARM> with the full path to the devkitARM installation directory)

to use the built in crt0 and linkscript use arm-elf-gcc to link your project - use the command -specs=gba.specs for a normal cart image & -specs=gba_mb.specs for a multiboot image.

Getting started
---------------

The best thing to do next is test the compiler, so go to http://www.devkit.tk and download "libgba" from the downloads section and also "PCXview" from the sample code section.


Building devkitPPC
------------------

Simply run the "build-devkit.sh" script in the same directory as this text file as shown below, then follow the prompts;

./build-devkit.sh

Once the script finds the source packages they will be decompressed and the build process will begin.  When its finished you have the option to delete all temporary files, sources and their source packages.


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
* b2fxec by Mr Spiv
* scripts made BSD compatible by o2addict

  - efnet #gbadev forever!

History
-------------------------------------------------------------------------------------
planned for release 12
-------------------------------------------------------------------------------------
	* update to newlib 1.13.0

-------------------------------------------------------------------------------------
planned for release 11 beta 2
-------------------------------------------------------------------------------------
	* patch for http://gcc.gnu.org/bugzilla/show_bug.cgi?id=9571
	* fix iwram overlay section alignment for GBA
 
-------------------------------------------------------------------------------------
21st January 2005 - release 11 beta 1
-------------------------------------------------------------------------------------

	* updated to gcc 3.4.3
	* reverted msvc format errors for compatibility with dev-cpp & vham editors
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
12th June 2004 - release 6a
-------------------------------------------------------------------------------------

	* long calls patch added
	* -save-temps fixed (again)
	* binutils 2.15.0
	* specs file and crt0 for e-reader
	* specs file and crt0 for gamepark gp32 libraries

-------------------------------------------------------------------------------------
8th May 2004 - release 6
-------------------------------------------------------------------------------------

	* updated to gcc 3.4.0
	* reverted to binutils 2.14.0

-------------------------------------------------------------------------------------
12th April 2004 - release 5.
-------------------------------------------------------------------------------------

    * built in crt0 and linkscript for gp32 added. Use -specs=gp32.specs when linking
    * Mr Spiv's b2fxec included
    * DarkFader's gbafix included
    * linux build available for download

-------------------------------------------------------------------------------------
15th March 2004 - Release 4
-------------------------------------------------------------------------------------

    * updated to binutils 2.15.90
    * more msdev error output conversion
    * -save-temps fixed

-------------------------------------------------------------------------------------
26th February 2004 - Release 3a
-------------------------------------------------------------------------------------

    * updated to newlib 1.12.0
    * crt0, linkscript and runtime library support added to DevkitARM

-------------------------------------------------------------------------------------
20th February 2004
-------------------------------------------------------------------------------------

DevkitARM and DevkitPPC updated - Release 3

    * updated to gcc 3.3.3

-------------------------------------------------------------------------------------
14th February 2004 - Release 2
-------------------------------------------------------------------------------------

    * crt0, linkscript and runtime library support added to DevkitPPC
    * adjusted error output for msdev
    * Fixed minor problem with include paths

-------------------------------------------------------------------------------------
16th January 2004 - release 1
-------------------------------------------------------------------------------------

    * Initial build supporting arm target
    * Required link script and crt0
    * no built in support for runtime libraries
