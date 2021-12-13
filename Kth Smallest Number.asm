#Program to find k th smallest number using quick select

.data
newline:	.asciiz	"\n"
prompt:		.asciiz "The kth smallest element is: \n"

len:	.word	10					# Array length
arr:	.word 5, -1, 13, 32, -69, -3, 21, 2, 11, 76
k:		.word 3
answer: .word 0						#to store the kth smallest number
	
.text
 
.globl main

main:
    lw $t0, len						#array length
	la $a0, arr						#array address
	li $a1, 0						#l=0
	sub $a2, $t0, 1					#r=n-1
	lw $a3, k
	
	jal findkthsmall				#call function to compute kth smallest element

	sw $v0, answer					#store the result
	
	la	$a0, prompt					# give prompt
	li	$v0,4				
	syscall	
	
	lw $a0, answer	
	li	$v0,1				
	syscall							#Print the value of kth smallest element
	
	li	$v0,10						#terminate program
	syscall

	
findkthsmall:
	addi $sp, $sp, -20
	sw	$ra, 0($sp)					# Store the return address on the stack
	sw	$a0, 4($sp)					#array address
	sw	$a1, 8($sp)					#l
	sw	$a2, 12($sp)				#r
	sw	$a3, 16($sp)				#k
	
	jal part						#call function to partition
	
	move $s4, $v0					#p
	lw	$s0, 4($sp)					#arr address
	lw	$s1, 8($sp)					#l
	lw	$s2, 12($sp)				#r
	lw	$s3, 16($sp)				#k
	sub $t1, $s4, $s1				#p-l
	addi $t1, $t1, 1				#p-l+1
	
	beq $s3, $t1, foundkthsmall		#if(k==p-l+1)
	
	bgt $s3, $t1, right				#if(k>p-l+1) 
	
	move $a0, $s0					#arr address
	move $a1, $s1					#l
	sub $a2, $s4, 1					#p-1
	move $a3, $s3					#k
	jal findkthsmall				#recur on the left side of partition
	j endfindkthsmall
	
right:
	move $a0, $s0					#arr address
	addi $a1, $s4, 1				#p+1
	move $a2, $s2					#r
	sub $a3, $s3, $t1				#k-(p-l+1)
	
	jal findkthsmall				#recur on the right side of partition
	j endfindkthsmall
	
foundkthsmall:
	mul $t2, $s4, 4
	add $t3, $t2, $s0				#address of arr[p]
	lw $v0, 0($t3)					#arr[p]

endfindkthsmall:	
	lw	$ra, 0($sp)					# Load the return address from the stack
	addi	$sp, $sp, 20			# Adjust the stack pointer
	jr	$ra							# Return 
	
	
part:
	addi $sp, $sp, -16
	sw	$ra, 0($sp)					# Store the return address on the stack
	sw	$a0, 4($sp)					#arr address
	sw	$a1, 8($sp)					#l
	sw	$a2, 12($sp)				#r
	
	lw	$s0, 4($sp)					#arr address
	lw	$s1, 8($sp)					#l
	lw	$s2, 12($sp)				#r
	
	
	mul $t2, $s2, 4
	add $t3, $t2, $s0				#address of arr[r]
	lw $t4, 0($t3)					#last=arr[r]
	move $t0, $s1					#j=l
	move $t1, $s1					#i=l
	
forloop:
	beq, $t1, $s2, endfor
	mul $t5, $t1, 4
	add $t6, $t5, $s0				#address of arr[i]
	lw $t7, 0($t6)					#arr[i]
	
	mul $t5, $t0, 4
	add $t8, $t5, $s0				#address of arr[j]
	lw $t9, 0($t8)					#arr[j]
	
	bgt $t7, $t4, endif				#endif when arr[i]>last
	move $a0, $t6					#address of arr[i]
	move $a1, $t8					#address of arr[j]
	
	jal swap						#call swap function
	addi $t0, $t0, 1				#j++
	
endif:	
	addi $t1,$t1,1					#i++
	j forloop
	
endfor:
    mul $t5, $t0, 4
	add $t8, $t5, $s0				#address of arr[j]
	lw $t9, 0($t8)				    #arr[j]
	move $a0, $t8					#address of arr[j]
	move $a1, $t3					#address of arr[r]
	jal swap						#call swap(arr[j],arr[r])
	
	move $v0, $t0					#store j to return

	lw	$ra, 0($sp)					# Load the return address from the stack
	addi $sp, $sp, 16				# Adjust the stack pointer
	jr	$ra							# Return 	
	
	
swap:
	lw $s4, 0($a0)
	lw $s5, 0($a1)
	sw $s4, 0($a1)
	sw $s5, 0($a0)
	jr $ra
	
	