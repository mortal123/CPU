
MIPS.om:     file format elf32-tradbigmips

Disassembly of section .text:

00000000 <loop>:
   0:	24000000 	li	zero,0
   4:	24010064 	li	at,100
   8:	24020000 	li	v0,0
   c:	24030000 	li	v1,0
  10:	8c440000 	lw	a0,0(v0)
  14:	2021ffff 	addi	at,at,-1
  18:	20420004 	addi	v0,v0,4
  1c:	00641820 	add	v1,v1,a0
  20:	1420fff7 	bnez	at,0 <loop>
Disassembly of section .reginfo:

00000000 <_ram_end-0x30>:
   0:	0000001e 	0x1e
	...
