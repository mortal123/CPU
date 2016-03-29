.org 0x0
.set noat
.set noreorder
.set nomacro
.global _start

loop:
	li $0, 0
	li $1, 100
	li $2, 0
	li $3, 0
	lw $4, 0($2)
	add $1, $1, -1
	add $2, $2, 4
	add $3, $3, $4
	bne $1, 0, loop
