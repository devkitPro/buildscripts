devkitPro build scripts
--------------------------

This readme will guide you through building devkitARM, devkitPPC or devkitPSP from source using a set of scripts.

To use these scripts under minsys and MinGW you will need some additional packages over and above the base install.

The minsys developer toolkit

http://prdownloads.sourceforge.net/mingw/msysDTK-1.0.1.exe?download

Bison, Flex and Wget from the gnuwin32 project

http://sourceforge.net/projects/gnuwin32/

required packages for building on debian/*buntu

sudo apt-get install build-essential autoconf automake bison flex libncurses5-dev libreadline-dev texinfo

for building gcc libgmp, libmpfr and libmpc are required

http://gmplib.org/
http://www.mpfr.org/
http://www.multiprecision.org/

Some of the tools for devkitARM and devkitPPC also require FreeImage, zlib, and libusb

http://freeimage.sourceforge.net/
http://www.zlib.net
http://www.libusb.org

 
Downloading the source packages
-------------------------------

When you run the build script it will ask you to choose from one of two options, one for if you have already downloaded the source packages and another for if you want it to download them for you (using wget or curl).

The top level shell script has now been unified and offers the option of devkitARM, devkitPPC or devkitPSP.

Building the devkits
--------------------

Simply run the "build-devkit.sh" script in the same directory as this text file as shown below, then follow the prompts;

./build-devkit.sh

Once the script finds the source packages they will be decompressed and the build process will begin.  When its finished you have the option to delete all temporary files, sources and their source packages.

To avoid having to manually answer prompts during the build the script will read variables from config.sh if it exists. Copy config.sh.sample to config.sh and set the variables as appropriate for your build.

Several examples tarballs are provided for the platforms supported by devkitARM & devkitPPC, these include basic templates for starting your own projects. See http://wiki.devkitpro.org/index.php/Getting_Started for links.

Using devkitARM
---------------

to use the built in crt0 and linkscript use arm-eabi-gcc to link your project

Several specs files are built in for the various platforms

	-specs=gba.specs for a normal GBA cart image.
	-specs=gba_mb.specs for a GBA multiboot image.
	-specs=gba_er for an eReader GBA binary.
	-specs=ds_arm9 for a DS arm9 binary.
	-specs=ds_arm7 for a DS arm7 binary.
	-specs=ds_cart for a DS arm7 binary which runs from GBA cart.
	-specs=gp32.specs for standard GP32 app.
	-specs=gp32_gpsdk.specs for official gamepark SDK GP32 app.

Using devkitPPC
---------------

to use the built in crt0 and linkscript use powerpc-gekko-gcc to link your project, using the command line switch -mgcn for a bare bones system, -mogc to use libogc and the multi-threaded microkernel for gamecube, -mrvl for wii.

Using devkitPSP
---------------

All you need to do now to use devkitPSP is make sure that your freshly built tools are in your PATH, something like this;

export PATH=$PATH:<path to devkitPSP>/bin

(Obviously replace <path to devkitPSP> with the full path to the devkitPSP installation directory)

Getting started
---------------

The best thing to do next is test the compiler, so grab an examples tarball from sourceforge & run make in the top level.

Credits
-------

* Thanks to WinterMute for bringing us devkitPro, the website is http://www.devkitpro.org
* Build scripts written by WinterMute and tied together by GreenGianT
* Thanks to Mr Spiv, Honkey Kong, Raleigh and JoostP for OS X testing
* libogc written and supplied by Shagkur. Additional code by WinterMute, Bushing, Marcan & Tybor
* libgba by WinterMute
* libnds by Joat, Dovoto and WinterMute with contributions from many others.
* dswifi by Sgstair
* libfat by Chishm
* libmirko by Mr Mirko
* maxmod by eKid
* b2fxec by Mr Spiv
* scripts made BSD compatible by o2addict

  - irc.blitzed.org #gbadev, #dsdev, #wiidev forever!

