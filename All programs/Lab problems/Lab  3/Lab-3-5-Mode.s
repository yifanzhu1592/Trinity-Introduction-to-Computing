;
; CSU11021 Introduction to Computing I 2019/2020
; Mode
;

	AREA	RESET, CODE, READONLY
	ENTRY

	LDR	R4, =tstN	; load address of tstN
	LDR	R1, [R4]	; load value of tstN

	LDR	R2, =tstvals	; load address of numbers
	
	LDR	R0, [R2]	; R0 = [R2]
	ADD	R3, R2, #4	; R3 = R2 + 4
while
	CMP	R1, #1		; R1 == 1
	BEQ	endWhile
	SUB	R1, R1, #1	; R1 = R1 - 1
	LDR	R5, [R4]	; R5 = [R4]
	LDR	R6, =4		; R6 = 4
	MUL	R5, R6, R5	; R5 = R6 * R5
	LDR	R6, =0		; R6 = 0
	LDR	R7, =0		; R7 = 0
	LDR	R9, =0		; R9 = 0
	LDR	R10,=0		; R10 = 0
innerWhile
	CMP	R5, R6		; R5 == R6
	BEQ	endInnerWhile
	ADD	R7, R6, R2	; R7 = R6 + R2
	LDR	R8, [R7]	; R8 = [R7]
	CMP	R8, R0		; R8 != R0
	BNE	notEqualMax
	ADD	R9, R9, #1	; R9 = R9 + 1
notEqualMax
	LDR	R11, [R3]	; R11 = [R3]
	CMP	R8, R11		; R8 != R11
	BNE	notEqual
	ADD	R10, R10, #1	; R10 = R10 + 1
notEqual
	ADD	R6, R6, #4	; R6 = R6 + 4
	B	innerWhile
endInnerWhile
	CMP	R9, R10		; R9 >= R10
	BHS	notChanged
	MOV	R0, R11		; R0 = R11
notChanged
	ADD	R3, R3, #4	; R3 = R3 + 4
	B	while
endWhile

STOP	B	STOP

	

tstN	DCD	8			; N (number of numbers)
tstvals	DCD	5, 3, 7, 5, 3, 5, 1, 9	; numbers

	END
