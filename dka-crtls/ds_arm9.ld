OUTPUT_FORMAT("elf32-littlearm", "elf32-bigarm", "elf32-littlearm")
OUTPUT_ARCH(arm)
ENTRY(_start)

MEMORY {

	rom		: ORIGIN = 0x08000000, LENGTH = 32M
	iwram	: ORIGIN = 0x037f8000, LENGTH = 32K
	ewram	: ORIGIN = 0x02000000, LENGTH = 4M - 4k
	dtcm	: ORIGIN = 0x00800000, LENGTH = 16K
	itcm	: ORIGIN = 0x01000000, LENGTH = 32K
}

__itcm_start	=	0x01000000;
__iwram_start	=	0x037f8000;
__iwram_end		=	0x03800000;
__ewram_end		=	0x02400000;
__eheap_end		=	0x023ff000;
__dtcm_start	=	0x00800000;
__dtcm_end		=	0x00804000;

__sp_svc	=	__dtcm_end - 0x100;
__sp_irq	=	__sp_svc - 0x100;
__sp_usr	=	__sp_irq - 0x100;

SECTIONS
{
	.init	:
	{
		__text_start = . ;
		KEEP (*(.init))
		. = ALIGN(4);  /* REQUIRED. LD is flaky without it. */
		} >ewram = 0xff
	.plt : { *(.plt) } >ewram = 0xff

	.text :   /* ALIGN (4): */
	{

		*(.text.*)
		*(.stub)
		/* .gnu.warning sections are handled specially by elf32.em.  */
		*(.gnu.warning)
		*(.gnu.linkonce.t*)
		*(.glue_7)
		*(.glue_7t)
		. = ALIGN(4);  /* REQUIRED. LD is flaky without it. */
	} >ewram = 0xff

	.fini           :
	{
		KEEP (*(.fini))
	} >ewram =0xff

	__text_end = . ;

	.rodata :
	{
		*(.rodata)
		*all.rodata*(*)
		*(.roda)
		*(.rodata.*)
		*(.gnu.linkonce.r*)
		SORT(CONSTRUCTORS)
		. = ALIGN(4);   /* REQUIRED. LD is flaky without it. */
	} >ewram = 0xff

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
	} >ewram = 0xff

	.dtors :
	{
		KEEP (*crtbegin.o(.dtors))
		KEEP (*(EXCLUDE_FILE (*crtend.o) .dtors))
		KEEP (*(SORT(.dtors.*)))
		KEEP (*(.dtors))
		. = ALIGN(4);   /* REQUIRED. LD is flaky without it. */
	} >ewram = 0xff

	.eh_frame :
	{
		KEEP (*(.eh_frame))
		. = ALIGN(4);   /* REQUIRED. LD is flaky without it. */
	} >ewram = 0xff

	.gcc_except_table :
	{
		*(.gcc_except_table)
		. = ALIGN(4);   /* REQUIRED. LD is flaky without it. */
	} >ewram = 0xff
	.jcr            : { KEEP (*(.jcr)) } >ewram = 0
	.got            : { *(.got.plt) *(.got) } >ewram = 0

	.sbss ALIGN(4):
 	{
		__sbss_start = ABSOLUTE(.);
 		*(.sbss)
 		. = ALIGN(4);
 	}
	__sbss_end = . ;

	_end = . ;
	__end__ = . ;
	PROVIDE (end = _end);

	__iwram_lma = . ;

	.iwram __iwram_start : AT (__iwram_lma)
	{
		__iwram_start = ABSOLUTE(.) ;
		*(.iwram)
		*iwram.*(.text)
		. = ALIGN(4);   /* REQUIRED. LD is flaky without it. */
	} >iwram = 0xff

	__iwram_end = . ;

	__dtcm_lma = __iwram_lma + SIZEOF(.iwram);

	.dtcm __dtcm_start : AT (__dtcm_lma)
	{
		__dtcm_start = ABSOLUTE(.);
		*(.dtcm)
		*(.dtcm.*)
		. = ALIGN(4);
	} >dtcm = 0xff
	__dtcm_end = . ;

	__data_lma = __dtcm_lma + SIZEOF(.dtcm) ;

	.data ALIGN(4) : AT (__data_lma)
	{
		__data_start = ABSOLUTE(.);
		*(.data)
		*(.data.*)
		*(.gnu.linkonce.d*)
		CONSTRUCTORS
		. = ALIGN(4);
	} >dtcm = 0xff

	__data_end = . ;

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

	__itcm_lma = __data_lma + SIZEOF(.data);

	.itcm __itcm_start : AT (__itcm_lma)
	{
		__itcm_start = ABSOLUTE(.);
		*(.itcm)
		*(.itcm.*)
		. = ALIGN(4);
	} >itcm = 0xff
	__itcm_end = . ;

	__appended_data = __itcm_lma + SIZEOF(.itcm) ;



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
