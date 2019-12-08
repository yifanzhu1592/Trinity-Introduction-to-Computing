;
; CSU11021 Introduction to Computing I 2019/2020
; 64-bit Shift
;

	AREA	RESET, CODE, READONLY
	ENTRY

	LDR	R1, =0xbabababa		; most significaint 32 bits (63 ... 32)
	LDR	R0, =0xABBababa		; least significant 32 bits (31 ... 0)
	LDR	R2, =-2			; shift count

	;
	; Write your program here
	;
	
	CMP	R2, #0			; if shift count > 0
	BLT	SHIFT_LEFT
	MOV	R4, R2			; R4 = shift count
WHILE1
	CMP	R4, #0			; if shift count != 0
	BEQ	STOP
	AND	R3, R1, #1		; R3 = last bit of R1
	MOV	R3, R3, LSL #31		; R3 = 2^31 * R3
	MOV	R1, R1, LSR #1		; R1 >> 1
	MOV	R0, R0, LSR #1		; R0 >> 1
	ORR	R0, R0, R3		; R0's first bit = R1's last bit
	SUB	R4, R4, #1		; count--
	B	WHILE1
SHIFT_LEFT
	MVN	R4, R2
	ADD	R4, R4, #1		; R4 = |shift count|
WHILE2
	CMP	R4, #0			; if shift count != 0
	BEQ	STOP
	AND	R3, R0, #0x80000000	; R3 = first bit of R0
	MOV	R3, R3, LSR #31		; R3 = R3 / 2^31
	MOV	R1, R1, LSL #1		; R1 << 1
	MOV	R0, R0, LSL #1		; R0 << 1
	ORR	R1, R1, R3		; R1's last bit = R0's first bit
	SUB	R4, R4, #1		; count--
	B	WHILE2

STOP	B	STOP

	END
