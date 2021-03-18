;
; CS1021 2018/2019	Lab 4
; 

	AREA	RESET, CODE, READONLY
	ENTRY

	LDR	R5, =0x40000000
	
	LDR	R4, =16		; N = numerator
	LDR	R5, =2		; D = divisor
	MOV	R6, #0		; Q = 0
	MOV	R7, #0		; R = 0

	MOV	R8, R4		; R8 = R4
LOOP3	MOVS	R8, R8, LSL#1	; shift R4 >> 1
	ADDCC	R9, R9, #1	; R5++
	BCS	TOTAL		; end loop
	B	LOOP3		; repeat
    
TOTAL	RSB	R8, R9, #32	; R8 = n
    
LOOP4	SUB	R9, R8, #1	; R9 = i
	CMP	R9, #0		; R5 = 0
	MOV	R8, R9		; R8 = R9
	BLT	END4		; end loop
	MOV	R7, R7, LSL#1	; shift R7 << 1
    
	MOV	R10, #1		; R10 = 1
	MOV	R10, R10, LSL R9	; shift R10 << i
	AND	R10, R4, R10	; AND N & R10

	MOV	R10, R10, LSR R9	; shift R6 >> R5
	BIC	R7, R7, #1	; bit clear
	ADD	R7, R7, R10	; R7 = R7 + R6

	CMP	R7, R5		; R7 >= R5?
	BLO	LOOP4		; restart loop
	
	SUB	R7, R7, R5	; R7 = R7 - R5
	LDR	R11, =1		; R11 = 1
	MOV	R11, R11, LSL R9	; shift R11 << R9
	BIC	R6, R6, R9	; bit clear
	ADD	R6, R6, R11	; R6 = R6 + R11
	B	LOOP4		; repeat
    
END4
	MOV	R4, R6		; R4 = R6
	MOV	R5, R7		; R5 = R7
		
STOP	B	STOP		; infinite loop to end

        END

