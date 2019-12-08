;
; CSU11021 Introduction to Computing I 2019/2020
; Anagrams
;

	AREA	RESET, CODE, READONLY
	ENTRY

	LDR	R0, =tststr1	; first string
	LDR	R1, =tststr2	; second string

	;
	; Write your program here
	;
	
	MOV	R2, R0		; R2 = tststr1.address
	MOV	R3, R1		; R3 = tststr2.address
	MOV	R5, R0		; R5 = tststr1.address

LOOP				; Compare the length of two strings to make sure that the second one is not longer than the first one
	LDRB	R4, [R5]	
	LDRB	R7, [R3]
	CMP	R4, #0
	BEQ	SEE
	ADD	R5, R5, #1
	ADD	R3, R3, #1
	B	LOOP
SEE
	CMP	R7, #0
	BNE	FALSE
	MOV	R3, R1
	MOV	R5, R0

BIGWHILE
	LDRB	R6, [R2]
	CMP	R6, #0
	BEQ	TRUE
WHILE				; Count how many times the character appears in the first string
	LDRB	R4, [R5]
	CMP	R4, #0
	BEQ	THEN
	CMP	R4, R6
	BNE	NOT
	ADD	R9, R9, #1
NOT
	ADD	R5, R5, #1
	B	WHILE

THEN				; Count how many times the character appears in the second string
	LDRB	R7, [R3]
	CMP	R7, #0
	BEQ	FINALLY
	CMP	R7, R6
	BNE	NOT1
	ADD	R10, R10, #1
NOT1
	ADD	R3, R3, #1
	B	THEN
	
FINALLY				; Compare if the character appears the same times in the two strings
	CMP	R9, R10
	BNE	FALSE
	ADD	R2, R2, #1
	MOV	R5, R0
	MOV	R3, R1
	MOV	R9, #0
	MOV	R10, #0
	B	BIGWHILE
	
FALSE				; not anagrams
	MOV	R0, #0
	B	STOP

TRUE				; anagrams
	MOV	R0, #1
	
STOP	B	STOP

tststr1	DCB	"marr",0
tststr2	DCB	"yram",0

	END
