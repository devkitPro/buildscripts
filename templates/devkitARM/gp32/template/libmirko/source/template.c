// written 2004	Mirko Roller   mirko@mirkoroller.de
// Example shows you how to	setup 256 color	mode

#include "gp32.h"
#include <stdio.h>
#include <stdlib.h>

u8	*framebuffer;
u16	palette[256];

int main()	{

	int	x;

	framebuffer	= (u8*)	FRAMEBUFFER;   // 0x0C7B4000

	gp_setCpuspeed(40);
	gp_initFramebuffer(framebuffer,8,85);

	// Palette format: %RRRRRGGGGGBBBBBI (5551)
	// I : Intensity Bit 1=on 0=off

	for	(x=0;x<32;x++)		palette[x] =(x<<1);
	for	(x=32;x<64;x++)		palette[x] =((63-x)<<1);
	for	(x=64;x<256;x++)	palette[x] =0x0;

	gp_drawString(50,110,23,"Hello World",255,(void *)framebuffer);

	while (1);

}

