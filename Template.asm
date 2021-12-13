.data
.text
.globl main
main: li $t0 ,24
	  li $t1, 10
	  add $t2, $t0, $t1		#add values in registers t0 and t1 and store the result in t2
	  sub $t3, $t0, $t1		#subtract values in registers t0 and t1 and store the result in t3
	  mul $t4, $t0, $t1		#multiply values in registers t0 and t1 and store the result in t4
	  div $t0, $t1			#remainder stored in register hi and quotient stored in lo
	  li $v0, 10			# endof program
	  syscall
.end main	  
	  