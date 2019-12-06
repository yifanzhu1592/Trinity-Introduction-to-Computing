;
; CSU11021 Introduction to Computing I 2019/2020
; Proper Case
;

	AREA	RESET, CODE, READONLY
	ENTRY

	LDR	R0, =tststr	; address of existing string
	LDR	R1, =0x40000000	; address for new string

	LDR		R2, =1			; R2 = 1
while
	LDRB		R3, [R0]		; R3 = [R0]
	CMP		R3, #0			; R3 == 0
	BEQ		endWhile
	CMP		R3, #' '		; R3 == ' '
	BEQ		readyToStore
	CMP		R2, #1			; R2 == 1
	BNE		notFirstChar
	LDR		R2, =0			; R2 = 0
	CMP		R3, #'a'		; R2 == 'a'
	BLO		readyToStore
	SUB		R3, R3, #0x20		; R3 = R3 - 0x20
	B		readyToStore
notFirstChar
	LDR		R2, =0			; R2 = 0
	CMP		R3, #'Z'		; R3 == 'Z'
	BHI		readyToStore
	ADD		R3, R3, #0X20		; R3 = R3 + 0x20
readyToStore
	STRB		R3, [R1]		; [R1] = R3
	ADD		R0, R0, #1		; R0 = R0 + 1
	ADD		R1, R1, #1		; R1 = R1 + 1
	CMP		R3, #' '		; R3 == ' '
	BNE		while
	LDR		R2, =1			; R2 = 1
	B		while
endWhile

STOP	B	STOP

tststr	DCB	"HELLO world",0

	END
