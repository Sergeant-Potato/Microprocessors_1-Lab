; ****************>>> WORKS <<<<<********************  8/15/2020
;        Roman Lopez Ph. D.
;        This program move values from ROM (0x08) to RAM (0x20000000)
;;;     DEFINITION AREA :::::::::::::::::::::::::::::::::

		;Constant Start at 0x08
		AREA MyConstant,CODE,READONLY
		;>>>>>>> Insert your Constant here <<<<<<<<<<<<<<<<
;;;XX1		DCB 0x1A,0x2B,0x3C,0x4D,0x5E,0x6F,0x22,0x33,0x44,0x55,0x66,0x77,0x88,0x99,0x00,0x00		; --> Original XX1 Table
TABLE		DCB 0X00,0X01,0X02,0X03,0X04,0X05,0X06,0X07,0X08,0X09,0X0A,0X0B,0X0C,0X0D,0X0E,0X0F
			DCB	0X10,0X11,0X12,0X13,0X14,0X15,0X16,0X17,0X18,0X19,0X1A,0X1B,0X1C,0X1D,0X1E,0X1F
			DCB	0X20,0X21,0X22,0X23,0X24,0X25,0X26,0X27,0X28,0X29,0X2A,0X2B,0X2C,0X2D,0X2E,0X2F
			DCB	0X60,0X31,0X32,0X33,0X34,0X35,0X36,0X37,0X38,0X39,0X3A,0X3B,0X3C,0X3D,0X3E,0X3F
			DCB 0XA5,0X00,0X09,0X00,0X00,0X79,0X00,0X00,0X37,0X00,0X00,0X40,0X00,0X00,0X00,0X00
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
	LDR R0,=TABLE 		;Get the start address (souce data)
	ADD R0,R0,#0X30
	ADD R1,R0,#0X10
	SUB R2,R1,#0X20
	LDRB R3,[R0],#1     
	LDRB R4,[R1],#2
; Read the valus from Memory
LOOP
	CMP R3,R4
	BLT STEP1
	BEQ STEP2
	BGT STEP3
	B END_P
STEP1
	LDRB R5,[R1],#1
	LDRB R6,[R1,#2]!
	LDRB R7,[R1,#3]
	LDRB R8,[R1],#6
	LDRB R9,[R1,R10,LSL#1]
	B END_P
STEP2
	LDRB R5,[R0]		;Indirect Address Mode
	LDRB R6,[R0,#1]		;Indexet with Offset Address Mode
	LDRB R7,[R0],#1		;Pos-indexed Address Mode
	LDRB R8,[R0,#3]!	;Pre-Indexed Address mode
	LDRB R9,[R0,0X2]
; Write the values to Memory
	STRB R5,[R1]		;store the fisrt value
	STRB R6,[R1,#1]!		;store the second value
	STRB R7,[R1,#1]
	STRB R8,[R1,#3]!
	STRB R9,[R1],#4
STEP3
	LDRB R5,[R1]
	LDRB R6,[R0]
END_P
	NOP
	NOP
	ALIGN 4
	END
	
		