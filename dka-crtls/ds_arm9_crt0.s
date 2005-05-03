#define PAGE_4K		(0b01011 << 1)
#define PAGE_8K		(0b01100 << 1)
#define PAGE_16K	(0b01101 << 1)
#define PAGE_32K	(0b01110 << 1)
#define PAGE_64K	(0b00111 << 1)
#define PAGE_128K	(0b10000 << 1)
#define PAGE_256K	(0b10001 << 1)
#define PAGE_512K	(0b10010 << 1)
#define PAGE_1M		(0b10011 << 1)
#define PAGE_2M		(0b10100 << 1)
#define PAGE_4M		(0b10101 << 1)
#define PAGE_8M		(0b10110 << 1)
#define PAGE_16M	(0b10111 << 1)
#define PAGE_32M	(0b11000 << 1)
#define PAGE_64M	(0b11001 << 1)
#define PAGE_128M	(0b11010 << 1)
#define PAGE_256M	(0b11011 << 1)
#define PAGE_512M	(0b11100 << 1)
#define PAGE_1G		(0b11101 << 1)
#define PAGE_2G		(0b11110 << 1)
#define PAGE_4G		(0b11111 << 1)

@---------------------------------------------------------------------------------
	.section ".init"
	.global _start
@---------------------------------------------------------------------------------
	.align	4
	.arm
@---------------------------------------------------------------------------------
_start:
@---------------------------------------------------------------------------------
	mov	r0, #0x04000000			@ IME = 0;
	add	r0, r0, #0x208
	strh	r0, [r0]

	mov	r1,#0				@ enable arm9 iwram
	strb	r1,[r0, #(0x247 - 0x208)]

	ldr	r1, =0x00002078			@ disable DTCM and protection unit
	mcr	p15, 0, r1, c1, c0

@---------------------------------------------------------------------------------
@ Protection Unit Setup added by Sasq
@---------------------------------------------------------------------------------
	@ Disable cache
	mov	r0, #0
	mcr	p15, 0, r0, c7, c5, 0		@ Instruction cache
	mcr	p15, 0, r0, c7, c6, 0		@ Data cache

	@ Wait for write buffer to empty 
	mcr	p15, 0, r0, c7, c10, 4

	ldr	r0, =0x0080000A
	mcr	p15, 0, r0, c9, c1		@ TCM base = 0x00800*4096, size = 16 KB
@---------------------------------------------------------------------------------
@ Setup memory regions similar to Release Version
@	this code currently breaks dualis
@---------------------------------------------------------------------------------

	@-------------------------------------------------------------------------
	@ Region 0 - IO registers
	@-------------------------------------------------------------------------
	ldr	r0,=( PAGE_64M | 0x04000000 | 1)	
	mcr	p15, 0, r0, c6, c0, 0

	@-------------------------------------------------------------------------
	@ Region 1 - Main Memory
	@-------------------------------------------------------------------------
	ldr	r0,=( PAGE_4M | 0x02000000 | 1)	
	mcr	p15, 0, r0, c6, c1, 0

	@-------------------------------------------------------------------------
	@ Region 2 - iwram
	@-------------------------------------------------------------------------
	ldr	r0,=( PAGE_32K | 0x037F8000 | 1)	
	mcr	p15, 0, r0, c6, c2, 0

	@-------------------------------------------------------------------------
	@ Region 3 - DS Accessory
	@-------------------------------------------------------------------------
	ldr	r0,=( PAGE_128M | 0x08000000 | 1)	
	mcr	p15, 0, r0, c6, c3, 0

	@-------------------------------------------------------------------------
	@ Region 4 - DTCM
	@-------------------------------------------------------------------------
	@ldr	r0,=( PAGE_16K | 0x027C0000 | 1)	
	ldr	r0,=( PAGE_16K | 0x00800000 | 1)	
	mcr	p15, 0, r0, c6, c4, 0

	@-------------------------------------------------------------------------
	@ Region 5 - ITCM
	@-------------------------------------------------------------------------
	ldr	r0,=( PAGE_32K | 0x01000000 | 1)	
	mcr	p15, 0, r0, c6, c5, 0

	@-------------------------------------------------------------------------
	@ Region 6 - System ROM
	@-------------------------------------------------------------------------
	ldr	r0,=( PAGE_32K | 0xFFFF0000 | 1)	
	mcr	p15, 0, r0, c6, c6, 0

	@-------------------------------------------------------------------------
	@ Region 7 - IPC
	@-------------------------------------------------------------------------
	ldr	r0,=( PAGE_4K  | 0x027FF000 | 1)	
	mcr	p15, 0, r0, c6, c7, 0

	@-------------------------------------------------------------------------
	@ Write buffer enable
	@-------------------------------------------------------------------------
	ldr	r0,=0b00000110
	mcr	p15, 0, r0, c3, c0, 0

	@-------------------------------------------------------------------------
	@ DCache & ICache enable
	@-------------------------------------------------------------------------
	ldr	r0,=0b01000110
	ldr	r0,=0x42
	mcr	p15, 0, r0, c2, c0, 0
	mcr	p15, 0, r0, c2, c0, 1

	@-------------------------------------------------------------------------
	@ IAccess
	@-------------------------------------------------------------------------
	ldr	r0,=0x06300333
	mcr	p15, 0, r0, c5, c0, 3

	@-------------------------------------------------------------------------
	@ DAccess
	@-------------------------------------------------------------------------
	ldr	r0,=0x36633333
	mcr     p15, 0, r0, c5, c0, 2

	@-------------------------------------------------------------------------
	@ Enable ICache, DCache, ITCM & DTCM
	@-------------------------------------------------------------------------
	mrc	p15, 0, r0, c1, c0, 0
	ldr	r1,=0x55005
	orr	r0,r0,r1
	mcr	p15, 0, r0, c1, c0, 0

	mov	r0, #0x12		@ Switch to IRQ Mode
	msr	cpsr, r0
	ldr	sp, =__sp_irq		@ Set IRQ stack

	mov	r0, #0x13		@ Switch to SVC Mode
	msr	cpsr, r0
	ldr	sp, =__sp_svc		@ Set SVC stack

	mov	r0, #0x1F		@ Switch to System Mode
	msr	cpsr, r0
	ldr	sp, =__sp_usr		@ Set user stack

	ldr	r1, =__data_lma		@ Copy initialized data (data section) from LMA to VMA (ROM to RAM)
	ldr	r2, =__data_start
	ldr	r4, =__data_end
	bl	CopyMemCheck

	ldr	r1, =__iwram_lma	@ Copy internal work ram (iwram section) from LMA to VMA (ROM to RAM)
	ldr	r2, =__iwram_start
	ldr	r4, =__iwram_end
	bl	CopyMemCheck

	ldr	r1, =__itcm_lma		@ Copy instruction tightly coupled memory (itcm section) from LMA to VMA (ROM to RAM)
	ldr	r2, =__itcm_start
	ldr	r4, =__itcm_end
	bl	CopyMemCheck

	ldr	r1, =__dtcm_lma		@ Copy data tightly coupled memory (dtcm section) from LMA to VMA (ROM to RAM)
	ldr	r2, =__dtcm_start
	ldr	r4, =__dtcm_end
	bl	CopyMemCheck

	ldr	r0, =__bss_start	@ Clear BSS section
	ldr	r1, =__bss_end
	sub	r1, r1, r0
	bl	ClearMem

	ldr	r0, =__sbss_start	@ Clear SBSS section 
	ldr	r1, =__sbss_end
	sub	r1, r1, r0
	bl	ClearMem

	ldr	r1, =fake_heap_end	@ set heap end
	ldr	r0, =__eheap_end
	str	r0, [r1]
	
	ldr	r3, =_init		@ global constructors
	bl	_call_via_r3

	mov	r0, #0			@ int argc
	mov	r1, #0			@ char *argv[]
	ldr	r3, =main
	bl	_call_via_r3		@ jump to user code
		
	@ If the user ever returns, go to an infinte loop
	ldr	r0, =ILoop
	ldr	r0, [r0]
	ldr	r1, =0x027FFE78
	str	r0, [r1]
	bx	r1
ILoop:
	b	ILoop

@---------------------------------------------------------------------------------
@ Clear memory to 0x00 if length != 0
@  r0 = Start Address
@  r1 = Length
@---------------------------------------------------------------------------------
ClearMem:
@---------------------------------------------------------------------------------
	mov	r2, #3			@ Round down to nearest word boundary
	add	r1, r1, r2		@ Shouldn't be needed
	bics	r1, r1, r2		@ Clear 2 LSB (and set Z)
	bxeq	lr			@ Quit if copy size is 0

	mov	r2, #0
ClrLoop:
	stmia	r0!, {r2}
	subs	r1, r1, #4
	bne	ClrLoop

	bx	lr

@---------------------------------------------------------------------------------
@ Copy memory if length	!= 0
@  r1 = Source Address
@  r2 = Dest Address
@  r4 = Dest Address + Length
@---------------------------------------------------------------------------------
CopyMemCheck:
@---------------------------------------------------------------------------------
	sub	r3, r4, r2		@ Is there any data to copy?
@---------------------------------------------------------------------------------
@ Copy memory
@  r1 = Source Address
@  r2 = Dest Address
@  r3 = Length
@---------------------------------------------------------------------------------
CopyMem:
@---------------------------------------------------------------------------------
	mov	r0, #3			@ These commands are used in cases where
	add	r3, r3, r0		@ the length is not a multiple of 4,
	bics	r3, r3, r0		@ even though it should be.
	bxeq	lr			@ Length is zero, so exit
CIDLoop:
	ldmia	r1!, {r0}
	stmia	r2!, {r0}
	subs	r3, r3, #4
	bne	CIDLoop

	bx	lr
@---------------------------------------------------------------------------------
	.align
	.pool
	.end
@---------------------------------------------------------------------------------
