;------------SysTick_Wait------------
; Time delay using busy wait.
; Input: R0  delay parameter in units of the core clock 
;        80 MHz(12.5 nsec each tick)
; Output: none
; Modifies: R1
	AREA    |.text|, CODE, READONLY, ALIGN=2
NVIC_ST_CTRL_R          EQU 0xE000E010
NVIC_ST_RELOAD_R        EQU 0xE000E014
NVIC_ST_CURRENT_R       EQU 0xE000E018
NVIC_ST_CTRL_COUNT      EQU 0x00010000  ; Count flag
NVIC_ST_CTRL_CLK_SRC    EQU 0x00000004  ; Clock Source
NVIC_ST_CTRL_INTEN      EQU 0x00000002  ; Interrupt enable
NVIC_ST_CTRL_ENABLE     EQU 0x00000001  ; Counter mode
NVIC_ST_RELOAD_M        EQU 0x00FFFFFF  ; Counter load value

	EXPORT SysTick_Wait
SysTick_Wait
	PUSH {R0,R1,LR}
	;;;;;;;;;;;;;;;;;;;;;;;
	LDR  R0,=0X00FFFFF					;Time to be Delayed
;	LDR  R0,=0X07FFFFF					;Time to be Delayed
    SUB  R0, R0, #1   ; delay-1
    LDR  R1, =NVIC_ST_RELOAD_R  
    STR  R0, [R1]     ; time to wait
    LDR  R1, =NVIC_ST_CURRENT_R  
    STR  R0, [R1]     ; any value written to CURRENT clears
    LDR  R1, =NVIC_ST_CTRL_R  
SysTick_Wait_loop
    LDR  R0, [R1]     ; read status
    ANDS R0, R0, #0x00010000 ; bit 16 is COUNT flag
    BEQ  SysTick_Wait_loop   ; repeat until flag set
	POP  {R0,R1,LR}
    BX   LR 
	ALIGN   
	END
