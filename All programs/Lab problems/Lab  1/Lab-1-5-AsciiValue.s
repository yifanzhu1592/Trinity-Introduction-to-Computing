;
; CSU11021 Introduction to Computing I 2019/2020
; Convert a sequence of ASCII digits to the value they represent
;

	AREA	RESET, CODE, READONLY
	ENTRY

	LDR	R1, ='2'	; Load R1 with ASCII code for symbol '2'
	LDR	R2, ='0'	; Load R2 with ASCII code for symbol '0'
	LDR	R3, ='3'	; Load R3 with ASCII code for symbol '3'
	LDR	R4, ='4'	; Load R4 with ASCII code for symbol '4'

	; your program goes here
	MOV	R5, #0x30
	SUB	R4, R4, R5	; R4=4
	SUB	R3, R3, R5	; R3=3
	SUB	R2, R2, R5	; R2=0
	SUB	R1, R1, R5	; R1=2
	MOV	R5, #10
	MUL	R3, R5, R3	; R3=30
	MOV	R5, #100
	MUL	R2, R5, R2	; R2=000
	MOV	R5, #1000
	MUL	R1, R5, R1	; R1=2000
	MOV	R0, #0
	ADD	R0, R0, R1	; R0=2000
	ADD	R0, R0, R2	; R0=2000
	ADD	R0, R0, R3	; R0=2030
	ADD	R0, R0, R4	; R0=2034

STOP	B	STOP

	END
