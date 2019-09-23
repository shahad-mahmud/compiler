#start
.text
.globl main
main:
addiu $t7, $sp, 160

#store
sw $a0, 0($t7)

#store
sw $a0, 16($t7)

#ld_int_value
li $a0, 3

#store
sw $a0, 32($t7)

#store
sw $a0, 48($t7)

#store
sw $a0, 64($t7)

#halt
li $v0, 10
syscall
