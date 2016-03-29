ifndef CROSS_COMPILE
CROSS_COMPILE = mips-sde-elf-
endif
CC = $(CROSS_COMPILE)as
LD = $(CROSS_COMPILE)ld
OBJCOPY = $(CROSS_COMPILE)objcopy
OBJDUMP = $(CROSS_COMPILE)objdump

OBJECTS = MIPS.o

export	CROSS_COMPILE

# ********************
# Rules of Compilation
# ********************

all: MIPS.om MIPS.bin MIPS.asm MIPS.data

%.o: %.S
	$(CC) -mips32 $< -o $@
MIPS.om: ram.ld $(OBJECTS)
	$(LD) -T ram.ld $(OBJECTS) -o $@
MIPS.bin: MIPS.om
	$(OBJCOPY) -O binary $<  $@
MIPS.asm: MIPS.om
	$(OBJDUMP) -D $< > $@
MIPS.data: MIPS.bin
	./Bin2Mem.exe -f $< -o $@
clean:
	rm -f *.o *.om *.bin *.data *.mif *.asm
