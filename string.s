.data
	input_message:     .asciiz "Choose a string: "
	output_message:    .asciiz "The string that you typed is: "
	input: .space  8

.text
	main:
		# Code to read input
		la $a0, input_message
		li $v0, 4
		syscall
		
		# Code to read user input
		li $v0, 8
		la $a0, input
		li $a1, 20
		syscall
		
		# Printing the given message
		la $a0, output_message
		li $v0, 4
		syscall		
		
		# Printing the user submitted string
		la $a0, input
		li $v0, 4
		syscall
	
