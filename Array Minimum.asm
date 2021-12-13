.data 
    array: .word 1 , -100, 25, 255 , 77 , 14, 564, 21, 11, 18   
    minprompt: .asciiz " is the minimum number."
.text

.globl main

main:  la $t1, array # array starting address
       la $t0, array
	   li $s1, 0 # loop index, i=0
       li $s2, 8 
	   addi $t2,$t1,4
	   
       
for:  blt $s2,$s1, endf # end when $s2< $s1
      jal swap
	  addi $t1,$t1,4
	  addi $t2,$t2,4
	  addi $s1,$s1,1
	  j for
	   
endf:   
        lw $t4, 36($t0)
		li $v0, 1
		move $a0,$t4
        syscall
	    li $v0, 4 
	    la $a0, minprompt
	    syscall
        li $v0, 10			# endof program
	    syscall

swap: lw $t3,0($t1)
      lw $t4, 0($t2)
	  blt $t4,$t3, endofswap
	  sw $t3, 0($t2)
	  sw $t4, 0($t1)
	  endofswap:
	  jr $ra
