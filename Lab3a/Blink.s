 		;***************** Program Three Color_asm *************************************************************
;		Assembly Prorgram for Tiva C Series TMC123GHPM
;		Assembly and initialized table coeff into data section (EPROM)
;		Blink RED -> BLUE -> GREEN -> WHITE -->
;		Roman Lopez Ph. D.				6/22/2017
; ****************>>> WORKS <<<<<********************  8/15/2020
;        Roman Lopez Ph. D.
;        This porgram how to configure your assembly file
;;;     DEFINITION AREA :::::::::::::::::::::::::::::::::
		PRESERVE8
		THUMB					;Marks	the	THUMB mode of operation
		EXPORT Start			; Global variable
		;Constant Start at 0x08
		AREA MyConstant,CODE,READONLY
		;>>>>>>> Insert your Constant here <<<<<<<<<<
		ALIGN 4
		;System Register Definition

;;;Port F can be analogous in-out port; as well, as that of communication with all of its protocols.;;;

SYSCTL_RCGC2_R 		EQU 	0x400FE108		
SYSCTL_RCGC2_Data   EQU 	0x00000020		;the magic number to LOCK register

GPIO_PORTF_DATA_R  EQU 0x400253FC
GPIO_PORTF_DIR_R   EQU 0x40025400
GPIO_PORTF_AFSEL_R EQU 0x40025420
GPIO_PORTF_DEN_R   EQU 0x4002551C
GPIO_PORTF_AMSEL_R EQU 0x40025528
GPIO_PORTF_PCTL_R  EQU 0x4002552C
		;Variables Start at 0x20000000
		AREA MyVariables,DATA,READWRITE
		;>>>>>>> Insert your Variables here <<<<<<<<<
;>>>>>>>>>>>>>>>>>> TEXT AREA (PROGRAMS< CONSTANT, TABLES, Etc ) <<<<<<<<<<<<<<<<<<<<<<<
;        Program area start at 0x08

		AREA MyPROGRAM, CODE, READONLY, ALIGN=2
		

		;Marks the starting point of thecode execution

		IMPORT Delay

	;>>>>>>> Insert your program here <<<<<<<<<<<<<
	;>>>>>>>By Default the program at 0x1C <<<<<<<<<		
		ENTRY
		;Main program
Start
		BL	Init_GPIOF				;Jump to Init_GPIOF subroutine to setup PORTF
		LDR R0,=GPIO_PORTF_DATA_R	;R0 Point PORTF I/O
		MOV R1,#0x0
		STR R1,[R0]					;Turn Off The LEDs
Loop    
		BL GREEN_LED
		BL YELLOW_LED
		BL RED_LED
		;BL BLUE_LED
		;BL WHITE_LED
 		B Loop
		;Subroutine to Turn on the RED LED

RED_LED
 		PUSH {R1,R2,LR}				;Push into stak Registers
 		MOV R1,#0x02
 		STR R1,[R0]					;Turn on Red LED
 		MOV R3,#5
  		BL Delay					;Delay one second
		BL Delay					;Delay another second (2)
 		MOV R1,#0X00
 		STR R1,[R0]					;Turn off Red LED
		MOV R3,#5
  		BL Delay					;Delay one second
		POP {R1,R2,LR}
		BX LR						;Return from Subroutine

		;Subroutine to Turn on the Blue LED

BLUE_LED
 		PUSH {R1,R2,LR}				;Push into stak Registers
 		MOV R1,#0x4
 		STR R1,[R0]					;Turn on Blue LED
 		MOV R3,#5
 		BL Delay					;Delay one second
 		MOV R1,#0x0
 		STR R1,[R0]					;Turn off Red LED
		MOV R3,#5
  		BL Delay					;Delay one second
		POP {R1,R2,LR}
		BX LR						;Return from Subroutine
		;Subroutine to Turn on the Gren LED

GREEN_LED
 		PUSH {R1,R2,LR}				;Push into stak Registers
 		MOV R1,#0x08
 		STR R1,[R0]					;Turn on Green LED
 		MOV R3,#5
 		BL Delay					;Delay one second
		BL Delay					;Delay another second (2)
		BL Delay					;Delay another second (3)
		BL Delay					;Delay one last second (4)
 		MOV R1,#0x0
 		STR R1,[R0]					;Turn off Red LED
		MOV R3,#5
  		BL Delay					;Delay one second
		POP {R1,R2,LR}
		BX LR						;Return from Subroutine

WHITE_LED
 		PUSH {R1,R2,LR}				;Push into stak Registers
 		MOV R1,#0x0E
 		STR R1,[R0]					;Turn on Green LED
 		MOV R3,#5
 		BL Delay					;Delay one second
 		MOV R1,#0x0
 		STR R1,[R0]					;Turn off Red LED
		MOV R3,#5
  		BL Delay					;Delay one second
		POP {R1,R2,LR}
		BX LR						;Return from Subroutine

YELLOW_LED
 		PUSH {R1,R2,LR}				;Push into stak Registers
 		MOV R1,#0x0A
 		STR R1,[R0]					;Turn on Yellow LED
 		MOV R3,#5
 		BL Delay					;Delay one second
		BL Delay					;Delay another second (2)
		BL Delay					;Delay... (3)
		BL Delay					;Finally! (4)
 		MOV R1,#0x0
 		STR R1,[R0]					;Turn off Red LED
		MOV R3,#5
  		BL Delay					;Delay one second
		POP {R1,R2,LR}
		BX LR						;Return from Subroutine

;		Function to Init the GPIOF

Init_GPIOF
		PUSH {R0,R1,LR}
		LDR R0,=SYSCTL_RCGC2_R		;
		LDR R1,=SYSCTL_RCGC2_Data	;Load the magic number to UNLOCK register
		LDR R2,[R0]
		ORR R1,R1,R2				;Merge with PORTF bit
 		STR R1,[R0] 				;Writing the magic number to LOCK register PORTF
		NOP							;waiting after enabling the clock
		NOP
		NOP
		NOP

		LDR R0,=GPIO_PORTF_DIR_R		;Setting the direction  PORTF IO pins
 		MOV R1,#0x0E
 		STR R1,[R0]

		LDR R0,=GPIO_PORTF_DEN_R		;Enable digital I/O on PF4-0
 		MOV R1,#0x1F
 		STR R1,[R0]
 		POP {R0,R1,LR}
 		BX LR
		ALIGN 4
		END
			
			
		
		
