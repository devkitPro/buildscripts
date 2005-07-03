//---------------------------------------------------------------------------------
#include "nds.h"

//---------------------------------------------------------------------------------
void irqVBlank(void) {	
//---------------------------------------------------------------------------------
    IF = IF;
}

eroe


eprpweor

//---------------------------------------------------------------------------------
int main(void) {
//---------------------------------------------------------------------------------
	static int screen =0;
	u16* back = VRAM_A;
	u16* front = VRAM_B;

	//turn on the power to the system
	powerON(POWER_ALL);

	//set main display to render directly from the frame buffer
	videoSetMode(MODE_FB1);
	
	//set up the sub display
	videoSetModeSub(MODE_0_2D | 
					DISPLAY_SPR_1D_LAYOUT | 
					DISPLAY_SPR_ACTIVE | 
					DISPLAY_BG0_ACTIVE |
					DISPLAY_BG1_ACTIVE );
	
	//vram banks are somewhat complex
	vramSetMainBanks(VRAM_A_LCD, VRAM_B_LCD, VRAM_C_SUB_BG, VRAM_D_SUB_SPRITE);
	
	//irqs are nice..ndslib comes with a very unoptimised default handler
	irqInitHandler(irqDefaultHandler);
	irqSet(IRQ_VBLANK, irqVBlank);

	while (1) {
		
		swiWaitForVBlank();

		//flip screens
		if(screen) {
			videoSetMode(MODE_FB1);
			front = VRAM_B;
			back = VRAM_A;
			screen = 0;
		} else {
			videoSetMode(MODE_FB0);	
			front = VRAM_A;
			back = VRAM_B;
			screen = 1;
		}
	}    
	return 0;
}

