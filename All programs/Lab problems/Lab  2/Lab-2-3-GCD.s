;
; CSU11021 Introduction to Computing I 2019/2020
; GCD
;

	AREA	RESET, CODE, READONLY
	ENTRY
	
	LDR	R2, =24		; R2 = 24
	LDR	R3, =32		; R3 = 32
	
while
	CMP	R2, R3		
	BEQ	endwh		; if (R2 == R3)
	BLS	elseb		; if (R2 > R3)
	SUB	R2, R2, R3	; R2 = R2 - R3
	B	enda
elseb				; else
	SUB	R3, R3, R2	; R3 = R3 - R2
enda
	B	while
endwh

	MOV	R0, R2		; R0 = R2

STOP	B	STOP

	END
