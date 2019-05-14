		;		ARM Programming Assignment #4: Encode in Hamming(15, 11)
		;
		;		Write a subroutine that encodes 11 bits of data into a 15-bit
		;		block, using 4 parity bits. Assume even parity, that is,
		;		the parity of the bits covered by a parity bit, including
		;		the parity bit, has to be an even number. Assume the bits are
		;		written in the following sequence: p1, p2, d1, p4, d2, d3, d4,
		;		p8, d5, d6, d7, d8, d9, d10, d11, p16, d12, d13, d14, d15.
		;		Call the subroutine `hencode`.
		;
		;		Write a subroutine that decodes a H(15, 11) block to extract
		;		the 11 data bits. Call it `hdecode`. It should:
		;		- calculate the correcting code
		;		- identify the case: no error (noer), one-bit error (onee)
		;		- write the result in `case` using the encoding provided
		;		- if there is a one-bit error, write the number of the
		;		erroneous bit in `berr`
		;		- if there is a one-bit error, correct the data
		;		- write the result in `corr`
		;
		;		Now, write a main function which uses `hencode` and `decode`
		;		to encode `data` and then, after a simulated transmission,
		;		decode `recv`. Assume that `recv` contains what is received
		;		at the other end.
		
		;		Your code here
		
data		DCD		0b10100100101
recv		DCD		0b101111010100101
		
noer		DCD		0x00
onee		DCD		0x01
		
		;mask	default to one
p1		dcd		0b000000000000001
p2		dcd		0b000000000000001
p4		dcd		0b000100000001000
p8		dcd		0b000000010000000
		
case		FILL		4
berr		FILL		4
corr		FILL		4
binary	FILL		100
		
		ADR		r4, binary
main
		ADR		r0, data ; get data
		LDR		r0, [r0] ; load into r1
		bl		hencode
		
		end
		
hencode
		bl		setup
		bl		enP1
		bl		main
		
decode
		
setup
		AND		r1, r0, #1 ;get d1
		MOV		r2, r1, lsl #2 ;mov d1 to its proper place
		AND		r3, r0, #0b1110 ;get d2 , d3, d4
		MOV		r3, r3, lsl #3  ;align to right place
		ADD		r2, r2, r3      ;combine
		MOV		r3, r0, lsr #4 ; mask d1-d4 get d5-d11
		MOV		r3, r3, lsl #7   ; align to right place
		ADD		r2,r2,r3 ;combine
		MOV		r0, r2 ;mov r2 into r0 so its easier to keep track of
		
enP1
		AND		r1,r0,  #0b000000001010101	;mask top half. I get error if I mask the whole thing
		AND		r2, r0, #0b101010100000000     ;mask botoom half
		ADD		r1, r1, r2 ;add the numbers together
		MOV		r3, #0 ;create counter
eP1Loop
		tst		r1, #1 ; check least signifcant bit
		ADDNE	r3, r3, #1 ;if bit is 1 add 1 to counter
		MOV		r1, r1 , ASR #1 ;bit shift multpicand left by 1 bit
		CMP		r1, #0 ; check if r0 has been zeroed out
		BNE		eP1Loop
enP1C
		ADR		r4, p1 ;load parity bit
		LDR		r4, [r4]
		TST		r3, #1 ; if counter is odd
		ADDNE	r0, r0, r4 ; add parity bit
enP2
		AND		r1,r0, #0b000000001100110	;mask top half. I get error if I mask the whole thing
		AND		r2, r0,#0b110011000000000     ;mask botoom half
		ADD		r1, r1, r2 ;add the numbers together
		MOV		r3, #0 ;create counter
eP2Loop
		tst		r1, #1 ; check least signifcant bit
		ADDNE	r3, r3, #1 ;if bit is 1 add 1 to counter
		MOV		r1, r1 , ASR #1 ;bit shift multpicand left by 1 bit
		CMP		r1, #0 ; check if r0 has been zeroed out
		BNE		eP2Loop
enP2C
		ADR		r4, p2 ;load parity bit
		LDR		r4, [r4]
		TST		r3, #1 ; if counter is odd
		ADDNE	r0, r0, r4 ; add parity bit
enP3
		AND		r1,r0, #0b000000001111000	;mask top half. I get error if I mask the whole thing
		AND		r2, r0,#0b1111000000000000     ;mask botoom half
		ADD		r1, r1, r2 ;add the numbers together
		MOV		r3, #0 ;create counter
eP3Loop
		tst		r1, #1 ; check least signifcant bit
		ADDNE	r3, r3, #1 ;if bit is 1 add 1 to counter
		MOV		r1, r1 , ASR #1 ;bit shift multpicand left by 1 bit
		CMP		r1, #0 ; check if r0 has been zeroed out
		BNE		eP3Loop
enP3C
		ADR		r4, p4 ;load parity bit
		LDR		r4, [r4]
		TST		r3, #1 ; if counter is odd
		ADDNE	r0, r0, r4 ; add parity bit
		
enP4
		AND		r1,r0, #0b011111110000000	;mask top half. I get error if I mask the whole thing
		AND		r2, r0,#0b1000000000000000     ;mask botoom half
		ADD		r1, r1, r2 ;add the numbers together
		MOV		r3, #0 ;create counter
eP4Loop
		tst		r1, #1 ; check least signifcant bit
		ADDNE	r3, r3, #1 ;if bit is 1 add 1 to counter
		MOV		r1, r1 , ASR #1 ;bit shift multpicand left by 1 bit
		CMP		r1, #0 ; check if r0 has been zeroed out
		BNE		eP4Loop
enP4C
		ADR		r4, p8 ;load parity bit
		LDR		r4, [r4]
		TST		r3, #1 ; if counter is odd
		ADDNE	r0, r0, r4 ; add parity bit
