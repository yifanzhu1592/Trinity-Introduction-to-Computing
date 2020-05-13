;
; CS1022 Introduction to Computing II 2018/2019
; Magic Square
;

	AREA	RESET, CODE, READONLY
	ENTRY

	; initialize system stack pointer (SP)
	LDR	SP, =0x40010000

	LDR	R0, =arr1
	LDR	R4, =size1
	LDR	R1, [R4]

	;
	; test your subroutine here
	;
	
	BL	isMagic		; array1 is a magic square, so it should return R0 with value 1
	
	LDR	R0, =arr2
	BL	isMagic		; array2 is not a magic square, so it should return R0 with value 0
	
	LDR	R0, =arr3
	BL	isMagic		; array3 is not a magic square, so it should return R0 with value 0

	LDR	R0, =arr4
	BL	isMagic		; array4 is not a magic square, so it should return R0 with value 0

	LDR	R0, =arr5
	BL	isMagic		; array5 is not a magic square, so it should return R0 with value 0
	
	LDR	R0, =arr6
	BL	isMagic		; array6 is not a magic square, so it should return R0 with value 0
	
stop	B	stop


;
; write your subroutine here
;

; isMagic subroutine
; Check whether a square two-dimensional array in memory is a Magic Square
; parameters
; 	R0: the address of the array
; 	R1: the size of the array
; return
; 	R0: whether the array is a Magic Square
isMagic
	PUSH	{R4-R10, LR}
	MOV	R4, R0			; parameters to local variables
	MOV	R5, R1			; parameters to local variables
	
	; Calculate the value of 1/2 * n * (n^2 + 1)
	MUL	R6, R5, R5		; n^2
	ADD	R6, R6, #1		; n^2 + 1
	MUL	R6, R5, R6		; n * (n^2 + 1)
	MOV	R9, #0
half
	ADD	R9, R9, #1
	ADD	R7, R9, R9
	CMP	R7, R6			; if R7 == R6, then R9 == 1/2 * n * (n^2 + 1)
	BNE	half
	
	; Check the first main diagonal line
	MOV	R8, #0			; clear the offset
	MOV	R6, #0			; the sum of the main diagonal line
	MOV	R10, #0			; the counter
nextOneFirst
	LDR	R7, [R4, R8, LSL #2]	; a number in the main diagonal line
	ADD	R6, R6, R7
	ADD	R8, R8, R5
	ADD	R8, R8, #1
	ADD	R10, R10, #1
	CMP	R10, R5			; check if all numbers in this main diagonal line have been added
	BNE	nextOneFirst
	CMP	R6, R9			; check if the sum of the numbers in this main diagonal line equals to 1/2 * n * (n^2 + 1)
	BNE	false
	
	; Check the second main diagonal line
	MOV	R4, R0			; parameters to local variables
	MOV	R8, #0			; clear the offset
	MOV	R6, #0			; the sum of the main diagonal line
	MOV	R10, #0			; the counter
nextOneSecond
	ADD	R8, R8, R5
	SUB	R8, R8, #1
	LDR	R7, [R4, R8, LSL #2]	; a number in the main diagonal line
	ADD	R6, R6, R7
	ADD	R10, R10, #1
	CMP	R10, R5			; check if all numbers in this main diagonal line have been added
	BNE	nextOneSecond
	CMP	R6, R9			; check if the sum of the numbers in this main diagonal line equals to 1/2 * n * (n^2 + 1)
	BNE	false
	
	; Check the rows
	MOV	R4, R0			; parameters to local variables
	MOV	R10, #0			; the index of the row
nextRow
	MOV	R8, #0			; clear the offset
	MOV	R6, #0			; the sum of the row
thisRow
	LDR	R7, [R4, R8, LSL #2]	; a number in the row
	ADD	R6, R6, R7
	ADD	R8, R8, #1
	CMP	R8, R5			; check if all numbers in this row have been added
	BNE	thisRow
	CMP	R6, R9			; check if the sum of the numbers in this row equals to 1/2 * n * (n^2 + 1)
	BNE	false
	ADD	R4, R4, R5, LSL #2	; the address of the first number in the next line
	ADD	R10, R10, #1
	CMP	R10, R5			; check if all rows in this array have been checked
	BNE	nextRow

	; Check the columns
	MOV	R4, R0			; parameters to local variables
	MOV	R11, #0			; the counter for the row
nextCol
	MOV	R8, #0			; the counter for the column
	LDR	R6, [R4]		; the first number in the column
nextNum
	ADD	R8, R8, #1
	CMP	R8, R5			; check if all numbers in this column have been added
	BEQ	checkNum
	MUL	R10, R8, R5
	LDR	R7, [R4, R10, LSL #2]	; a number in the column
	ADD	R6, R6, R7
	B	nextNum
checkNum
	CMP	R6, R9			; check if the sum of the numbers in this column equals to 1/2 * n * (n^2 + 1)
	BNE	false
	ADD	R4, R4, #4
	ADD	R11, R11, #1
	CMP	R11, R5			; check if all rows in this array have been checked
	BNE	nextCol
	
	; Check if all the numbers are the same
	LDR	R6, [R4]
	LDR	R7, [R4, #4]
	CMP	R6, R7
	BEQ	false
	
true
	MOV	R0, #1			; the array is a magic square
	B	exit
false
	MOV	R0, #0			; the array is not a magic square
exit
	POP	{R4-R10, PC}

size1	DCD	3		; a 3x3 array
	
arr1	DCD	2,7,6		; the array (magic square)
	DCD	9,5,1
	DCD	4,3,8
		
arr2	DCD	9,7,6		; the array (used to test the row checking part)
	DCD	2,5,1
	DCD	4,3,8
		
arr3	DCD	7,2,6		; the array (used to test the column checking part)
	DCD	9,5,1
	DCD	4,3,8

arr4	DCD	7,2,6		; the array (used to test the first main diagonal line checking part)
	DCD	5,9,1
	DCD	3,4,8

arr5	DCD	2,6,7		; the array (used to test the second main diagonal line checking part)
	DCD	9,1,5
	DCD	4,8,3
		
arr6	DCD	5,5,5		; the array (used to check if all the numbers are the same)
	DCD	5,5,5
	DCD	5,5,5
		
	END
