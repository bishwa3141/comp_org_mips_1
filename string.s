.data
	input_message:     	.asciiz "Choose a string: "
	valid_char_message:	.asciiz	"This char is valid" #Only using for debugging
	end_msg:    		.asciiz "All Characters printed"
	newline: 			.asciiz "\n"
	input: .space  9
	err_msg:			.asciiz "Invalid hexadecimal number."
.text
	main:
		# Code to read input
		la $s1, 0					# Result
		la $s3, 0					# Boolean for checking if a space is found after a valid character
		la $s4, 0					# Boolean for valid character found

		# Code to read user input
		li $v0, 8							#	Syscall code for user input
		la $a0, input 						#	Reading from the output
		li $a1, 9							# 	Maximum length for the string to be read from input
		move $t0, $a0						# 	Save the string to t0 register

		syscall 							#Making the read syscall



	loop_through:									#Loops through all the character of the input string one by one

		lb $a0, ($t0)								#Initializing the address for the character of the string
		
		add $t0, $t0, 1								#Incrementing the address

		beqz 	$a0, 			end_of_loop			#If "\0" found, end of loop

		beq  	$a0, 	10, 	end_of_loop			#For string less than 9, the last characters
																			# is "\n", so checking for that

		beq 	$a0, 	32, 	space				# Case for when a space character is found


		# Since at this stage, the character can't be a space or '\n' or '\0', we can check if a character
		# AND a space has appeared before it. If both are true, then it must be invalid. Otherwise, proceed
		# to computing the decimal value
		bne $s3, 1, compute							 
		bne $s4, 1, compute

		j invalid


	compute:
		# The code below uses the following algorithm to find the decimal value for a valid hex string
		# Initiliaze Result to 0
		# Step 1: Multiply Result by 16, Result = Result * 16
		# Step 2: Find value represented by the character.
		# Step 3: Add the value to the result.
		# Follow 1 to 3 for every character

		# Suppose the string is "ABC"
		# For A, 1. Result = 0 * 16 = 0,		2. A = 10,	3. Result = 0 + 10 = 10
		# For B, 1. Result = 10 * 16 = 160, 	2. B = 11, 	3.Result = 160 + 11 = 171
		# For C, 1. Result =  171 * 16 = 2736, 	2. C = 12,	3. Result = 2736 + 12 = 2748
		# Hence, ABC_16 = 2748_10


		la 	$s4, 1					# Making note that a character has been found.

		blt $a0, 48, invalid 		# checks if the number is less than 48. Goes to invalid if true

		ble $a0, 57, valid_num		# Checks if the ASCII of character is less than 58. At this point,
									# already greater than 48, so it is a valid num in the range 0-9

		blt $a0, 65, invalid 		# Checks if the ASCII of character is less than 68. At this point,
									# already greater than 58, so if true it is an invalid character

		ble $a0, 70, valid_capital	# Checks if the ASCII of character is less than 68. At this point,
									# already greater than 61, so if true it is a valid char in the range A - F

		blt $a0, 96, invalid 		# Checks if the ASCII of character is less than 96. At this point,
									# already greater than 70, so if true it is an invalid character

		ble $a0, 102, valid_small	# Checks if the ASCII of character is less than 58. At this point,
									# already greater than 96, so if true, it is a valid num in the range a-f

		j invalid 					#At this point, already greater than 103, so it is invalid

	end_of_loop:

		beqz $s4, invalid 			#If no valid characters found by the end of the loop, treat it as invalid

		la $s4, 1000				# For very large numbers, directly printing the results gives negative results
									# So, to overcome that the number is divided by a power of 10, which allows separate
									# registers to hold the value for the quotient and the remainder which are printed
									# separately

		divu $s1, $s4				# Finding the quotient and the remainder

		mfhi $s1					# Storing the remainder in $s1
		mflo $s2					# Storing the quotient in $s2

		beq $s2, $zero, rem_print	# To avoid printing 0 if either the remainder or quotient is zero, the two cases
									# are handled separately

		beq $s1, $zero, quot_print	#

		j complete_print			# If neither are zero, both are printed

		

	quot_print:
		li $v0, 1					# Syscall code for printing out an integer
		move $a0, $s2				# Transfer $s2 to $a0 for printing
		syscall 					

		li	$v0, 10					# system call code for exit = 10
		syscall

	rem_print:
		li $v0, 1					# Syscall code for printing out an integer
		move $a0, $s1				# Transfer $s1 to $a0 for printing
		syscall

		li	$v0, 10		# system call code for exit = 10
		syscall

	complete_print:

		
		li $v0, 1					# Syscall code for printing out an integer
		move $a0, $s2				# Transfer $s1 to $a0 for printing
		syscall

		li $v0, 1					# Syscall code for printing out an integer
		move $a0, $s1				# Transfer $s2 to $a0 for printing
		syscall


		li	$v0, 10					# system call code for exit = 10
		syscall 					


	invalid:
		# Printing the given message
		la $a0, err_msg	
		li $v0, 4
		syscall

		li	$v0, 10		# system call code for exit = 10
		syscall

	valid_num:

		sll 	$s1,	$s1, 	4 				# Multiplying the result by 16 using bit-shift	
		subu 	$s2, 	$a0, 	48				# Finding the real value of the character by subtracting
		addu 	$s1,	$s1, 	$s2 			# Adding the value of the character to the result

		j loop_through

	valid_capital:


		sll 	$s1,	$s1, 	4				# Multiplying the result by 16 using bit-shift
		subu 	$s2, 	$a0, 	55				# Finding the real value of the character by subtracting
		addu 	$s1,	$s1, 	$s2				# Adding the value of the character to the result

		j loop_through


	valid_small:

		sll 	$s1,	$s1, 	4				# Multiplying the result by 16 using bit-shift
		subu 	$s2, 	$a0, 	87				# Finding the real value of the character by subtracting
		addu 	$s1,	$s1, 	$s2				# Adding the value of the character to the result

		j loop_through

	space:
		beqz	$s4, loop_through			# Checks if a character has already been found

		la 	$s3, 1							# Making note of a space found after a character is found

		j loop_through						# return back to the loop

