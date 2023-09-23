;   Program Blink_red.s
;   Swicht with Blink Red LED 
;   Roman Lopez B.
;   August 29, 2020
;   !WORKs
	IMPORT  PORTF_Init
	IMPORT GPIO_PORTF_DATA_R

M         EQU 0x00FFFF			;Delay constant
        AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
        EXPORT  Start
Start
;----------------------------------------------------------------
    	BL  PORTF_Init                  ; initialize PF0 and PF4 and make them inputs
Loop1	LDR R0,=GPIO_PORTF_DATA_R		;R0 Point PORTF Data
		MOV R1,#0x0
		STRB R1,[R0]					;Turn Off The LEDs
		
Loop2	LDR R4,=GPIO_PORTF_DATA_R		;R0 Point PORTF Data
		LDRB R5,[R4]					;Get switch Status
		AND  R5,R5,#0x11				;and R4 & b00010001
		
		CMP R5,#0x01						;Switch 1=On?
		BEQ  RED_LED						;Call Sub 
		
		CMP R5, #0x10
		BEQ BLUE_LED
		
		CMP R5, #0x00
		BEQ GREEN_LED
		
		B WHITE
		
 		B   Loop2
		
RED 	BL RED_LED
		B Loop2
BLUE 	BL BLUE_LED
		B Loop2
GREEN 	BL GREEN_LED
		B Loop2
WHITE	BL WHITE_LED
		B Loop2		
		;Subroutine to Turn on the RED LED
RED_LED
 		PUSH {R1,R2,LR}				;Push into stak Registers
 		MOV R1,#0x02
 		STR R1,[R0]					;Turn on Red LED
 		MOV R3,#5
  		BL Delay					;Delay one second
 		MOV R1,#0x0
 		STR R1,[R0]					;Turn off Red LED
		MOV R3,#5
  		BL Delay					;Delay one second
		POP {R1,R2,LR}
		BX LR						;Return from Subroutine

		;Subroutine to Turn on the Blue LED
BLUE_LED
 		PUSH {R1,R2,LR}				;Push into stak Registers
		MOV R1, #0x04
		STR R1, [R0]
		MOV R3, #5
		BL Delay
		MOV R1, #0x0
		STR R1, [R0]
		MOV R3, #5
		BL Delay
		POP {R1,R2,LR}
		BX LR						;Return from Subroutine
		;Subroutine to Turn on the Gren LED
GREEN_LED
 		PUSH {R1,R2,LR}				;Push into stak Registers
 	    MOV R1, #0x08
		STR R1, [R0]
		MOV R3, #5
		BL Delay
		MOV R1, #0x0
		STR R1, [R0]
		MOV R3, #5
		BL Delay
		POP {R1,R2,LR}
		BX LR						;Return from Subroutine
WHITE_LED
 		PUSH {R1,R2,LR}				;Push into stak Registers
		MOV R1, #0x0E
		STR R1, [R0]
		MOV R3, #5
		BL Delay
		MOV R1, #0x0
		STR R1, [R0]
		MOV R3, #5
		BL Delay
		POP {R1,R2,LR}
		BX LR						;Return from Subroutin	

;>>>>>> Subroutine Delay <<<<<<<<<<		
Delay   
		PUSH {R1,R2,R3,LR}
Delay_Loop0
 		LDR R2, =M 		;Set R2 =0x00FFFFFF
Delay_Loop1
		SUB R2,#1
		CMP R2,#0x0
 		BNE Delay_Loop1

 		SUB R3,#1
 		CMP R3,#0
 		BNE Delay_Loop0
 		POP {R1,R2,R3,LR}
 		BX LR		

    ALIGN                           ; make sure the end of this section is aligned
    END                             ; end of file
