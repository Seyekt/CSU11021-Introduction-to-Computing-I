;
; CS1021 2018/2019	Lab 2
; 

	AREA	RESET, CODE, READONLY
	ENTRY

;
; Q1 - Compute the nth Fibonacci Number
;

	
	MOV	R0, #1		; fn - 2 = 1
	MOV	R1, #0		; fn - 1 = 0
	MOV	R2, #16   	; n = 16
	
LOOP1	CMP	R2, #1
	BLS	END1		; end
	MOV	R3, R0
	ADD	R0, R1, R0
	MOV	R1, R3
	SUB	R2, R2, #1
	B	LOOP1		; repeat
END1	


;
; Q2 (i) Compute the largest possible Fibonacci number using 32-bit unsigned arithmetic 
;
	
	
	MOV	R0, #1		; fn - 2 = 1
	MOV	R1, #0		; fn - 1 = 0
	MOV	R2, #1		; n = 1
	LDR	R5, =0xFFFFFFFF	; MAX = 0xFFFFFFFF
	
	
LOOP2	ADD	R2, R2, #1	; n = n + 1
	MOV	R3, R0		; tmp = fn - 2
	ADD	R0, R1, R0	;
	MOV	R1, R3		;
	
	SUB 	R4, R5, R1	; Fx = MAX - Fn-1
	
	CMP	R4, R0		; Fx < Fn-2?
	BLS	END2		; end
	B	LOOP2		; repeat
	
END2

;
; Q2 (i) Compute the largest possible Fibonacci number using 32-bit signed arithmetic 
;

	MOV	R0, #1		; fn - 2 = 0
	MOV	R1, #0		; fn - 1 = 1
	MOV	R2, #1		; n = 1
	LDR	R5, =0x7FFFFFFF	; MAX = 0x7FFFFFFF
	
	
LOOP4	ADD	R2, R2, #1	;
	MOV	R3, R0		;
	ADD	R0, R1, R0	;
	MOV	R1, R3		;
	
	
	SUB 	R4, R5, R1	
	
	CMP	R4, R0
	BLE	END3
	
	B	LOOP4
	
END3	
	

		
STOP	B	STOP		; infinite loop to end

        END
