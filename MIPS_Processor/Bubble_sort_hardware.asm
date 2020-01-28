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
addi $s0, $t3, 0
#stores all the values
sw $s1, 0($s0)
sw $s2, 1($s0)
sw $s3, 2($s0)
sw $s4, 3($s0)
sw $s5, 4($s0)
sw $s6, 5($s0)



outer_loop:
addi $t1, $0, 0  #index_inner set to 0
#mem addr for the values
lui $t3, 0x1001
addi $s0, $t3, 0

inner_loop:
lw $t6, 0($s0)
addi $s0, $s0, 1
lw $t7, 0($s0)

slt $t4, $t7, $t6 #checks to see if t6 is greater then t7/ first is larger then second

bne $t4, $0 ,swap	# branches to swap if t4

pickup: #location to jump to after swap has been made

addi $t1, $t1, 1 #increment
bne $t1, $t2, inner_loop # repeat inner_loop 

addi $t0, $t0, 1#increment
bne $t0, $t2, outer_loop # repeat outer_loop 

addi $v0, $0, 10 #end
syscall


swap: #t6,t7 are inputs
add $t9, $t6, $0 #t9 is the temp varible
add $t7, $t6, $0
add $t6, $t9, $0

addi $s0, $s0, -1 # stores values after they have been swaped if needed
sw $t6, 0($s0)
addi $s0, $s0, 1
sw $t7, 0($s0)
j pickup
