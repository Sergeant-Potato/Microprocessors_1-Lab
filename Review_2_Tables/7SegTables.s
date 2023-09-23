; ****************>>> WORKS <<<<<********************  8/15/2020
;        Roman Lopez Ph. D.
;        This program move values from ROM (0x08) to RAM (0x20000000)
;;;     DEFINITION AREA :::::::::::::::::::::::::::::::::

		;Constant Start at 0x08
		AREA MyConstant,CODE,READONLY
		;>>>>>>> Insert your Constant here <<<<<<<<<<<<<<<<
;;;XX1		DCB 0x1A,0x2B,0x3C,0x4D,0x5E,0x6F,0x22,0x33,0x44,0x55,0x66,0x77,0x88,0x99,0x00,0x00		; --> Original XX1 Table
SSEGTABLE	DCB 0X3F,0X06,0X5B,0X4F,0X66,0X6D,0X7D,0X07,0X7F,0X6F
		DCD 0x12345678,0X9ABCDEF0	
        ALIGN 2

		;Variables Start at 0x20000000
		AREA MyVariables,DATA,READWRITE
		;>>>>>>> Insert your Variables here <<<<<<<<<<<<<
ETABLE		SPACE 0x10
;>>>>>>>>>>>>>>>>>> TEXT AREA (PROGRAMS< CONSTANT, TABLES, Etc ) <<<<<<<<<<<<<<<<<<<<<<<
;        Program area start at 0x08
;;;;;;;;;;The user code(program) is placed in 

		AREA MyPROGRAM, CODE, READONLY, ALIGN=2
		ENTRY

		;Marks the starting point of thecode execution
		EXPORT	Start

	;>>>>>>> Insert your program here <<<<<<<<<<<<<
	;>>>>>>>By Default the program at 0x1C <<<<<<<<<		
Start
	LDR R0,=SSEGTABLE 		;Get the start address (souce data)
	LDR R9,=ETABLE
	LDRB R1,[R0]
; Read the valus from Memory
MAIN
	CMP R1,#0X3F
	BEQ	DES_ORDER
	
	CMP R1,#0X6F
	BEQ ASC_ORDER

DES_ORDER
	STRB R1,[R9]
	LDRB R1,[R0],#1
	CMP	R1,#0X6F
	BNE DES_ORDER
	B MAIN
ASC_ORDER
	LDRB R1,[R0],#-1
	STRB R1,[R9]
	CMP	R1,#0X3F
	BNE ASC_ORDER
;	B MAIN
	B END_P
END_P
	NOP
	NOP
	ALIGN 4
	END
	
		