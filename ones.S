		;		ARM Programming Assignment #4: Count the ones in a binary number
		;
		;		Write a program that counts the number of ones in a binary number,
		;		stored in a word (4 bytes). Its loop should run no more times than there
		;		are ones in the number. Write the count in `numones`. For the example
		;		number given below, the loop should only run 8 times, counting 8 ones.
		;
		;		Hint:
		;		The first significant instruction in the loop is SUB r1, r1, 1, which
		;		decrements the number, assuming it's stored in register r1. Now,
		;		remember your logical operations.
		;
		;		Bonus:
		;		1. (20 extra points) For the shortest program (by instruction count),
		;		because this operation has to be FAST.
		;		2. (30 extra points) For extending the program to counting the ones
		;		in any word-aligned contiguous region of memory.
		
		;		Your code here
		
example	DCD		0b111101
numones	FILL		4
		ADR		r1, example ;load number
		LDR		r1, [r1] ;
		MOV		r2, #0 ;intizalize count
		ADR		r3 , numones
		
main
		tst		r1, #1 ; check least signifcant bit
		ADDNE	r2, r2, #1 ;if bit is 1 add 1 to counter
		MOV		r1, r1 , ASR #1 ;bit shift multpicand left by 1 bit
		CMP		r1, #0 ; check if r0 has been zeroed out
		BNE		main
		STR		r2, [r3] ; store number in numerons fill
