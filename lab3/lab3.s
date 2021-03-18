;
; CS1021 2018/2019	Lab 3
; 

	AREA	RESET, CODE, READONLY
	ENTRY

;
; Q1 - Compute the greatest common divisor of a and b.
;

	
	LDR	R0, =406	; a = 406
	LDR	R1, =555	; b = 555
	
LOOP1	CMP	R0, R1		; a = b?
	BEQ	END1		; if so, end
	CMP	R0, R1		; a > b?
	BLS	ELSE1		
	SUB	R0, R0, R1	; R0 = a - b 
	B	LOOP1		; repeat
ELSE1	SUB	R1, R1, R0	; R1 = b - a 
	B	LOOP1		; repeat
	
END1	
	



;
; Q2 - Compute the nth Fibonacci Number using 64-bit unsigned arithmetic 
;
		
	MOV	R0, #0
	MOV	R1, #1		; Fn - 2 = 1
	
	MOV	R2, #0
	MOV	R3, #0		; Fn - 1 = 0
	
	MOV	R6, #48  	; n = 48
	
	
LOOP2	CMP	R6, #1		; n > 1?
	BLS	END2		; If not, end
	MOV	R4, R0		
	MOV	R5, R1		; tmp = Fn - 2
	
	
	ADDS	R1, R1, R3
	ADC	R0, R0, R2
	
	MOV	R2, R4
	MOV	R3, R5
	
	SUB	R6, R6, #1
	
	B	LOOP2		; repeat
	
END2	


;
; Q3 - Compute the largest possible Fibonacci number using 64-bit signed arithmetic 
;

	MOV	R0, #0
	MOV	R1, #1		; Fn - 2 = 1
	
	MOV	R2, #0
	MOV	R3, #0		; Fn - 1 = 1
	
	MOV	R6, #1		; n = 1
	
	LDR	R4, =0x7FFFFFFF	
	LDR	R5, =0xFFFFFFFF 	; MAX = 0x7FFFFFFF FFFFFFFF
	
	
LOOP3	ADD	R6, R6, #1	; n = n + 1

	MOV	R7, R0
	MOV	R8, R1		; tmp = Fn - 2
	
	
	ADDS	R1, R1, R3
	ADC	R0, R0, R2	; Fn = (Fn - 1) + (Fn - 2)

	MOV	R2, R7		
	MOV	R3, R8		; (Fn - 1) = tmp

	
	SUBS	R9, R4, R2	
	SBC	R10, R5, R3	; R8:R9 = MAX - (Fn - 1)

	
	CMP	R9, R0		; R8:R9 < (Fn - 2) ?
	BGE	LOOP3		; Repeat
	B	END3		; Else, end
	
END3	

		
STOP	B	STOP		; infinite loop to end

        END







