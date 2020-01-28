#
# test for phase 1
#

# data section
.data
fibs:.word   0 : 19         # "array" of words to contain fib values

# code/instruction section
.text

addi  $1,  $0,  1 		# Place “1" in $1
addi  $2,  $0,  2		# Place “2" in $2
addi  $3,  $0,  3		# Place “3" in $3
addi  $4,  $0,  4		# Place “4" in $4
addi  $5,  $0,  5		# Place “5" in $5
addi  $6,  $0,  6		# Place “6" in $6
addi  $7,  $0,  7		# Place “7" in $7
addi  $8,  $0,  8		# Place “8" in $8
addi  $9,  $0,  9		# Place “9" in $9
addi  $10, $0,  10		# Place “10" in $10

add	$11, $9, $10			# $11 = 1 + 2

addiu $12, $11, 0x8

addu $12, $12, $3

sub $12, $11, $11		# $12 = 3 - 3

lui $15, 0x1001

subu $12, $3, $11

and $12, $3, $11		# $12 = $3 and $11
or $13, $1, $3			# $13 = $1 or $3 should = 3
or $13, $1, $4			# $13 = $1 or $4 should = 5

andi $12, $1, 1			
ori $14, $2, 1
	

nor $11, $15, $10

xor $12, $1, $3

xori $13, $15, 0x4

slt $14, $4, $7

addi  $16, $15, 0x000c	

slti $13, $3, 0x4

sltiu $12, $3, 0x8

sltu $11, $3, $4

sll $12, $3, 0x1
srl $13, $12, 0x1
sra $14, $13, 0x1

sllv $15, $3, $1
srlv $14, $14, $1
srav $13, $15, $1



beq $1, $1, BEQCheck

add $2, $1, $1

BEQCheck:  add $5, $2, $3



j HEHEHAHA

addi $1, $1, 0x0

HEHEHAHA: add $7, $2, $5



bne $1, $2, BypassJR



addi $0, $0, 0


BypassJR: add $1, $1, $0


sw $5, 0($16)

lw $15, 0($16)



addi  $2,  $0,  10              # Place "10" in $v0 to signal an "exit" or "halt"
syscall                         # Actually cause the halt
