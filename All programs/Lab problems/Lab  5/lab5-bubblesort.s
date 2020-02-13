;
; CS1022 Introduction to Computing II 2019/2020
; Lab 1B - Bubble Sort
;

N	EQU	10

	AREA	globals, DATA, READWRITE

; N word-size values

SORTED	SPACE	N*4		; N words (4 bytes each)


	AREA	RESET, CODE, READONLY
	ENTRY


	;
	; copy the test data into RAM
	;

	LDR	R4, =SORTED
	LDR	R5, =UNSORT
	LDR	R6, =0
whInit	CMP	R6, #N
	BHS	eWhInit
	LDR	R7, [R5, R6, LSL #2]
	STR	R7, [R4, R6, LSL #2]
	ADD	R6, R6, #1
	B	whInit
eWhInit

	LDR	R4, =SORTED
	LDR	R5, =UNSORT

	;
	; your sort subroutine goes here
	;

WHILE					; do {
	MOV	R0, #0			; swapped = false ;
	MOV	R1, #1
FOR					; for ( i = 1 ; i < N; i ++) {
	CMP	R1, #N
	BHS	ENDFOR
	SUB	R2, R1, #1
	LDR	R3, [R4, R2, LSL #2]	; tmpswap = array[ i -1];
	LDR	R8, [R4, R1, LSL #2]
	CMP	R3, R8			; if ( array[i-1] > array[i] ) {
	BLS	ENDIFS
	STR	R8, [R4, R2, LSL #2]	; array[i-1] = array[i] ;
	STR	R3, [R4, R1, LSL #2]	; array[i] = tmpswap ;
	MOV	R0, #1			; swapped = true ;}}
ENDIFS
	ADD	R1, R1, #1
	B	FOR
ENDFOR
	CMP	R0, #1			; } while ( swapped ) ;
	BEQ	WHILE

UNSORT	DCD	9,3,0,1,6,2,4,7,8,5

	END
