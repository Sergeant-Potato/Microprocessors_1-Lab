;   Program DC_Motor.s
;   Turn On and OFF a DC motor for a few seconds
;   Used PORT B
;   Roman Lopez B.
;   January 30,2021
;   !WORKs
	
		IMPORT  PORTF_Init
		IMPORT  PORTB_Init
		IMPORT GPIO_PORTF_DATA_R
		IMPORT GPIO_PORTB_DATA_R
		AREA MyConstant,CODE,READONLY

		ALIGN 4
M       EQU 0x0000003F			;Delay constant
        AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
        EXPORT  Start

Start
		BL  PORTB_Init                  ; initialize PB0 to PB7 as output
	    LDR R0,=GPIO_PORTB_DATA_R		;R0 Point PORTB Data
		MOV R9,#0x00

Loop	MOV R4,#0x50
		;Incre R7=2
		MOV R7,#0
Loop0	MOV R8,#0X150				;R8 is the counter
		SUB R5,R4,R7			;R5 = Time Hight
		SUB R6,R4,R5			;R6 = Time Low
		CMP R9,#0x00
		BEQ Loop1
		BNE Loop2
		
Loop1	MOV R2,#0x01
		STRB R2,[R0]				;Turn Off Dc motor
		MOV  R3,R5			;Dela number of secod
		BL Delay					;Delay somes second
		MOV R2,#0x00
		STRB R2,[R0]						;Turn On Dc motor
		MOV  R3,R6				;Delay number of secod
		BL Delay					;Delay one second X R3
		SUBS R8,R8,#1
		BNE Loop1
		ADD R7,#1
		CMP R7,#0x50
		BLT Loop0
		MOV R9,#0X01
		B Loop
Loop2
		MOV R2,#0x02
		STRB R2,[R0]				;Turn Off Dc motor
		MOV  R3,R5			;Dela number of secod
		BL Delay					;Delay somes second
		MOV R2,#0x00
		STRB R2,[R0]						;Turn On Dc motor
		MOV  R3,R6				;Delay number of secod
		BL Delay					;Delay one second X R3
		SUBS R8,R8,#1
		BNE Loop2
		ADD R7,#1
		CMP R7,#0x50
		BLT Loop0
		MOV R9,#0X00
		B   Loop

;>>>>>> Subroutine Delay <<<<<<<<<<	
;		Reg R3  Number of seconds to be delayed
;       Reg R1  Constan M (one second delay)
Delay   
		PUSH {R0-R3,LR}
		CMP R3,#00
		BEQ Exit
Delay_Loop0
 		LDR R2, =M 		;Set R2 =0x00FFFFFF
Delay_Loop1
		SUB R2,#1
		CMP R2,#0x0
 		BNE Delay_Loop1
 		SUB R3,#1
 		CMP R3,#0
 		BNE Delay_Loop0
Exit 	POP {R0-R3,LR}
 		BX LR
		ALIGN 
		END                             ; end of file

		
		
		
		
