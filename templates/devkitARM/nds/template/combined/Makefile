#---------------------------------------------------------------------------------
.SUFFIXES:
#---------------------------------------------------------------------------------
include $(DEVKITARM)/ds_rules

export TARGET		:=	template

#---------------------------------------------------------------------------------
# main targets
#---------------------------------------------------------------------------------
.PHONY: arm7/$(TARGET).arm7 arm9/$(TARGET).arm9

$(TARGET).ds.gba	: $(TARGET).nds

$(TARGET).nds	:	arm7/$(TARGET).arm7 arm9/$(TARGET).arm9
	@ndstool	-c $(TARGET).nds -7 arm7/$(TARGET).arm7 -9 arm9/$(TARGET).arm9

arm7/$(TARGET).arm7	:
	@make	-C arm7

arm9/$(TARGET).arm9	:
	@make	-C arm9

clean:
	@make -C arm9 clean
	@make -C arm7 clean

