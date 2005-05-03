#include "gba_interrupt.h"
#include "gba_input.h"

/*---------------------------------------------------------------------------------

	Basic vblank interrupt with key scan & frame counter

---------------------------------------------------------------------------------*/
unsigned int frame = 0;
//---------------------------------------------------------------------------------
void VblankInterrupt()
//---------------------------------------------------------------------------------
{
	frame += 1;
	ScanKeys();
}

//---------------------------------------------------------------------------------
// Program entry point
//---------------------------------------------------------------------------------
int main(void)
//---------------------------------------------------------------------------------
{
	// Set up the interrupt handlers
	InitInterrupt();

	SetInterrupt( Int_Vblank, VblankInterrupt);

	// Enable Vblank Interrupt to allow VblankIntrWait
	EnableInterrupt(Int_Vblank);

	// Allow Interrupts
	REG_IME = 1;

	while (1)
	{
		VBlankIntrWait();
	}
}


