
MIPS.om:     file format elf32-tradbigmips

Disassembly of section .text:

00000000 <_start>:
   0:	20010064 	addi	at,zero,100

00000004 <loop>:
   4:	8c440000 	lw	a0,0(v0)
   8:	2021ffff 	addi	at,at,-1
   c:	20420004 	addi	v0,v0,4
  10:	00641820 	add	v1,v1,a0
  14:	1420fffb 	bnez	at,4 <loop>
  18:	ac430000 	sw	v1,0(v0)
  1c:	70632002 	mul	a0,v1,v1
  20:	ac440004 	sw	a0,4(v0)
  24:	00832822 	sub	a1,a0,v1
  28:	ac450008 	sw	a1,8(v0)
  2c:	2001ffff 	addi	at,zero,-1
  30:	20070001 	addi	a3,zero,1
  34:	0027302a 	slt	a2,at,a3
  38:	ac46000c 	sw	a2,12(v0)
Disassembly of section .reginfo:

00000000 <_ram_end-0x40>:
   0:	000000fe 	0xfe
	...
