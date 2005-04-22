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
	add	r0, r0, #208
	strh	r0, [r0]

	ldr	r1, =0x00002078			@ disable DTCM and protection unit
	mcr	p15, 0, r1, c1, c0

	ldr	r0, =0x0080000A
	mcr	p15, 0, r0, c9, c1		@ TCM base = 0x00800*4096, size = 16 KB
	mrc	p15, 0, r0, c1, c0		@ throw-away read of cp15.c1
	orr	r1, r1, #0x10000
	mcr	p15, 0, r1, c1, c0		@ cp15.c1 = 0x00012078;

	mov	r0, #0x12			@ Switch to IRQ Mode
	msr	cpsr, r0
	ldr	sp, =__sp_irq			@ Set IRQ stack

	mov	r0, #0x13			@ Switch to SVC Mode
	msr	cpsr, r0
	ldr	sp, =__sp_svc			@ Set SVC stack

	mov	r0, #0x1F			@ Switch to System Mode
	msr	cpsr, r0
	ldr	sp, =__sp_usr			@ Set user stack

	ldr	r0, =__bss_start		@ Clear BSS section to 0x00
	ldr	r1, =__bss_end
	sub	r1, r1, r0
	bl	ClearMem

	ldr	r0, =__sbss_start		@ Clear SBSS section to 0x00
	ldr	r1, =__sbss_end
	sub	r1, r1, r0
	bl	ClearMem

	ldr	r1, =__data_lma			@ Copy initialized data (data section) from LMA to VMA
	ldr	r2, =__data_start
	ldr	r4, =__data_end
	bl	CopyMemCheck

	ldr	r1, =__iwram_lma		@ Copy internal work ram (iwram section) from LMA to VMA
	ldr	r2, =__iwram_start
	ldr	r4, =__iwram_end
	bl	CopyMemCheck

	ldr	r1, =__dtcm_lma			@ Copy data tightly coupled memory from LMA to VMA
	ldr	r2, =__dtcm_start
	ldr	r4, =__dtcm_end
	bl	CopyMemCheck

	ldr	r1, =fake_heap_end		@ set heap end
	ldr	r0, =__eheap_end
	str	r0, [r1]
	
	@ldr	r3, =_init			@ global constructors
	@bx	r3

	mov	r0, #0				@ int argc
	mov	r1, #0				@ char *argv[]
	ldr	r3, =main
	bx	r3
		
@---------------------------------------------------------------------------------
@ If the user ever returns, go to an infinte loop
@---------------------------------------------------------------------------------
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
