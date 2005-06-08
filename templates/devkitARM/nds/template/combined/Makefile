#---------------------------------------------------------------------------------
.SUFFIXES:
#---------------------------------------------------------------------------------
-include $(DEVKITARM)/ds_rules

export TARGET		:=	template

#---------------------------------------------------------------------------------
# main targets
#---------------------------------------------------------------------------------
.PHONY: $(TARGET).nds

$(TARGET).ds.gba	: $(TARGET).nds

$(TARGET).nds	:
	@make	-C arm7
	@make	-C arm9
	@ndstool	-c $(TARGET).nds -7 arm7/$(TARGET).arm7 -9 arm9/$(TARGET).arm9

clean:
	@make -C arm9 clean
	@make -C arm7 clean

