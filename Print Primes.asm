#Program to take a number as input and print all the odd prime numbers upto that

#C++ code

#void printOddPrime()
#{
#    cout<<"Please enter an integer:";    
#    int n;
#    cin>>n;
#    for(int i=3;i<=n;i+=2)
#    {
#        for(int j=2;j*j<=i;j++)
#        {
#            if(i%j==0)
#            {
#                goto lab1;
#            }
#        }
#    cout<<i<<"\n";
#    lab1:;
#    }
#}

#n: $s0 , i: $t0 , j: $t1 , j*j :$t3

.data
prompt:	.asciiz "Please enter an integer: "
newline: .asciiz "\n"

.text
.globl main

main:  li $v0, 4				#issue prompt
	   la $a0,prompt
	   syscall
	   li $v0, 5				#get n from keyboard
	   syscall
	   move $s0, $v0;			#$s0=n
	   li $t0, 3				#i=3
	   
for1:  blt $s0, $t0, endf1 		#exit loop when n<i 
	   li $t1,2					#j=2
	   mul $t3,$t1,$t1			#$t3=j*j
	   
for2:  blt $t0,$t3, endf2  		#exit loop when i<j*j
	   rem $t4,$t0,$t1   		#t4=i%j
	   beq $t4,0,goto1			#if(i%j==0) goto1
	   add $t1,$t1,1			#j++
	   mul $t3, $t1,$t1			#$t3=j*j
	   b for2
	
endf2: li $v0,1					#print i
	   move $a0,$t0
	   syscall
	   li $v0, 4 # print new line
	   la $a0, newline
	   syscall

goto1: add $t0,$t0,2       		#i=i+2
	   b for1
	   
endf1: li $v0, 10				# endof program
	   syscall
.end main	  
	  