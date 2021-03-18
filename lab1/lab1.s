;
; CS1021 2018/2019	Lab 1
; 

	AREA	RESET, CODE, READONLY
	ENTRY

;
; start of code
;
	LDR	R1, =5  	; x = 5
	LDR	R2, =6		; y = 6
	LDR	R3, =2		; z = 2

;
; compute x*x + y + 4 (35 or 0x23)
;
	MUL	R0, R1, R1	; R0 = x*x
	ADD	R0, R0, R2	; R0 = x*x + y
	ADD	R0, R0, #4	; R0 = x*x + y + 4
;
; add your code here
;
	;Q1: compute 3x^2 + 5x

	MUL R4, R1, R1	; R4 = x^2
	MOV R5, #3		; R5 = 3
	MUL R0, R4, R5	; R0 = 3x^2

	MOV R4, #5		; R4 = 5
	MUL R5, R1, R4	; R5 = 5x

	ADD R0, R0, R5	; R0 = 3x^2 + 5x

	;Q2: compute  2x^2 + 6xy + 3y^2

	
	MUL R4, R1, R1	; R4 = x^2
	MOV R5, #2		; R5 = 2
	MUL R0, R4, R5	; R0 = 2x^2
	
	MUL R4, R1, R2	; R4 = xy
	MOV R5, #6		; R5 = 6
	MUL R6, R4, R5	; R6 = 6xy
	
	MUL R4, R2, R2	; R4 = y^2
	MOV R5, #3		; R5 = 3
	MUL R7, R5, R4	; R7 = 3y^2
	
	ADD R0, R0, R6	; R0 = 2x^2 + 6xy
	ADD R0, R0, R7	; R0 = 2x^2 + 6xy + 3y^2
	
	;Q3: compute  x^3 - 4x^2 + 3x + 8
	
	MUL R0, R1, R1	; x^2
	MUL R0, R1, R0	; x^3
	
	MUL R4, R1, R1	; R4 = x^2
	MOV R5, #4		; R5 = 4
	MUL R6, R4, R5	; R6 = 4x^2
	
	MOV R4, #3		; R4 = 3
	MUL R7, R4, R1	; R7 = 3x
	
	MOV R8, #8		; R8 = 8
	
	SUB R0, R0, R6	; R0 = x^3 - 4x^2
	ADD R0, R0, R7	; R0 = x^3 - 4x^2 + 3x
	ADD R0, R0, R8	; R0 = x^3 - 4x^2 + 3x + 8
	
	
	;Q4 compute 3x^4 - 5x – 16(y^4)(z^4)
	
	MUL R4, R1, R1	; R0 = x^2
	MUL R0, R4, R4	; R0 = x^4
	MOV R4, #3		; R4 = 3
	MUL R0, R4, R0	; R0 = 3x^4
	
	MOV R5, #5		; R5 = 5
	MUL R6, R5, R1	; R6 = 5x
	

	MOV R5, #16		; R5 = 16
	
	MUL R4, R2, R2	; R4 = y^2
	MUL R7, R4, R4 	; R4 = y^4
	
	MUL R4, R3, R3	; R4 = z^2
	MUL R8, R4, R4	; R8 = z^4
	
	MUL R4, R5, R7	; R4 = 16y^4
	MUL R4, R8, R4	; R4 = 16(y^4)(z^4)
	
	SUB R0, R0, R6	; R0 = 3x^4 - 5x
	SUB R0, R0, R4	; R0 = 3x^4 - 5x - 16(y^4)(z^4)


L	B	L		; infinite loop to end programme

        END
