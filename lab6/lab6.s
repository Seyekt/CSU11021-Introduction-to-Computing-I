;
; CS1021 2018/2019	Lab 6
;
; RAM @ 0x4000000 sz = 0x10000 (64K)
;

;
; hardware registers
;

PINSEL0	EQU	0xE002C000
	
U0RBR	EQU	0xE000C000
U0THR	EQU	0xE000C000
U0LCR	EQU	0xE000C00C
U0LSR	EQU	0xE000C014
	
	
	AREA	RESET, CODE, READONLY
	ENTRY	
	
;	
; hardware initialisation
;
	LDR	R13, =0x40010000	; initialse SP
	LDR	R0, =PINSEL0	; enable UART0 TxD and RxD signals
	MOV	R1, #0x50
	STRB	R1, [R0]
	LDR	R0, =U0LCR	; 7 data bits + parity
	LDR	R1, =0x02
	STRB	R1, [R0]

;
; Sieve of Eratosthenes
;

;Input

	;LDR	R0, =STR0		; R0 -> "Please enter a word: "
	;BL	PUTS		; put string
	;LDR	R4, =0x40000000	; load memory address
;LOOP1	BL	GET		; get character
	;BL	PUT		; put character
	;CMP	R0, #0x0d		; is the character 'enter'?
	;BEQ	readEnd1		; if so, end read
;;	SUB	R0, R0, #0x30
	;STR	R0, [R4], #1	; store and increment
	;B	LOOP1		; repeat
	
;readEnd1



; CONVERT TO HEX

	;LDR	R4, =0x40000000	; load memory address
	;MOV	R6, #1
	
;LOOP2	LDR	R5, [R4], #1
	;CMP	R5, #0	
	;BEQ	END69
	;ADD	R6, R6, #1
	;SUB	R5, R5, #0x30
	
	;B	LOOP2

;END69

;	LDR, R12, #1000		; N = 1000

; Set all bits in RAM TO 1
; 100000 / 32 = 3125
; Start at 0x400030D4
	
	MOV	R11, #0
	LDR	R4, =0x40000000
	
LOOPA	LDR	R12, =0xC35	; 3125
	CMP	R11, R12	
	BHS	ENDA
	
	LDR	R5, =0xFFFFFFFF
	STR	R5, [R4], #4
	
	ADD	R11, R11, #1
	B	LOOPA

ENDA


;
;Sieve
;


	
STOP	B	STOP

STR0	DCB	"Please enter an integer: ", 0x0a, 0, 0
STR1	DCB	"\nPlease enter another word:", 0x0a, 0, 0

;
; subroutines
;

; DIV 
;
; leaf function 
;
;
;	DIVIDE
;
;	MOV	R0, #200	; N
;	MOV	R1, #2		; D
;	BL	DIV	


DIV	PUSH {R4-R7}
	
	MOV	R2, #0		; Q = 0
	MOV	R3, #0		; R = 0

	MOV	R4, R0		; R4 = R0
LOOP3	MOVS    R4, R4, LSL#1	; shift R4 >> 1
	ADDCC	R5, R5, #1	; R5++
	BCS	TOTAL		; end loop
	B	LOOP3		; repeat
    
TOTAL	RSB	R4, R5, #32	; R4 = n
    
LOOP4	SUB	R5, R4, #1	; R5 = i
	CMP	R5, #0		; R5 = 0
	MOV	R4, R5		; R4 = R5
	BLT	END4		; end loop
	MOV	R3, R3, LSL#1	; shift R3 << 1
    
	MOV	R6, #1		; R6 = 1
	MOV	R6, R6, LSL R5	; shift R6 << i
	AND	R6, R0, R6	; AND N & R6

	MOV	R6, R6, LSR R5	; shift R6 >> R5
	BIC	R3, R3, #1	; bit clear
	ADD	R3, R3, R6	; R3 = R3 + R6

	CMP	R3, R1		; R3 >= R1?
	BLO	LOOP4		; restart loop
	
	SUB	R3, R3, R1	; R3 = R3 - R1
	LDR	R7, =1		; R7 = 1
	MOV	R7, R7, LSL R5	; shift R7 << R5
	BIC	R2, R2, R5	; bit clear
	ADD	R2, R2, R7	; R2 = R2 + R7
	B	LOOP4		; repeat
    
END4
	MOV	R0, R2		; R0 = R2
	MOV	R1, R3		; R1 = R3
	POP	{R4-R7}
	BX	LR		; return

;
; GET
;
; leaf function which returns ASCII character typed in UART #1 window in R0
;
GET	LDR	R1, =U0LSR		; R1 -> U0LSR (Line Status Register)
GET0	LDR	R0, [R1]		; wait until
	ANDS	R0, #0x01		; receiver data
	BEQ	GET0			; ready
	LDR	R1, =U0RBR		; R1 -> U0RBR (Receiver Buffer Register)
	LDRB	R0, [R1]		; get received data
	BX	LR			; return

;	
; PUT
;
; leaf function which sends ASCII character in R0 to UART #1 window
;
PUT	LDR	R1, =U0LSR		; R1 -> U0LSR (Line Status Register)
	LDRB	R1, [R1]		; wait until transmit
	ANDS	R1, R1, #0x20		; holding register
	BEQ	PUT			; empty
	LDR	R1, =U0THR		; R1 -> U0THR
	STRB	R0, [R1]		; output charcter
PUT0	LDR	R1, =U0LSR		; R1 -> U0LSR
	LDRB	R1, [R1]		; wait until 
	ANDS	R1, R1, #0x40		; transmitter
	BEQ	PUT0			; empty (data flushed)
	BX	LR			; return

;	
; PUTS
;
; sends NUL terminated ASCII string (address in R0) to UART #1 window
;
PUTS	PUSH	{R4, LR} 		; push R4 and LR
	MOV	R4, R0			; copy R0
PUTS0	LDRB	R0, [R4], #1		; get character + increment R4
	CMP	R0, #0			; 0?
	BEQ	PUTS1			; return
	BL	PUT			; put character
	B	PUTS0			; next character
PUTS1	POP	{R4, PC} 		; pop R4 and PC
	
	END