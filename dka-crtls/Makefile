PREFIX			:=	arm-elf-
export CC		:=	$(PREFIX)gcc
export CXX		:=	$(PREFIX)g++
export AR		:=	$(PREFIX)ar
export OBJCOPY	:=	$(PREFIX)objcopy

all:
	$(CC)  -marm -c $(CRT).s -o$(CRT).o
	$(CC)  -marm -mthumb-interwork -c $(CRT).s -o interwork/$(CRT).o
	$(CC)  -mthumb -c $(CRT).s -o thumb/$(CRT).o
	$(CC)  -mthumb -mthumb-interwork -c $(CRT).s -o thumb/interwork/$(CRT).o
