;
; CS1022 Introduction to Computing II 2018/2019
; Lab 3 - Floating-Point
;

	AREA	RESET, CODE, READONLY
	ENTRY

;
; Test Data
;
FP_A	EQU	0xC1C40000
FP_B	EQU	0xC1960000


	; initialize system stack pointer (SP)
	LDR	SP, =0x40010000

	;
	; test your subroutines here
	;
	LDR	R0, =FP_A
	BL	fpfrac
	MOV	R4, R0		; fraction of FP_A
	LDR	R0, =FP_A
	BL	fpexp
	MOV	R5, R0		; exponent of FP_A 
	LDR	R0, =FP_A
	MOVS	R0, R0, LSL #1
	BCC	positive1
	MOV	R10, #1		; FP_A is negative
	B	negative1
positive1
	MOV	R10, #0		; FP_A is positive
negative1
	
	LDR	R0, =FP_B
	BL	fpfrac
	MOV	R6, R0		; fraction of FP_B
	LDR	R0, =FP_B
	BL	fpexp
	MOV	R7, R0		; exponent of FP_B
	LDR	R0, =FP_B
	MOVS	R0, R0, LSL #1
	BCC	positive2
	MOV	R11, #1		; FP_B is negative
	B	negative2
positive2
	MOV	R11, #0		; FP_B is positive
negative2
	
	CMP	R10, R11
	BNE	different_signs	; FP_A and FP_B have different signs
	CMP	R5, R7
	BNE	not_equal
	MOV	R4, R4, LSR #1
	MOV	R6, R6, LSR #1
	ADD	R8, R4, R6	; fraction of FP_C
	ADD	R9, R5, #1	; exponent of FP_C
	B	exit
not_equal
	CMP	R5, R7
	BLO	lower
	SUB	R9, R5, R7
	MOV	R6, R6, LSR #1
	ADD	R6, R6, #0x00400000
	MOV	R6, R6, LSR R9
	MOV	R6, R6, LSL #1
	MOV	R9, R5		; exponent of FP_C
	B	ready
lower
	SUB	R9, R7, R5
	MOV	R4, R4, LSR #1
	ADD	R4, R4, #0x00400000
	MOV	R4, R4, LSR R9
	MOV	R4, R4, LSL #1
	MOV	R9, R7		; exponent of FP_C
ready				; ready for adding
	ADDS	R8, R4, R6	; fraction of FP_C
	BCC	exit		; no carry
	MOV	R8, R8, LSR #1	; fraction of FP_C
	ADD	R9, R9, #1	; exponent of FP_C
exit
	MOV	R0, R8
	MOV	R1, R9
	BL	fpencode
	
	CMP	R10, #0
	BEQ	stop
	ADD	R0, R0, #0x80000000	; if both FP_A and FP_B are negative, the answer should be negative
	B	stop
	
different_signs
	CMP	R5, R7
	BNE	not_equal1
	LDR	R2, =0x007FFFFF
	CMP	R4, R6
	BLO	minus		; FP_A's fraction is smaller than FP_B's fraction
	EOR	R8, R6, R2
	ADD	R8, R8, #1
	ADD	R8, R8, R4
	MOV	R3, #0		; FP_A's fraction is larger than or equal to FP_B's fraction
	B	plus
minus
	EOR	R8, R4, R2
	ADD	R8, R8, #1
	ADD	R8, R8, R6
	MOV	R3, #1		; FP_A's fraction is smaller than FP_B's fraction
plus
	MOV	R8, R8, LSL #9
	MOV	R12, #0
continue_loop
	MOVS	R8, R8, LSL #1
	ADD	R12, R12, #1
	BCC	continue_loop
	MOV	R8, R8, LSR #9	; fraction of FP_C
	SUB	R9, R5, R12	; exponent of FP_C
	B	exit1
not_equal1
	CMP	R5, R7
	BLO	lower1		; the exponent of FP_A is lower
	SUB	R9, R5, R7
	CMP	R4, R6
	BHS	high_frac	; the fraction of FP_A is higher
	MOV	R3, #1
	B	low_frac
high_frac
	MOV	R3, #0
low_frac
	MOV	R6, R6, LSR R9
	EOR	R8, R6, R2
	ADD	R8, R8, #1
	ADD	R8, R8, R4	; fraction of FP_C
	MOV	R9, R5		; exponent of FP_C
	CMP	R3, #0
	BEQ	exit2
	MOV	R8, R8, LSL #9
	MOV	R12, #0
continue_loop1
	MOVS	R8, R8, LSL #1
	ADD	R12, R12, #1
	BCC	continue_loop1
	MOV	R8, R8, LSR #9	; fraction of FP_C
	SUB	R9, R5, R12	; exponent of FP_C
	B	exit2
lower1				; the exponent of FP_A is lower
	SUB	R9, R7, R5
	CMP	R4, R6
	BLS	low_frac1	; the fraction of FP_A is lower
	MOV	R3, #0
	B	high_frac1
low_frac1
	MOV	R3, #1
high_frac1
	MOV	R4, R4, LSR R9
	EOR	R8, R4, R2
	ADD	R8, R8, #1
	ADD	R8, R8, R6	; fraction of FP_C
	MOV	R9, R5		; exponent of FP_C
	CMP	R3, #1
	BEQ	exit2
	MOV	R8, R8, LSL #9
	MOV	R12, #0
continue_loop2
	MOVS	R8, R8, LSL #1
	ADD	R12, R12, #1
	BCC	continue_loop2
	MOV	R8, R8, LSR #9	; fraction of FP_C
	SUB	R9, R5, R12	; exponent of FP_C
	B	exit2
	
exit1
	MOV	R0, R8
	MOV	R1, R9
	BL	fpencode
	CMP	R3, #1
	BEQ	a_smaller
	CMP	R4, R6
	BEQ	stop		; if FP_A's fraction and FP_B's fraction are equal
	CMP	R10, #0
	BNE	nega		; if FP_B's fraction is smaller and FP_A is negative
	B	stop
a_smaller
	CMP	R10, #0
	BEQ	nega		; if FP_A's fraction is smaller and FP_A is positive
	B	stop
nega
	ADD	R0, R0, #0x80000000 ; turn the answer into negative
	B	stop

exit2
	MOV	R0, R8
	MOV	R1, R9
	BL	fpencode
	CMP	R5, R7
	BLO	a_e_s		; FP_A's absolute value is smaller
	CMP	R10, #0
	BNE	nega		; if FP_A's absolute value is larger and FP_A is negative
	B	stop
a_e_s
	CMP	R10, #0
	BEQ	nega		; if FP_A's absolute value is smaller and FP_A is positive
	
stop	B	stop


;
; fpfrac
; decodes an IEEE 754 floating point value to the signed (2's complement)
; fraction
; parameters:
;	r0 - ieee 754 float
; return:
;	r0 - fraction (signed 2's complement word)
;
fpfrac

	;
	; your decode subroutine goes here
	;
	PUSH	{R4, LR}
	MOV	R4, R0
	MOV 	R4, R4, LSL #9	; clear bit 1 - bit 9
	MOV 	R4, R4, LSR #9
	MOV	R0, R4
	POP	{R4, PC}

;
; fpexp
; decodes an IEEE 754 floating point value to the signed (2's complement)
; exponent
; parameters:
;	r0 - ieee 754 float
; return:
;	r0 - exponent (signed 2's complement word)
;
fpexp

	;
	; your decode subroutine goes here
	;
	PUSH	{R4, LR}
	MOV	R4, R0
	MOV	R4, R4, LSL #1	; clear bit 1
	MOV	R4, R4, LSR #24	; remove bit 9 - bit 32
	MOV	R0, R4
	POP	{R4, PC}

;
; fpencode
; encodes an IEEE 754 value using a specified fraction and exponent
; parameters:
;	r0 - fraction (signed 2's complement word)
;	r1 - exponent (signed 2's complement word)
; result:
;	r0 - ieee 754 float
;
fpencode

	;
	; your encode subroutine goes here
	;
	PUSH	{R4-R5, LR}
	MOV	R4, R0
	MOV	R5, R1
	MOV	R5, R5, LSL #23
	ADD	R4, R4, R5
	MOV	R0, R4
	POP	{R4-R5, PC}

	END
