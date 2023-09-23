;   Program Seven_segmet.s
;   Send a pater to the Seven segmet
;   Roman Lopez B.
;   September 5, 2020
;   !WORKs
	
		IMPORT  PORTF_Init
		IMPORT GPIO_PORTF_DATA_R
		IMPORT  PORTB_Init
		IMPORT GPIO_PORTB_DATA_R
		IMPORT SysTick_Disable
		IMPORT SysTick_Init
		IMPORT SysTick_Wait10ms
		IMPORT SysTick_Wait
		;Constant Start at 0x08
		AREA MyConstant,CODE,READONLY
Seg_Pat			;This the paterm to be displayed in the Seven Segment
		;DCB 	0X3F,0X2,0X4,0X8,0X10,0X20,0x01,0x20,0X10,0X08,0x04,0x02,0x01,0XAA
		DCB		0X3F,0X06,0X5B,0X4F,0X66,0X6D,0X7D,0X07,0X7F,0X67	; (0-9) 7-Segment Display Table
		ALIGN 4
;M         EQU 0x007FFFF			;Delay constant
        AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
        EXPORT  Start
		IMPORT SysTick_Init
		IMPORT SysTick_Wait	
Start

		BL  PORTF_Init                  ; initialize PF0 and PF4 as input and PF1, PF2 and PF3 as output
		BL  PORTB_Init                  ; initialize PB0 to PB7 as output
		BL  SysTick_Init
	    LDR R0,=GPIO_PORTB_DATA_R		;R0 Point PORTB Data

;Loop0	LDR  R1,=Seg_Pat
;Loop1	LDRB R2,[R1],#1
;		CMP  R2,#0XAA
;		BEQ  Loop0
;		MVN R3,R2						;Use this command if you LED ia Common Anode
;;		STRB R2,[R0]					;Send the seven segmen code to LEDs
;		STRB R3,[R0]					;Turn Off The LEDs		
;		BL SysTick_Wait					;Delay one second
;		BL SysTick_Wait					;Delay one second
;		BL SysTick_Wait					;Delay one second
;		BL SysTick_Wait					;Delay one second
;		BL SysTick_Wait					;Delay one second
;		
;		B   Loop1

MAIN
	LDR R4,=GPIO_PORTF_DATA_R
	LDR R1,=Seg_Pat
LOOP_MAIN
	LDR R5,[R4]
	AND R5,R5,#0X11
	CMP R5,#0X01
	BEQ	DES_DISPLAY1
	
	CMP R5,#0X10
	BEQ ASC_DISPLAY1
	
	MOV R3,#0X00
	STRB R3,[R0]
	
	B LOOP_MAIN
	
DES_DISPLAY1
	LDR R1,=Seg_Pat
	LDRB R2,[R1]
	B DES_DISPLAY2
DES_DISPLAY2
	MVN R3,R2
	STRB R3,[R0]
	LDRB R2,[R1],#1
	BL SysTick_Wait
	BL SysTick_Wait
	BL SysTick_Wait
	BL SysTick_Wait
	BL SysTick_Wait
	BL SysTick_Wait
	BL SysTick_Wait
	BL SysTick_Wait
	CMP R2,#0X67
	LDRB R2,[R1]
	MVN R3,R2
	STRB R3,[R0]
	BNE DES_DISPLAY2
	;CMP R4,#0X10
	;BEQ LOOP_MAIN
	B DES_DISPLAY1
	
ASC_DISPLAY1
	LDR R1,=Seg_Pat
	LDRB R2,[R1],#9
	B ASC_DISPLAY2
ASC_DISPLAY2
	MVN R3,R2
	STRB R3,[R0]
	LDRB R2,[R1],#-1
	BL SysTick_Wait
	BL SysTick_Wait
	BL SysTick_Wait
	BL SysTick_Wait
	BL SysTick_Wait
	BL SysTick_Wait
	BL SysTick_Wait
	BL SysTick_Wait
	CMP R2,#0X3F
	BNE ASC_DISPLAY2
	;CMP R4,#0X01
	;BEQ LOOP_MAIN
	B ASC_DISPLAY1
    
	ALIGN                           ; make sure the end of this section is aligned

    END                             ; end of file
