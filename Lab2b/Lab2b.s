; ****************>>> WORKS <<<<<********************  8/15/2020
;        Roman Lopez Ph. D.
;        This program move values from ROM (0x08) to RAM (0x20000000)
;;;     DEFINITION AREA :::::::::::::::::::::::::::::::::

		;Constant Start at 0x08
		AREA MyConstant,CODE,READONLY
		;>>>>>>> Insert your Constant here <<<<<<<<<<<<<<<<
;;;XX1		DCB 0x1A,0x2B,0x3C,0x4D,0x5E,0x6F,0x22,0x33,0x44,0x55,0x66,0x77,0x88,0x99,0x00,0x00		; --> Original XX1 Table
XX1		DCB 0x12,0xA6,0X67,0XCD,0XCC,0XA3,0XA9,0X68,0X07,0XFF
		DCD 0x12345678,0X9ABCDEF0	
        ALIGN 2

		;Variables Start at 0x20000000
		AREA MyVariables,DATA,READWRITE
		;>>>>>>> Insert your Variables here <<<<<<<<<<<<<
XX2		SPACE 0x10
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
	LDR R0,=XX1 		;Get the start address (souce data)
	LDR R1,=XX2         ;Get the start address (destination Data)
; Read the valus from Memory	
	LDRB R2,[R0]		;Indirect Address Mode
	LDRB R3,[R0,#1]		;Indexet with Offset Address Mode
	LDRB R4,[R0],#1		;Pos-indexed Address Mode
	LDRB R5,[R0,#3]!	;Pre-Indexed Address mode
	MOV  R6,#0x2
	LDRB R7,[R0,R6]
; Write the values to Memory
	STRB R2,[R1]		;store the fisrt value
	STRB R3,[R1,#1]!		;store the second value
	STRB R4,[R1,#1]
	STRB R5,[R1,#3]!
	STRB R6,[R1],#4
	NOP
	NOP
	ALIGN 4
	END
		
		