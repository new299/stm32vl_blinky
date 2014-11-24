CC=arm-none-eabi-gcc 
CP=arm-none-eabi-objcopy
LD=arm-none-eabi-ld
OD=arm-none-eabi-objdump

CFLAGS  =  -I./ -c -fno-common -Os -mcpu=cortex-m3 -mthumb
LFLAGS  = -Tstm32.ld -nostartfiles
CPFLAGS = -Obinary
ODFLAGS = -S

.PHONY: blinky

all: blinky

blinky: blinky.elf

all: test

clean:
	-rm -f blinky.lst blinky.o blinky.elf blinky.lst blinky.bin

test: blinky.elf
	@ echo "...copying"
	$(CP) $(CPFLAGS) blinky.elf blinky.bin
	$(OD) $(ODFLAGS) blinky.elf > blinky.lst

blinky.elf: blinky.o stm32.ld 
	@ echo "..linking"
	$(LD) $(LFLAGS) -o blinky.elf blinky.o    
	$(CP) $(CPFLAGS) blinky.elf blinky.bin

blinky.o: blinky.c
	@ echo ".compiling"
	$(CC) $(CFLAGS) blinky.c

burn: blinky
	st-flash write blinky.bin 0x8000000

