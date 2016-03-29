.org 0x0
.set noat
.set noreorder
.set nomacro
.global _start

_start:
	addi $1, $0, 100
loop:
	lw $4, 0($2)
	addi $1, $1, -1
	addi $2, $2, 4
	add $3, $3, $4
	bne $1, $0, loop
	sw $3, 0($2)
	mul $4, $3, $3
	sw $4, 4($2)
	sub $5, $4, $3
	sw $5, 8($2)
	addi $1, $0, -1
	addi $7, $0, 1
	slt $6, $1, $7
	sw $6, 12($2)
	