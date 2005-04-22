PREFIX			:=	arm-elf-
export CC		:=	$(PREFIX)gcc
export CXX		:=	$(PREFIX)g++
export AR		:=	$(PREFIX)ar
export OBJCOPY	:=	$(PREFIX)objcopy

all:
	$(CC)  -x assembler-with-cpp -marm -c $(CRT)_crt0.s -o$(CRT)_crt0.o
	$(CC)  -x assembler-with-cpp -marm -mthumb-interwork -c $(CRT)_crt0.s -o interwork/$(CRT)_crt0.o
	$(CC)  -x assembler-with-cpp -mthumb -c $(CRT)_crt0.s -o thumb/$(CRT)_crt0.o
	$(CC)  -x assembler-with-cpp -mthumb -mthumb-interwork -c $(CRT)_crt0.s -o thumb/interwork/$(CRT)_crt0.o
