; ****************>>> WORKS <<<<<********************  8/15/2020
;        Roman Lopez Ph. D.
;        This program move values from ROM (0x08) to RAM (0x20000000)
;;;     DEFINITION AREA :::::::::::::::::::::::::::::::::
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
	MOV R9,#0X00
	MOV R1,#0XFF
	
	CMP R9,#0X00
	BEQ	MAIN_LIGHTSWITCH
	
	CMP R9,#0X01
	BEQ MAIN_ARITHMETIC

;	CMP R9,#0X02
;	BEQ MAIN_LOGIC
	
;	CMP R9,#0X03
;	BEQ MAIN_ADRESS_MODES

	B END_P
MAIN_LIGHTSWITCH
	;????????????????????????????????????PUSH{R0,R1}
	MOV R0,#0XFF	; SET AUTOMATICALLY 0X00 TO R0
	CMP R1,#0XFF
	BEQ	LIGHTSWITCH_LOOP1
	BLT LIGHTSWITCH_LOOP2
	;POP{R0,R1}
	;BX LR
LIGHTSWITCH_LOOP1
	;PUSH{R0,R1}
	LSR R1,R1,#1
	MOV R0,R1
	BL MAIN_LIGHTSWITCH
	;POP{R0,R1}
	;BX LR
LIGHTSWITCH_LOOP2
	PUSH{R0,R1}
	LSR R1,R1,#1
	ORR R1,R1,#0X80
	MOV R0,R1
	CMP R1,#0XFE
	BNE MAIN_LIGHTSWITCH
	POP{R0,R1}
	BX LR
MAIN_ARITHMETIC
	MOV R0,#0X05	; SET 0X05 TO R0
	ADD R0,R0,R1	; R0 = R0 + R1
	SUB R0,R0,R1	; R0 = R0 - R1
	MUL	R1,R1,R0	; R1 = R1*R0
	UDIV R1,R1,R0	; R1 = R1/R0
	B END_P
END_P
	NOP
	NOP
	ALIGN 4
	END
	
		