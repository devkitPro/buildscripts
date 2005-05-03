#include <gccore.h>
#include <malloc.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ogcsys.h>
#include <time.h>

static void *xfb = NULL;

u32 first_frame = 1;
GXRModeObj *rmode;
void (*PSOreload)() = (void(*)())0x80001800;

//---------------------------------------------------------------------------------
int main() {
//---------------------------------------------------------------------------------
	VIDEO_Init();
	
	switch(VIDEO_GetCurrentTvMode())
	{
		case VI_NTSC:
			rmode = &TVNtsc480IntDf;
			break;
		case VI_PAL:
			rmode = &TVPal528IntDf;
			break;
		case VI_MPAL:
			rmode = &TVMpal480IntDf;
			break;
		default:
			rmode = &TVNtsc480IntDf;
			break;
	}

	PAD_Init();
	
	xfb = MEM_K0_TO_K1(SYS_AllocateFramebuffer(rmode));
		
	VIDEO_Configure(rmode);
		
	VIDEO_SetNextFramebuffer(xfb);
	VIDEO_SetBlack(FALSE);
	VIDEO_Flush();
	VIDEO_WaitVSync();
	if(rmode->viTVMode&VI_NON_INTERLACE) VIDEO_WaitVSync();
	VIDEO_SetPreRetraceCallback(PAD_ScanPads);
	console_init(xfb,20,64,rmode->fbWidth,rmode->xfbHeight,rmode->fbWidth*2);
	VIDEO_SetNextFramebuffer(xfb);


	while (1) {

		while ( !(PAD_ButtonsDown(0) & PAD_BUTTON_A)) {
			if (PAD_ButtonsDown(0) & PAD_BUTTON_START) PSOreload();
			VIDEO_WaitVSync();
		}
	}

}
