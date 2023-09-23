 AREA    |.text|, CODE, READONLY, ALIGN=2
NVIC_ST_CTRL_R          EQU 0xE000E010
NVIC_ST_RELOAD_R        EQU 0xE000E014
NVIC_ST_CURRENT_R       EQU 0xE000E018
NVIC_ST_CTRL_COUNT      EQU 0x00010000  ; Count flag
NVIC_ST_CTRL_CLK_SRC    EQU 0x00000004  ; Clock Source
NVIC_ST_CTRL_INTEN      EQU 0x00000002  ; Interrupt enable
NVIC_ST_CTRL_ENABLE     EQU 0x00000001  ; Counter mode
NVIC_ST_RELOAD_M        EQU 0x00FFFFFF  ; Counter load value
	EXPORT SysTick_Disable
    
SysTick_Disable 
	PUSH {R0,R1,LR}
    LDR R1, =NVIC_ST_CTRL_R
    MOV R0, #0            ; Clear Enable         
    STR R0, [R1] 
; set reload to maximum reload value
    LDR R1, =NVIC_ST_RELOAD_R 
    LDR R0, = 0x00FFFFFF;    ; Specify RELOAD value
    STR R0, [R1]            ; reload at maximum       
; writing any value to CURRENT clears it
    LDR R1, =NVIC_ST_CURRENT_R 
    MOV R0, #0              
    STR R0, [R1]            ; clear counter
; enable SysTick with core clock
    LDR R1, =NVIC_ST_CTRL_R    
    MOV R0, # 0x0005    ; Enable but no interrupts (later)
    STR R0, [R1]       ; ENABLE and CLK_SRC bits set
	POP {R0,R1,LR}
    BX  LR 
	END