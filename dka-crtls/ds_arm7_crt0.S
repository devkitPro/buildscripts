.section ".init"
.global _start

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

.align	4
.arm

_start:
		mov	r0, #0x04000000			@ IME = 0;
		add	r0, r0, #0x208
		strh	r0, [r0]

		mov	r0, #0x12			@ Switch to IRQ Mode
		msr	cpsr, r0
		ldr	sp, =__sp_irq			@ Set IRQ stack

		mov	r0, #0x1F			@ Switch to System Mode
		msr	cpsr, r0
		ldr	sp, =__sp_usr			@ Set user stack

		ldr	r0, =__bss_start		@ Clear BSS section to 0x00
		ldr	r1, =__bss_end
		sub	r1, r1, r0
		bl	ClearMem

		ldr	r1, =__data_lma			@ Copy initialized data (data section) from LMA to VMA (ROM to RAM)
		ldr	r2, =__data_start
		ldr	r4, =__data_end
		bl	CopyMemCheck

		ldr	r1, =__iwram_lma		@ Copy internal work ram (iwram section) from LMA to VMA (ROM to RAM)
		ldr	r2, =__iwram_start
		ldr	r4, =__iwram_end
		bl	CopyMemCheck

		ldr	r2, =__load_stop_iwram0		@ Copy internal work ram overlay 0 (iwram0 section) from LMA to VMA (ROM to RAM)
		ldr	r1, =__load_start_iwram0
		subs	r3, r2, r1			@ Is there any data to copy?
		beq	CIW0Skip			@ no
		ldr	r2, =__iwram_overlay_start
		bl	CopyMem
CIW0Skip:
		ldr	r1, =__ewram_lma		@ Copy external work ram (ewram section) from LMA to VMA (ROM to RAM)
		ldr	r2, =__ewram_start
		ldr	r4, =__ewram_end
		bl	CopyMemCheck

		ldr	r2, =__load_stop_ewram0	@ 	@ Copy external work ram overlay 0 (ewram0 section) from LMA to VMA (ROM to RAM)
		ldr	r1, =__load_start_ewram0
		subs	r3, r2, r1			@ Is there any data to copy?
		beq	CEW0Skip			@ no
		ldr	r2, =__ewram_overlay_start
		bl	CopyMem
CEW0Skip:
		ldr	r1, =fake_heap_end		@ set heap end
		ldr	r0, =__eheap_end
		str	r0, [r1]
	
		ldr	r3, =_init			@ global constructors
		bl	_call_via_r3

		mov	r0, #0				@ int argc
		mov	r1, #0				@ char *argv[]
		ldr	r3, =main
		bl	_call_via_r3			@ jump to user code
		
		@ If the user ever returns, return to flash cartridge
		mov	r0, #0x08000000
		bx	r0

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@
@ Clear memory to 0x00 if length != 0
@  r0 = Start Address
@  r1 = Length
@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

ClearMem:	mov	r2, #3			@ Round down to nearest word boundary
		add	r1, r1, r2		@ Shouldn't be needed
		bics	r1, r1, r2		@ Clear 2 LSB (and set Z)
		bxeq	lr			@ Quit if copy size is 0

		mov	r2, #0
ClrLoop:	stmia	r0!, {r2}
		subs	r1, r1, #4
		bne	ClrLoop

		bx	lr

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@
@ Copy memory if length	!= 0
@  r1 = Source Address
@  r2 = Dest Address
@  r4 = Dest Address + Length
@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

CopyMemCheck:
		sub	r3, r4, r2		@ Is there any data to copy?

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@
@ Copy memory
@  r1 = Source Address
@  r2 = Dest Address
@  r3 = Length
@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

CopyMem:	mov	r0, #3			@ These commands are used in cases where
		add	r3, r3, r0		@ the length is not a multiple of 4,
		bics	r3, r3, r0		@ even though it should be.
		bxeq	lr			@ Length is zero, so exit

CIDLoop:	ldmia	r1!, {r0}
		stmia	r2!, {r0}
		subs	r3, r3, #4
		bne	CIDLoop

		bx	lr

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

.align
.pool

.end
