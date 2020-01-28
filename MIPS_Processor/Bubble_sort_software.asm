# data section
.data


# code/instruction section
.text


addi $t0, $0, 0  #index_outer
addi $t1, $0, 0  #index_inner
addi $t2, $0, 5  #max values count starting at 0 

#values to be sorted
addi $s1, $0, 7
addi $s2, $0, 4
addi $s3, $0, 5
addi $s4, $0, 2
addi $s5, $0, 1
addi $s6, $0, 9

#mem addr for the values to be sorted
lui $t3, 0x1001
nop
nop
nop
nop
addi $s0, $t3, 0
nop
nop
nop
nop
#stores all the values
sw $s1, 0($s0)
sw $s2, 4($s0)
sw $s3, 8($s0)
sw $s4, 12($s0)
sw $s5, 16($s0)
sw $s6, 20($s0)
nop
nop
nop
nop


outer_loop:
nop
nop
nop
nop
addi $t1, $0, 0  #index_inner set to 0
#mem addr for the values
lui $t3, 0x1001
nop
nop
nop
addi $s0, $t3, 0
nop
nop
nop

inner_loop:
nop
nop
nop
nop
lw $t6, 0($s0)
addi $s0, $s0, 4
nop
nop
nop

lw $t7, 0($s0)
nop
nop
nop

slt $t4, $t7, $t6 #checks to see if t6 is greater then t7/ first is larger then second
nop
nop
nop

bne $t4, $0 ,swap	# branches to swap if t4
nop

pickup: #location to jump to after swap has been made

addi $t1, $t1, 1 #increment
nop
nop
nop
bne $t1, $t2, inner_loop # repeat inner_loop 
nop

addi $t0, $t0, 1#increment
nop
nop
nop
bne $t0, $t2, outer_loop # repeat outer_loop 
nop

addi $v0, $0, 10 #end
nop
nop
nop

syscall


swap: #t6,t7 are inputs
add $t9, $t7, $0 #t9 is the temp varible
add $t7, $t6, $0

nop
nop
add $t6, $t9, $0

addi $s0, $s0, -4 # stores values after they have been swaped if needed
nop
nop
nop
sw $t6, 0($s0)
addi $s0, $s0,4
nop
nop
nop
sw $t7, 0($s0)
j pickup
nop
nop
nop
nop
