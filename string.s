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

		la $s1, 0 							# Boolean for checking if first string
		la $a0, input_message		#Passing the prompt message address to the register
		la $a1, 9
		li $v0, 4					#Syscall code for Printing

		syscall

		# Code to read user input
		li $v0, 8							#Allocate space for the user input
		la $`a0, input 				#Save the
		move $t0, $a0					# Save the string to t0 register

		syscall



	loop_through:					#Loops through all the character of the input string one by one

		lb $a0, ($t0)				#Initializing the address for the character of the string
		add $t0, $t0, 1			#Incrementing the address

		beqz 	$a0, 				end_of_loop			#If "\0" found, end of loop

		beq  	$a0, 	10, 	end_of_loop			#For string less than 9, the last characters
																			# is "\n", so checking for that

		beq 	$a0, 	32, 	loop_through		#If space character found, ignore it


		li 		$v0, 	11
		syscall



		blt $a0, 48, invalid 		# checks if the number is less than 48. Goes to invalid if true

		ble $a0, 57, valid			# Checks if the ASCII of character is less than 58. At this point,
									# already greater than 48, so it is a valid num in the range 0-9

		blt $a0, 65, invalid 		# Checks if the ASCII of character is less than 68. At this point,
									# already greater than 58, so if true it is an invalid character

		ble $a0, 70, valid			# Checks if the ASCII of character is less than 68. At this point,
									# already greater than 61, so if true it is a valid char in the range A - F

		blt $a0, 96, invalid 		# Checks if the ASCII of character is less than 96. At this point,
									# already greater than 70, so if true it is an invalid character

		ble $a0, 102, valid			# Checks if the ASCII of character is less than 58. At this point,
									# already greater than 96, so if true, it is a valid num in the range a-f

		j invalid 					#At this point, already greater than 103, so it is invalid


	end_of_loop:

		la $a0, end_msg
		li $v0, 4
		syscall

		li	$v0, 10		# system call code for exit = 10
		syscall


	invalid:
		# Printing the given message
		la $a0, err_msg
		li $v0, 4
		syscall

		li	$v0, 10		# system call code for exit = 10
		syscall


	valid:

		la $a0, valid_char_message
		li $v0, 4
		syscall

		j loop_through
