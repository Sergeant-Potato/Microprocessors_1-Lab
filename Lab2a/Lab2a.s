; ****************>>> WORKS <<<<<********************  8/15/2020
;        Roman Lopez Ph. D.
;        This porgram how to configure your assembly file
;;;     DEFINITION AREA :::::::::::::::::::::::::::::::::

		;Constant Start at 0x08
		AREA MyConstant,CODE,READONLY
		;>>>>>>> Insert your Constant here <<<<<<<<<<

		;Variables Start at 0x20000000
		AREA MyVariables,DATA,READWRITE
		;>>>>>>> Insert your Variables here <<<<<<<<<
;>>>>>>>>>>>>>>>>>> TEXT AREA (PROGRAMS< CONSTANT, TABLES, Etc ) <<<<<<<<<<<<<<<<<<<<<<<
;        Program area start at 0x08

		AREA MyPROGRAM, CODE, READONLY, ALIGN=2
		ENTRY				;Set the lime where the program start
		EXPORT Start

Start
		;>>>>>>> Insert your program here <<<<<<<<<
		;>>>>>>>By Default the program at 0x1C <<<<<<<<<		

		MOV		R5,#0x1234		;Move some arbitrary number in R5
		MOV		R3,#0x5678
		ADD 	R6,R5,R3		;Add the values in R5 and R3 and store the result in R6
		;NOTE: leave one or two NOT for the compiler in order to recognize the last command
		NOP	
		NOP		
STOP
		B STOP					;Endless loop
		END