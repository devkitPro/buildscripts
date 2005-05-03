//---------------------------------------------------------------------------------
// Simple ARM7 stub (sends RTC, TSC, and X/Y data to the ARM 9)
//---------------------------------------------------------------------------------
#include "nds.h"
#include "nds/bios.h"
#include "nds/arm7/touch.h"
#include "nds/arm7/clock.h"

//---------------------------------------------------------------------------------
void InterruptHandler(void) {
//---------------------------------------------------------------------------------
	int t1, t2;
	static int heartbeat = 0;

	if (IF & IRQ_VBLANK) {
		// Update the heartbeat
		heartbeat++;
		IPC->heartbeat = heartbeat;

		// Read the X/Y buttons and the /PENIRQ line
		IPC->buttons = XKEYS;

		// Read the touch screen
		IPC->touchX = touchRead(TSC_MEASURE_X);
		IPC->touchY = touchRead(TSC_MEASURE_Y);
		IPC->touchZ1 = touchRead(TSC_MEASURE_Z1);
		IPC->touchZ2 = touchRead(TSC_MEASURE_Z2);

		// Read the time
		rtcGetTime((uint8 *)IPC->curtime);
		BCDToInteger((uint8 *)&(IPC->curtime[1]), 7);
 
		// Read the temperature
		IPC->temperature = touchReadTemperature(&t1, &t2);
		IPC->tdiode1 = t1;
   
		IPC->tdiode2 = t2;
	}

  // Acknowledge interrupts
  IF = IF;
}

//---------------------------------------------------------------------------------
int main(int argc, char ** argv) {
//---------------------------------------------------------------------------------
	// Reset the clock if needed
	rtcReset();

	// Set up the interrupt handler
	IME = 0;
	IRQ_HANDLER = &InterruptHandler;
	IE = IRQ_VBLANK;
	IF = ~0;
	DISP_SR = DISP_VBLANK_IRQ;
	IME = 1;

	// Keep the ARM7 out of main RAM
	while (1) swiWaitForVBlank();
	return 0;
}

//////////////////////////////////////////////////////////////////////
