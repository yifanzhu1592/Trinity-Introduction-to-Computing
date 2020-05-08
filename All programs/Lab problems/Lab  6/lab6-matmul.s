;
; CS1022 Introduction to Computing II 2018/2019
; Lab 2 - Matrix Multiplication
;

N	EQU	4		

	AREA	globals, DATA, READWRITE

; result array
ARR_R	SPACE	N*N*4		; N*N words (4 bytes each)


	AREA	RESET, CODE, READONLY
	ENTRY

	; initialize system stack pointer (SP)
	LDR	SP, =0x40010000

	;
	; write your matrix multiplication program here
	;
	LDR	R10, =ARR_A
	LDR	R11, =ARR_B
	LDR	R12, =ARR_R
	MOV	R0, #0		; i = 0
FOR_I
	CMP	R0, #N		; i < N
	BHS	END_I
	MOV	R1, #0		; j = 0
FOR_J
	CMP	R1, #N		; j < N
	BHS	END_J
	MOV	R2, #0		; r = 0
	MOV	R3, #0		; k = 0
FOR_K
	CMP	R3, #N		; k < N
	BHS	END_K
	MOV	R4, #N
	MUL	R4, R0, R4
	ADD	R4, R4, R3
	LDR	R5, [R10, R4, LSL #2]	; A[i, k]
	MOV	R6, #N
	MUL	R6, R3, R6
	ADD	R6, R6, R1
	LDR	R7, [R11, R6, LSL #2]	; B[k, j]
	MUL	R8, R5, R7	; A[i, k] * B[k, j]
	ADD	R2, R2, R8	; r = r + A[i, k] * B[k, j]
	ADD	R3, R3, #1	; k++
	B	FOR_K
END_K
	MOV	R9, #N
	MUL	R9, R0, R9
	ADD	R9, R9, R1
	STR	R2, [R12, R9, LSL #2]	; R[i, j] = r
	ADD	R1, R1, #1	; j++
	B	FOR_J
END_J
	ADD	R0, R0, #1	; i++
	B	FOR_I
END_I


STOP	B	STOP


;
; test data
;

ARR_A	DCD	 1,  2,  3,  4
	DCD	 5,  6,  7,  8
	DCD	 9, 10, 11, 12
	DCD	13, 14, 15, 16

ARR_B	DCD	 1,  2,  3,  4
	DCD	 5,  6,  7,  8
	DCD	 9, 10, 11, 12
	DCD	13, 14, 15, 16

	END
