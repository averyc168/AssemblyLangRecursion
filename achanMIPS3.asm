#-------------------------------------------------------------------------#
# Name:     Avery Chan
# Filename: achanMIPS2.asm

# Purpose:  The program prints out the fibonacci sequence to the nth term,
# in reverse of the user's inputted integer. It also calculates the sum of
# the fibonacci terms to the nth term, and does it all recursively through
# the same fibonacci procedure.

# Input:    The user inputs an integer between 0 and 44 (inclusive). This
# integer will be the nth term that the fibonacci sequence will count to. 

# Output:   The program will output the Fibonacci sequence up to the nth
# term that the user inputted in reverse, with a comma separated between
# each of them. After that, it will output the sum of the fibonacci sequence
# values up to the nth term.

#-------------------------------------------------------------------------#
	.data
start: 	.asciiz	"Enter an integer: "
fibStr:	.asciiz	"The Fibonacci Sequence is:\n"
sumStr: 	.asciiz	"The sum is "
endl:	.asciiz	"\n"
#-------------------------------------------------------------------------#
	.text
	.globl main
main:
	### prompting the user with the start string to enter an int
	li	$v0, 4
	la	$a0, start
	syscall
	li	$v0, 5		# read int for length of Fibonacci Sequence
	syscall
	move	$t0, $v0		# move user inputted value to t0 for argument
	
	
	# printing the fibonacci sequence start string before calling the fib
	# function
	li	$v0, 4
	la	$a0, endl
	syscall
	li	$v0, 4
	la	$a0, fibStr
	syscall
	
	# setting up the parameters
	move	$a0, $t0		# moving value in t0 to a0
	addi	$a1, $zero, 0	# having a1 (a) be zero
	addi	$a2, $zero, 1	# having a2 (b) be one
	addi	$a3, $zero, 0	# having a3 (sum) be zero
	
	jal	fib		# jump to fibonacci function
	move 	$t1, $v0		# put return value into temporary register t0
	
	# if the user did not first type in zero then jump to printing the sum
	bne	$t0, $zero, printSum
	# if the user did type zero, then print the zero into the fib sequence
	# because Fib(0) = 0
	li	$v0, 1
	move	$a0, $t0
	syscall
	
printSum:	
	# printing out the sum of the fibonacci sequence
	li	$v0, 4
	la	$a0, endl
	syscall
	li	$v0, 4
	la	$a0, sumStr
	syscall
	move	$a0, $t1		# move temporary value into a0 so it can be printed
	li	$v0, 1
	syscall
	li	$v0, 4
	la	$a0, endl
	syscall
	
	# end program
	li	$v0, 10
	syscall
	
#-------------------------------------------------------------------------#

### fib procedure
# procedure that finds the values of the fibonacci sequence to the nth term,
# prints it in reverse, and calculates the sum of the fibonacci terms.
# parameters: an integer n (a0) that the user inputted till 0, the F(n-2)
# 	      value of the fibonacci sequence (a1), the F(n-2) value of the 
#	      fibonacci sequence (a2), and the sum in integer format (a3).
# return:     The function should have printed out all of the fibonacci 
#	      sequence in reverse to the nth term, and the sum should be 
#	      calculated and returned to the main function. System stack is
#	      also being undone until we return back to main function.

	.data
comSpa: 	.asciiz 	", "
	.text
fib:
	# add to system stack
	subu	$sp, $sp, 48	# allocate storage for frame
	sw	$ra, 24($sp)	# save return address
	sw	$fp, 20($sp)	# save frame pointer
	addu 	$fp, $sp, 44	# reset frame pointer
	
	# load the arguments
	sw	$a0, -12($fp)	# first parameter (integer n)
	sw	$a1, -8($fp)	# second parameter (a)
	sw	$a2, -4($fp)	# third parameter (b)
	sw	$a3, 0($fp)	# fourth parameter (sum)

	beq	$a0, $zero, endFib	# if n == 0, then end recursion
	# if false then set up parameters for next recursive call
	subi 	$a0, $a0, 1	# decrements integer n by 1
	move	$t2, $a1		# moving a1 (a) into temporary register t2
	move	$a1, $a2		# parameter a2 (b) now is a1
	add	$a2, $a2, $t2	# paramter a2 is a1 + a2 (a+b)
	
	jal	fib		# recursive call until n == 0
	
	lw	$t5, -4($fp)	# loading paramter a2(b) into t5
	add	$a3, $a3, $t5	# get the sum of the fibonacci sequence (nth term)
				# by adding value of t5 to sum (sum += t5)
		
	move	$a0, $t5		# move a1 to a0, so it can be printed
	li	$v0, 1		# print value for fibonacci sequence
	syscall
	
	lw	$t3, -12($fp)	# loading parameter (int n) into t3
	beq	$t3, $t0, noPrint	# checks to see if it is the last fib num and
					# if so, do not print extra comma and space
	li	$v0, 4
	la	$a0, comSpa	# else, print comma and space string to separate values
	syscall

noPrint:
	move	$a0, $t3		# put t3 value back into the a0 register
	
	
endFib:
	move 	$v0, $a3		# move sum to v0 for return value
	
	# undo everything from above (unstack the system stack)
	lw	$ra, 24($sp)
	lw 	$fp, 20($sp)
	addu 	$sp, $sp, 48
	jr	$ra		# jump back to return address



	
	
