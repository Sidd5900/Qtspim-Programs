#c++ code for the bubble sort

#void bubble_sort(int arr[],int n)
#{
#    for(int i=0;i<n-1;i++)
#    {
#        int flag=0;
#        for(int j=0;j<n-1;j++)
#        {
#            if(arr[j]>arr[j+1])
#            {
#                swap(arr[j],arr[j+1]);
#                flag=1;
#            }
#        }
#        if(flag==0)
#            break;
#    }
#}


.data 
    arr1: .word  1, -2, 3, -4, -5, 6 
	len: .word 6
	arrayprompt: .asciiz "The sorted arrays is:\n"
	newline: .asciiz "\n"
	spacebar: .asciiz "  "

.text

.globl main

main:
	la $a0, arr1 # address of arr1
	lw $a1, len # value of legth
	la $s4, arr1
	
	jal bubblesort # call routine
	
	li $v0, 4 # print array prompt
	la $a0, arrayprompt
	syscall
	
	move $s2, $s4 # address of arr1
	li $s3, 0 # start from index 0
	
printloop:
    beq $s3, $a1, endprintloop
	lw $t3, ($s2)
	
	li $v0, 1 # call code for print int
	move $a0, $t3 # get array[i]
	syscall 
	
	li $v0, 4 # give spaces
	la $a0, spacebar
	syscall
	
	add $s2, $s2, 4
	add $s3, $s3, 1
	j printloop
	
endprintloop:	
	# Done, terminate program.
	
	li $v0, 10 # terminate
	syscall # system call
	.end main




#bubblesort function definition 
#$a0 contains address of arr1, $a1 contains size of arr1
	
bubblesort:
	
	li $t0, 0	#index i initialized with 0
    sub $t3, $a1, 1 #len-1
	move $s1, $a0
	move $s2, $ra
	move $s3, $a1
	
outerloop:
	beq $t0, $t3, endouterloop
	move $s0, $s1 # address of arr1
	li $t1, 0	#flag variable to check if atleast one swap happened
	li $t2, 0	#index j initialized with 0 
	
innerloop:
	beq $t2, $t3, endinnerloop
	move $a0, $s0
    addi $a1, $a0, 4
	lw $t6, 0($a0)
    lw $t7, 0($a1)
	
	ble $t6, $t7, continue
	jal swap

continue:
	add $s0, $s0, 4
	add $t2, $t2, 1 
	j innerloop
	
endinnerloop:
	beq $t1, 0, noswaps
    add $t0, $t0, 1	
	j outerloop
	
endouterloop:

noswaps:
    move $ra, $s2
	move $a0,$s1
	move $a1, $s3
	jr $ra
	


swap: lw $t4,0($a0)
      lw $t5, 0($a1)
	  li $t1, 1
	  sw $t4, 0($a1)
	  sw $t5, 0($a0)
	  jr $ra