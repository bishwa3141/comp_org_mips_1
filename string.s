.data
	input_message:     .asciiz "Choose a string: "
	end_msg:    .asciiz "All Characters printed"
	newline: 			.asciiz "\n"
	input: .space  8
	err_msg:			.asciiz "Invalid hexadecimal number."
.text
	main:
		# Code to read input
		la $a0, input_message		#Passing the prompt message address to the register
		la $a1, 9					
		li $v0, 4					#Syscall code for Printing
		syscall
		
		# Code to read user input
		li $v0, 8					#Allocate space for the user input
		la $a0, input 				#Save the


		move $t0, $a0				# Save the string to t0 register
		syscall
		
		


	loop_through:					#Loops through all the character of the input string one by one

		lb $a0, ($t0)				#Initializing the address for the character of the string

		beqz $a0, end_of_loop		#If "\0" foound, end of loop
		
		li $v0, 11
		syscall

		add $t0, $t0, 1				#Incrementing the address


		# Temp Message to see if separate chars are being printed
		la $a0, newline
		li $v0, 4
		syscall




		j loop_through

	# continue:

	# 	li $v0, 11					#Syscall for reading character
	# 	la	$a0, ($t2)
	# 	syscall

	# 	add $t0, $t0, 1				#Incrementing the 
	# 	add $t1, $t1, 1				#Ibcrementing the loop counter

	# 	j loop_through

	end_of_loop:

		# Printing the given message
		la $a0, end_msg
		li $v0, 4
		syscall

		li	$v0, 10		# system call code for exit = 10
		syscall


	
