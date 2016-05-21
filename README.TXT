devkitPro build scripts
--------------------------

This readme will guide you through building devkitARM, devkitPPC or devkitPSP
from source using a set of scripts.

The windows versions of the toolchains are now cross compiled on linux using
mingw-w64

Preparing to build
--------------------------

required packages for building on debian/*buntu

sudo apt-get install build-essential autoconf automake bison flex libncurses5-dev
libreadline-dev texinfo pkg-config

For building gcc libgmp, libmpfr and libmpc are required - these are built as
static libraries to make packaging simpler. If you're building the tools for
personal use then the versions packaged by your chosen distro should suffice.

http://gmplib.org/
http://www.mpfr.org/
http://www.multiprecision.org/

sudo apt-get install libgmp-dev libmpfr-dev libmpc-dev

Some of the tools for devkitARM and devkitPPC also require FreeImage, zlib,
and libusb. Again these are built as static libraries for ease of packaging
but you can probably use the versions supplied by your distro.

http://freeimage.sourceforge.net/
http://www.zlib.net
http://www.libusb.org

sudo apt-get install  libfreeimage-dev zlib1g-dev libusb-dev

Building gxtexconv for cube/wii needs GL/gl.h which can be obtained with

sudo apt-get install mesa-common-dev

To avoid having to manually answer prompts during the build the script will
read variables from config.sh if it exists. Copy config.sh.sample to config.sh
and set the variables as appropriate for your build.

The script will download the source packages it needs. These will be downloaded
to the script directory by default but you can set BUILD_DKPRO_SRCDIR if you want
to put them somewhere else.  When its finished you have the option to delete
all temporary files, sources and their source packages.


Building the devkits
--------------------

Simply run the "build-devkit.sh" script in the same directory as this text file
as shown below, then follow the prompts;

./build-devkit.sh

Several examples tarballs are provided for the platforms supported by devkitARM &
devkitPPC, these include basic templates for starting your own projects.
See http://wiki.devkitpro.org/index.php/Getting_Started for links.

Using devkitARM
---------------

to use the built in crt0 and linkscript use arm-none-eabi-gcc to link your project

Several specs files are built in for the various platforms

	-specs=gba.specs for a normal GBA cart image.
	-specs=gba_mb.specs for a GBA multiboot image.
	-specs=gba_er for an eReader GBA binary.
	-specs=ds_arm9 for a DS arm9 binary.
	-specs=ds_arm7 for a DS arm7 binary.
	-specs=ds_cart for a DS arm7 binary which runs from GBA cart.
	-specs=gp32.specs for standard GP32 app.
	-specs=gp32_gpsdk.specs for official gamepark SDK GP32 app.
	-specs=3dsx.specs for a 3DS homebrew binary.

Using devkitPPC
---------------

to use the built in crt0 and linkscript use powerpc-eabi-gcc to link your project,
using the command line switch -mgcn for a bare bones system, -mogc to use libogc and
the multi-threaded microkernel for gamecube, -mrvl for wii, -mwup for wii u.

Using devkitPSP
---------------

All you need to do now to use devkitPSP is make sure that your freshly built tools
are in your PATH, something like this;

export PATH=$PATH:<path to devkitPSP>/bin

(Obviously replace <path to devkitPSP> with the full path to the devkitPSP
installation directory)

Getting started
---------------

The best thing to do next is test the compiler, so grab an examples tarball
from sourceforge & run make in the top level.

Credits
-------

* Thanks to WinterMute for bringing us devkitPro, the website is http://www.devkitpro.org
* Build scripts written by WinterMute and tied together by GreenGianT
* Thanks to Mr Spiv, Honkey Kong, Raleigh and JoostP for OS X testing
* libctru by Smealum, YellowS8, fincs, mtheall & WinterMute with contributions from many others.
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

