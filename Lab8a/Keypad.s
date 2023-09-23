 ;	KeyPad.asm
 ; 			4 X 4
 ;			Roman Lopez
 ;					Jun/9/2018
 ;    Keypad Organization
 ;    0  1  2  3
 ;    4  5  6  7
 ;    8  9  A  B
 ;    A  D  C  F
 ;
 ;       Rows             Cols
 ;                (Connet a Pull up Resistor)
 ;    R1 -> Pb0        C1 -> Pb4
 ;    R2 -> Pb1        C2 -> Pb5
 ;    R3 -> Pb2        C3 -> Pb6
 ;    R4 -> Pb3        C4 -> Pb6
 ;
 ;   Very Important Note:
 ;        Connect a pull up Resistor (5K to 10K) to C1,C2,C3 & C4
 ;
; Register Definitions
;	Input:
;		R0 - address of string
;
;	Output:
;		R0 - computed length of the supplied string
;
;	Working Registers:
;		R5 - current string byte
;		R6 - length counter
; NOTE: go to Termianl >Serial Windows>Select UART #1
;Or active Termite on stand along Tiva

	thumb
	EXPORT KeyPad
	EXPORT PB_pull_Resistor
	IMPORT GPIO_PORTB_DIR_R
	IMPORT GPIO_PORTB_PUR_R
	IMPORT PORTB_Init
	IMPORT PORTF_Init
	IMPORT GPIO_PORTF_DATA_R		
	IMPORT GPIO_PORTB_DATA_R
    AREA    |.text|, CODE, READONLY, ALIGN=2

;	Enable the pull-Up resitor PortB (PB7-PB4)
PB_pull_Resistor
	PUSH {R0-R1,LR}
	LDR r0,=GPIO_PORTB_PUR_R
	MOV r1,#0xF0					;Enable pull up resistor PB7-PB4
 	STR r1,[r0]
	POP {R0-R1,LR}
	BX	LR
;SUBROUINE KEYPAD Scand the keypad and return the key in R0
;Used THe PORTB
KeyPad
	;Setup PortB as 7->4 Input, 3->0 Ouput
	;Init PortB
	PUSH {R1-R6,LR}
	LDR r0,=GPIO_PORTB_DIR_R		;Setting the direction PORTB (out) IO pins
 	MOV r1,#0x0F
 	STR r1,[r0]
	LDR R0,=GPIO_PORTB_DATA_R
	LDR r7,=GPIO_PORTF_DATA_R
	MOV r9,#0x0
Loop
	mov r2,#0xFE
	mov r5,#0
	;r2 -> Rows (Pb0->Pb3)
	;r2 -> Cols (Pb4->pb7)
Loop1
	strb r2,[r0]			;Out Rows
	nop
	nop
	nop
	ldrb r3,[r0]			;Get Coluns
;*************************************
;    mov R3,#0xE0
;	B Get_TheKew
;***********************	
	and R3,R3,#0xF0
	CMP r3,#0xF0			;See if a key was pressed
	beq No_Key

	;Press and releazed a key
Wait_Key
	mov r8,r3
	ldrb r6,[r0]			;Read Keyboad
	and r6,r6,#0xF0
	;wait until key is realesed
	cmp r6,#0xF0
	bne Wait_Key

	mov r4,#00				;If col 0 is selected set r4=0
	cmp r3,#0xE0
	beq Get_TheKew
	add r4,#1				;If col 0 is selected set r4=1
	cmp r3,#0xD0
	beq Get_TheKew
	add r4,#1				;If col 0 is selected set r4=2
	cmp r3,#0xB0
	beq Get_TheKew
	add r4,#1				;If col 0 is selected set r4=3
	cmp r3,#0x70
	beq Get_TheKew			;if a key is pressed go to idenified it
	LSL r2,r2,#1			;if no was pressed, inspect the next row
	cmp r2,#0xFF
	beq	Loop
	b Loop1					;if no key is pressed, start again the scand

;  Set the row numbers
No_Key						;go to the next row
	lsl r2,#1
	orr r2,#1
	and r2,#0x00FF
	add r5,#1
	cmp r5,#5
	bge Loop
;*******
;	mov R0,#0xAA
;	B End_program
;******************
	B 	Loop1

	;Get the key from the table
Get_TheKew
	cmp r8,#0xE0
	beq LED0
	bne LED1
	
	
Get_TheKew1
	mov r0,#4
	mul r5,r5,r0
	add r5,r5,r4
	adr r1,KeyMap		;Get the start Address of KeyMap
	ldrb r0,[r1,r5]		;Get the Char Key
End_program
	POP {R1-R6,LR}
	BX	LR
LED0
	mov r9,#0x02
	str r9,[r7]
	mov r8,#0x00
	b Get_TheKew1
LED1
	mov r9,#0x00
	str r9,[r7]
	mov r8,#0x00
	b Get_TheKew1

	align 4
	; KEY MAP
	; 0 1 2 3
	; 4 5 6 7
	; 8 9 A B
	; C D E F

KeyMap
	DCB 0,1,2,3,4,5,6,7,8,9,0xA,0xB,0xC,0xD,0xE,0xF
	END
