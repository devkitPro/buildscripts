/* Linker Script Original v1.3 by Jeff Frohwein     */
/*  v1.0 - Original release                         */
/*  v1.1 - Added proper .data section support       */
/*  v1.2 - Added support for c++ & iwram overlays   */
/*       - Major contributions by Jason Wilkins.    */
/*  v1.3 - .ewram section now can be used when      */
/*         compiling for MULTIBOOT mode. This fixes */
/*         malloc() in DevKitAdvance which depends  */
/*         on __eheap_start instead of end to define*/
/*         the starting location of heap space.     */
/*         External global variable __gba_iwram_heap*/
/*         support added to allow labels end, _end, */
/*         & __end__ to point to end of iwram or    */
/*         the end of ewram.                        */
/*                                                  */
/* Additions by WinterMute	                    */
/* v1.4 - .sbss section added for unitialised       */
/*        data in ewram                             */
/* v1.5 - padding section added to stop EZF         */
/*        stripping important data                  */
/* Additions by Joat:                               */
/* v1.6 - Adapted for the DS                        */

/* This file is released into the public domain     */
/* for commercial or non-commercial use with no     */
/* restrictions placed upon it.                     */

/* NOTE!!!: This linker script defines the RAM &  */
/*   ROM start addresses. In order for it to work */
/*   properly, remove -Ttext and -Tbss linker     */
/*   options from your makefile if they are       */
/*   present.                                     */

/* You can use the following to view section      */
/* addresses in your .elf file:                   */
/*   objdump -h file.elf                          */
/* Please note that empty sections may incorrectly*/
/* list the lma address as the vma address for    */
/* some versions of objdump.                      */

OUTPUT_FORMAT("elf32-littlearm", "elf32-bigarm", "elf32-littlearm")
OUTPUT_ARCH(arm)
ENTRY(_start)
/* SEARCH_DIR(/bin/arm); */

/* The linker script function "var1 += var2;" sometimes    */
/* reports incorrect values in the *.map file but the      */
/* actual value it calculates is usually, if not always,   */
/* correct. If you leave out the ". = ALIGN(4);" at the    */
/* end of each section then the return value of SIZEOF()   */
/* is sometimes incorrect and "var1 += var2;" appears to   */
/* not work as well. "var1 += var2" style functions are    */
/* avoided below as a result.                              */

/* The linker script MEMORY directive is not used here due    */
/* to the fact that __text_start is not always a fixed value. */

__ewram_start		=	0x03800000;
/*__ewram_start		=	0x023C0000;*/
__text_start 		=	0x02380000;
__eheap_end		=	0x03810000 - 0x1000;
/*__eheap_end		=	0x02400000;*/
__iwram_start		=	0x03810000 - 0x800;/* tiny, error */
__iheap_end		=	0x03810000 - 0x400;
__sp_usr		=	0x03810000 - 0x140;
__sp_irq		=	0x03810000 - 0x60;
__sp_usr_offset		=	__sp_usr - __iwram_start;

SECTIONS
{
	. = __text_start;
  .init :
  {
    KEEP (*(.init))
    . = ALIGN(4);
  } =0xff

	.plt :
 	{
		*(.plt)
		. = ALIGN(4);   /* REQUIRED. LD is flaky without it. */
	}

  .text  :   /* ALIGN (4): */
  {
    *(EXCLUDE_FILE (*.iwram*) .text)
    *(.text.*)
    *(.stub)
    /* .gnu.warning sections are handled specially by elf32.em.  */
    *(.gnu.warning)
    *(.gnu.linkonce.t*)
    *(.glue_7)
    *(.glue_7t)
    . = ALIGN(4);  /* REQUIRED. LD is flaky without it. */
  } = 0xff
  __text_end = .;
  .fini           :
  {
    KEEP (*(.fini))
    . = ALIGN(4);  /* REQUIRED. LD is flaky without it. */
  } =0

  .rodata :
  {
    *(.rodata)
    *all.rodata*(*)
    *(.roda)
    *(.rodata.*)
    *(.gnu.linkonce.r*)
    SORT(CONSTRUCTORS)
    . = ALIGN(4);   /* REQUIRED. LD is flaky without it. */
  } = 0xff

  .ctors :
  {
    /* gcc uses crtbegin.o to find the start of the constructors, so
       we make sure it is first.  Because this is a wildcard, it
       doesn't matter if the user does not actually link against
       crtbegin.o; the linker won't look for a file to match a
       wildcard.  The wildcard also means that it doesn't matter which
       directory crtbegin.o is in.  */
    KEEP (*crtbegin.o(.ctors))
    KEEP (*(EXCLUDE_FILE (*crtend.o) .ctors))
    KEEP (*(SORT(.ctors.*)))
    KEEP (*(.ctors))
    . = ALIGN(4);   /* REQUIRED. LD is flaky without it. */
  } = 0

  .dtors :
  {
    KEEP (*crtbegin.o(.dtors))
    KEEP (*(EXCLUDE_FILE (*crtend.o) .dtors))
    KEEP (*(SORT(.dtors.*)))
    KEEP (*(.dtors))
    . = ALIGN(4);   /* REQUIRED. LD is flaky without it. */
  } = 0
   .jcr            : { KEEP (*(.jcr)) }

/*  laddr = ADDR(.init) + SIZEOF(.init) +  SIZEOF(.text) + SIZEOF(.fini) + SIZEOF(.rodata) + SIZEOF(.ctors) + SIZEOF(.dtors);
*/
  .eh_frame :
  {
    KEEP (*(.eh_frame))
    . = ALIGN(4);   /* REQUIRED. LD is flaky without it. */
  } = 0

  .gcc_except_table :
  {
    *(.gcc_except_table)
    . = ALIGN(4);   /* REQUIRED. LD is flaky without it. */
  } = 0
  __iwram_lma = .;

  .iwram __iwram_start : AT (__iwram_lma)
  {
    __iwram_start = ABSOLUTE(.) ;
    *(.iwram)
    *iwram.*(.text)
    . = ALIGN(4);   /* REQUIRED. LD is flaky without it. */
  } = 0xff

  __data_lma = __iwram_lma + SIZEOF(.iwram) ;
  __iwram_end = . ;

  .bss ALIGN(4) :
  {
   __bss_start = ABSOLUTE(.);
   __bss_start__ = ABSOLUTE(.);
   *(.dynbss)
   *(.gnu.linkonce.b*)
   *(COMMON)
   . = ALIGN(4);    /* REQUIRED. LD is flaky without it. */
  }

  __bss_end = . ;
  __bss_end__ = . ;

  .data ALIGN(4) : AT (__data_lma)
  {
    __data_start = ABSOLUTE(.);
    *(.data)
    *(.data.*)
    *(.gnu.linkonce.d*)
    CONSTRUCTORS
  } = 0xff

  __iwram_overlay_lma = __data_lma + SIZEOF(.data);

  __data_end  =  .;
  PROVIDE (edata = .);
  __iwram_overlay_start = . ;

  OVERLAY : NOCROSSREFS AT (__iwram_overlay_lma)
  {
     .iwram0 { *(.iwram0) . = ALIGN(4);}
     .iwram1 { *(.iwram1) . = ALIGN(4);}
     .iwram2 { *(.iwram2) . = ALIGN(4);}
     .iwram3 { *(.iwram3) . = ALIGN(4);}
     .iwram4 { *(.iwram4) . = ALIGN(4);}
     .iwram5 { *(.iwram5) . = ALIGN(4);}
     .iwram6 { *(.iwram6) . = ALIGN(4);}
     .iwram7 { *(.iwram7) . = ALIGN(4);}
     .iwram8 { *(.iwram8) . = ALIGN(4);}
     .iwram9 { *(.iwram9) . = ALIGN(4);}
  } = 0xff
  __ewram_lma = LOADADDR(.iwram0) + SIZEOF(.iwram0)+SIZEOF(.iwram1)+SIZEOF(.iwram2)+SIZEOF(.iwram3)+SIZEOF(.iwram4)+SIZEOF(.iwram5)+SIZEOF(.iwram6)+SIZEOF(.iwram7)+SIZEOF(.iwram8)+SIZEOF(.iwram9);

  __iwram_overlay_end = . ;
  __iheap_start = . ;

  .ewram __ewram_start : AT (__ewram_lma)
  {
    *(.ewram)
    . = ALIGN(4);  /* REQUIRED. LD is flaky without it. */
  } = 0xff
  __ewram_overlay_lma = __ewram_lma + SIZEOF(.ewram);

	.sbss ALIGN(4):
 	{
 		*(.sbss)
 		. = ALIGN(4);
 	}

  __ewram_end = . ;
  __ewram_overlay_start = . ;

  OVERLAY ALIGN(4): NOCROSSREFS AT (__ewram_overlay_lma)
  {
     .ewram0 { *(.ewram0) . = ALIGN(4);}
     .ewram1 { *(.ewram1) . = ALIGN(4);}
     .ewram2 { *(.ewram2) . = ALIGN(4);}
     .ewram3 { *(.ewram3) . = ALIGN(4);}
     .ewram4 { *(.ewram4) . = ALIGN(4);}
     .ewram5 { *(.ewram5) . = ALIGN(4);}
     .ewram6 { *(.ewram6) . = ALIGN(4);}
     .ewram7 { *(.ewram7) . = ALIGN(4);}
     .ewram8 { *(.ewram8) . = ALIGN(4);}
     .ewram9 { *(.ewram9) . = ALIGN(4);}
  } = 0xff

  __pad_lma = LOADADDR(.ewram0) + SIZEOF(.ewram0)+SIZEOF(.ewram1)+SIZEOF(.ewram2)+SIZEOF(.ewram3)+SIZEOF(.ewram4)+SIZEOF(.ewram5)+SIZEOF(.ewram6)+SIZEOF(.ewram7)+SIZEOF(.ewram8)+SIZEOF(.ewram9);

	/* EZF Advance strips trailing 0xff bytes, add a pad section so nothing important is removed */
	.pad ALIGN(4) : AT (__pad_lma)
	{
		LONG(0x52416b64)
		LONG(0x4d)
		. = ALIGN(4);  /* REQUIRED. LD is flaky without it. */
	} = 0xff

	__ewram_overlay_end = . ;
	__eheap_start = . ;

	_end = .;
	__end__ = _end ; /* v1.3 */
	PROVIDE (end = _end); /* v1.3 */

	/* Stabs debugging sections.  */
	.stab 0 : { *(.stab) }
	.stabstr 0 : { *(.stabstr) }
	.stab.excl 0 : { *(.stab.excl) }
	.stab.exclstr 0 : { *(.stab.exclstr) }
	.stab.index 0 : { *(.stab.index) }
	.stab.indexstr 0 : { *(.stab.indexstr) }
	.comment 0 : { *(.comment) }
	/*	DWARF debug sections.
		Symbols in the DWARF debugging sections are relative to the beginning
		of the section so we begin them at 0.  */
	/* DWARF 1 */
	.debug          0 : { *(.debug) }
	.line           0 : { *(.line) }
	/* GNU DWARF 1 extensions */
	.debug_srcinfo  0 : { *(.debug_srcinfo) }
	.debug_sfnames  0 : { *(.debug_sfnames) }
	/* DWARF 1.1 and DWARF 2 */
	.debug_aranges  0 : { *(.debug_aranges) }
	.debug_pubnames 0 : { *(.debug_pubnames) }
	/* DWARF 2 */
	.debug_info     0 : { *(.debug_info) }
	.debug_abbrev   0 : { *(.debug_abbrev) }
	.debug_line     0 : { *(.debug_line) }
	.debug_frame    0 : { *(.debug_frame) }
	.debug_str      0 : { *(.debug_str) }
	.debug_loc      0 : { *(.debug_loc) }
	.debug_macinfo  0 : { *(.debug_macinfo) }
	/* SGI/MIPS DWARF 2 extensions */
	.debug_weaknames 0 : { *(.debug_weaknames) }
	.debug_funcnames 0 : { *(.debug_funcnames) }
	.debug_typenames 0 : { *(.debug_typenames) }
	.debug_varnames  0 : { *(.debug_varnames) }
	.stack 0x80000 : { _stack = .; *(.stack) }
	/* These must appear regardless of  .  */
}
