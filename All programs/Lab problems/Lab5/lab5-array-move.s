;
; CS1022 Introduction to Computing II 2018/2019
; Lab 1 - Array Move
;

N	EQU	16		; number of elements

	AREA	globals, DATA, READWRITE

; N word-size values

ARRAY	SPACE	N*4		; N words


	AREA	RESET, CODE, READONLY
	ENTRY

	; for convenience, let's initialise test array [0, 1, 2, ... , N-1]

	LDR	R0, =ARRAY
	LDR	R1, =0
L1	CMP	R1, #N
	BHS	L2
	STR	R1, [R0, R1, LSL #2]
	ADD	R1, R1, #1
	B	L1
L2

	; initialise registers for your program

	LDR	R0, =ARRAY
	LDR	R1, =6
	LDR	R2, =3
	LDR	R3, =N

	; your program goes here
	LDR	R4, [R0, R1, LSL #2]	; get the value at [array + 6]
LOOP
	CMP	R1, R2
	BLS	LAST
	SUB	R1, R1, #1		; the value at R1 been removed to R6
	LDR	R5, [R0, R1, LSL #2]
	ADD	R6, R1, #1		; the value at R1 been replaced by value at R1
	STR	R5, [R0, R6, LSL #2]
	B	LOOP
LAST
	STR	R4, [R0, R2, LSL #2]	; store the value at [array + 6] to [array]

STOP	B	STOP

	END
