;
; CS1022 Introduction to Computing II 2018/2019
; Lab 2 - Subarray
;

N	EQU	7
M	EQU	3		

	AREA	RESET, CODE, READONLY
	ENTRY

	; initialize system stack pointer (SP)
	LDR	SP, =0x40010000

	;
	; Write your program here to determine whether SMALL_A
	;   is a subarray of LARGE_A
	;
	; Store 1 in R0 if SMALL_A is a subarray and zero otherwise
	;
	LDR	R5, =LARGE_A
	LDR	R6, =SMALL_A
	MOV	R10, #M
	MOV	R7, #N
	SUB	R7, R7, R10		; M - N
	MOV	R8, #0			; i = 0
	LDR	R10, [R6]		; first element in small_a
NEXT_ROW
	CMP	R8, R7
	BHS	NO
	MOV	R9, #0			; j = 0
NEXT_COL
	CMP	R9, R7
	BHI	END_ROW
	MOV	R3, #N
	MUL	R3, R8, R3
	ADD	R3, R3, R9
	LDR	R4, [R5, R3, LSL #2]	; A[i, j]
	CMP	R4, R10			; if (LARGE_A[i, j] == SMALL_A[0, 0])
	BNE	NO_CHECK
	MOV	R1, R8
	MOV	R2, R9
	BL	check
NO_CHECK
	CMP	R0, #1
	BEQ	YES
	ADD	R9, R9, #1		; j++
	B	NEXT_COL
END_ROW
	ADD	R8, R8, #1		; i++
	B	NEXT_ROW
	
NO
	MOV	R8, #0
	B	STOP
YES
	MOV	R8, #1


STOP	B	STOP

; check subroutine
; Check if the subarray of LARGE_A is the same as the SMALL_A
; parameters
; 	R1: x of first element in the subarray of LARGE_A
; 	R2: y of first element in the subarray of LARGE_A
; return
; 	R0: whether it is a subarray of the other one
check
	PUSH	{R4, R7-R10, lr}
	MOV	R7, R1			; parameters to local variables
	MOV	R12, R2			; parameters to local variables
	MOV	R8, #0			; i = 0
FOR_I
	CMP	R8, #M
	BHS	END_SUB_YES
	MOV	R9, #0			; j = 0
FOR_J
	CMP	R9, #M
	BHS	END_J
	ADD	R10, R7, R8		; x of large_a
	ADD	R11, R12, R9		; y of large_a
	MOV	R4, #N
	MUL	R4, R10, R4
	ADD	R4, R4, R11
	LDR	R10, [R5, R4, LSL #2]	; LARGE_A[i, j]
	MOV	R4, #M
	MUL	R4, R8, R4
	ADD	R4, R4, R9
	LDR	R11, [R6, R4, LSL #2]	; SMALL_A[i, j]
	CMP	R10, R11		; if (LARGE_A[i, j] == SMALL_A[i, j])
	BNE	END_SUB_NO
	ADD	R9, R9, #1		; j++
	B	FOR_J
END_J
	ADD	R8, R8, #1		; i++
	B	FOR_I
END_SUB_YES
	MOV	R0, #1
END_SUB_NO
	POP	{R4, R8-R10, pc}


;
; test data
;

LARGE_A	DCD	 48, 37, 15, 44,  3, 17, 26
	DCD	  2,  9, 12, 18, 14, 33, 16
	DCD	 13, 20,  1, 22,  7, 48, 21
	DCD	 27, 19, 44, 49, 44, 18, 10
	DCD	 29, 17, 22,  4, 46, 43, 41
	DCD	 37, 35, 38, 34, 16, 25,  0
	DCD	 17,  0, 48, 15, 27, 35, 11

SMALL_A	DCD	 49, 44, 18
	DCD	  4, 46, 43
	DCD	 34, 16, 25

	END
