.org 0x0
.set noat
.set noreorder
.set nomacro
.global _start


	addi $1, $0, 100
loop:
	lw $4, 0($2)
	addi $1, $1, -1
	addi $2, $2, 4
	add $3, $3, $4
	bne $1, $0, loop
