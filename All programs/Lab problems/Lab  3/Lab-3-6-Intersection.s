;
; CSU11021 Introduction to Computing I 2019/2020
; Intersection
;

	AREA	RESET, CODE, READONLY
	ENTRY

	LDR	R0, =0x40000000	; address of sizeC
	LDR	R1, =0x40000004	; address of elemsC
	
	LDR	R6, =sizeA	; address of sizeA
	LDR	R2, [R6]	; load sizeA
	LDR	R3, =elemsA	; address of elemsA
	
	LDR	R6, =sizeB	; address of sizeB
	LDR	R4, [R6]	; load sizeB
	LDR	R5, =elemsB	; address of elemsB

	;
	; Your program to compute the interaction of A and B goes here
	;
	; Store the size of the intersection in memory at the address in R0
	;
	; Store the elements in the intersection in memory beginning at the
	;   address in R1
	;
	
while
	CMP	R2, #0		; R2 == 0
	BEQ	endWhile
	SUB	R2, R2, #1	; R2 = R2 - 1
	LDR	R7, [R3]	; R7 = [R3]
	LDR	R8, =0		; R8 = 0
	MOV	R11, R5		; R11 = R5
innerWhile
	CMP	R8, R4		; R8 == R4
	BEQ	endInnerWhile
	LDR	R9, [R11]	; R9 = [R11]
	ADD	R11, R11, #4	; R11 = R11 + 4
	CMP	R7, R9		; R7 != R9
	BNE	notEqual
	LDR	R10, [R0]	; R10 = [R0]
	ADD	R10, R10, #1	; R10 = R10 + 1
	STR	R10, [R0]	; [R0] = R10
	STR	R7, [R1]	; [R1] = R7
	ADD	R1, R1, #4	; R1 = R1 + 4
	B	endInnerWhile
notEqual
	ADD	R8, R8, #1	; R8 = R8 + 1
	B	innerWhile
endInnerWhile
	ADD	R3, R3, #4	; R3 = R3 + 4
	B	while
endWhile

STOP	B	STOP

sizeA	DCD	4
elemsA	DCD	7, 14, 6, 3

sizeB	DCD	9
elemsB	DCD	20, 11, 14, 5, 7, 2, 9, 12, 17

	END
