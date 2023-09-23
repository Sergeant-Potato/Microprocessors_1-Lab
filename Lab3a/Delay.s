		AREA MyPROGRAM, CODE, READONLY, ALIGN=2
M 		EQU 0x82354					;Delay Constant
		EXPORT Delay	   
	 ;Subroutine Delay Reg R3 (Seconds To be Delay)
Delay
		PUSH {R2,R3,LR}				
Delay_Loop0
 		LDR R2,=M					;Set R2 =0x82354 for one (1) "sec"
Delay_Loop1
		SUB R2,#1					
		CMP R2,#0x0					
 		BNE Delay_Loop1				

 		SUB R3,#1					
 		CMP R3,#0					
 		BNE Delay_Loop0				
 		POP {R2,R3,LR}				
 		BX LR						;Return from Subroutine	
		ALIGN 4
		END							