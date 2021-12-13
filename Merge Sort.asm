#Mergesort code

.data
newline:	.asciiz	"\n"
prompt:		.asciiz "The sorted array is: \n"

len:	.word	10	# Array length
arr:	.word 5, -1, 13, 32, -69, -3, 21, 2, 11, 76
temp:	.space 40	#temp array for merging
	
.text
 
.globl main

main:

	la	$a0, arr			# start address of the array
	lw	$t0, len			# array length
	mul	$t0, $t0, 4			
	add	$a1, $a0, $t0		# array end address
	
	jal	merge_sort			# Call the merge sort function
 

	# Print the array after sorting
	li	$t0, 0				# Initialize the current index i
	
	la	$a0, prompt			# give prompt
	li	$v0,4				
	syscall	
	
prloop:
	lw	$t1,len				# array length
	bge	$t0,$t1,prdone		# end when i>=len
	mul	$t2,$t0,4			
	lw	$t3,arr($t2)		# load arr[i]
	move $a0, $t3			
	li	$v0,1				
	syscall					# Print the value
	la	$a0, newline		# give newline
	li	$v0,4				
	syscall					
	addi	$t0,$t0,1		# i++
	b	prloop				
	
prdone:						
	li	$v0,10				#terminate program
	syscall
	


# Recrusive mergesort function
# $a0 first address of the array
# $a1 last address of the array

merge_sort:

	addi	$sp, $sp, -16		# Adjust stack pointer
	sw	$ra, 0($sp)				# Store the return address on the stack
	sw	$a0, 4($sp)				# Store the array start address on the stack
	sw	$a1, 8($sp)				# Store the array end address on the stack
	
	sub 	$t0, $a1, $a0		# Calculate the difference between the start and end address (i.e. number of elements * 4)

	ble	$t0, 4, merge_sortend	# Return the array only contains a single element
	
	div	$t0, $t0, 8				# Divide the array size by 8 to half the number of elements 
	mul	$t0, $t0, 4				# Multiple that number by 4 to get half of the array size 
	add	$a1, $a0, $t0			# Calculate the midpoint address of the array
	sw	$a1, 12($sp)			# Store the array midpoint address on the stack
	
	jal	merge_sort				# Call recursively on the first half of the array
	
	lw	$a0, 12($sp)			# Load the midpoint address of the array from the stack
	lw	$a1, 8($sp)				# Load the end address of the array from the stack
	
	jal	merge_sort				# Call recursively on the second half of the array
	
	lw	$a0, 4($sp)				# Load the array start address from the stack
	lw	$a1, 12($sp)			# Load the array midpoint address from the stack
	lw	$a2, 8($sp)				# Load the array end address from the stack
	
	jal	merge					# Merge the two array halves
	
merge_sortend:				

	lw	$ra, 0($sp)				# Load the return address from the stack
	addi	$sp, $sp, 16		# Adjust the stack pointer
	jr	$ra						# Return 
	



# Merge two sorted arrays using additional array temp
#$a0 First address of first array
#$a1 First address of second array
#$a2 Last address of second array


merge:
	addi	$sp, $sp, -16		# Adjust the stack pointer
	sw	$ra, 0($sp)				# Store the return address on the stack
	sw	$a0, 4($sp)				# Store the start address on the stack
	sw	$a1, 8($sp)				# Store the midpoint address on the stack
	sw	$a2, 12($sp)			# Store the end address on the stack
	
	move	$s0, $a0			# pointer to first half of the array (i)
	move	$s1, $a1			# pointer to second half of the array (j)
	la	$s2, temp				# pointer to the temp array (k)
	
while1:
	bge $s0, $a1, while2		#end when i>=m
	bge $s1, $a2, while3		#end when j>=r
	lw	$t0, 0($s0)				# arr[i]
	lw	$t1, 0($s1)				# arr[j]
	bgt $t0, $t1, else			# branch if arr[i]>arr[j]
	sw	$t0, 0($s2)				#temp[k]=arr[i];
	add $s0, $s0, 4				#i++
	add $s2, $s2, 4				#k++
	j while1
	
else:
	sw	$t1, 0($s2)				#temp[k]=arr[j];
	add $s1, $s1, 4				#j++
	add $s2, $s2, 4				#k++
	j while1
	
while2:
	bge $s1, $a2, donewhile		#end when j>=r
	lw	$t1, 0($s1)				# arr[j]
	sw	$t1, 0($s2)				#temp[k]=arr[j];
	add $s1, $s1, 4				#j++
	add $s2, $s2, 4				#k++
	j while2

while3:
	bge $s0, $a1, donewhile		#end when i>=m
	lw	$t0, 0($s0)				# arr[i]
    sw	$t0, 0($s2)				#temp[k]=arr[i];
	add $s0, $s0, 4				#j++
	add $s2, $s2, 4				#k++
	j while3
	
donewhile:
	move $s0, $a0
	la	$s2, temp
	
#moving the values from temp to arr
	
forloop:
	bge $s0, $a2, mergeloopend	#end when i>=r
	lw $t2, 0($s2)
	sw $t2, 0($s0)				#arr[i]=temp[k]
	add $s0, $s0, 4				#i++
	add $s2, $s2, 4				#k++
	j forloop
	
	
mergeloopend:
	
	lw	$ra, 0($sp)				# Load the return address
	addi	$sp, $sp, 16		# Adjust the stack pointer
	jr 	$ra						# Return



