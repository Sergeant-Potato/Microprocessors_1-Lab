;------------SysTick_Wait10ms------------
; Call this routine to wait for R0*10 ms 
; Time delay using busy wait. This assumes 80 MHz clock
; Input: R0  number of times to wait 10 ms before returning
; Output: none
; Modifies: R0
	AREA    |.text|, CODE, READONLY, ALIGN=2
	EXPORT SysTick_Wait10ms
	IMPORT SysTick_Wait
DELAY10MS  EQU 800000    ; clock cycles in 10 ms 
SysTick_Wait10ms
    PUSH {R4, LR}               ; save R4 and LR
    MOVS R4, R0                 ; R4 = R0 = remainingWaits
    BEQ SysTick_Wait10ms_done   ; R4 == 0, done
SysTick_Wait10ms_loop
    LDR R0, =DELAY10MS          ; R0 = DELAY10MS
    BL  SysTick_Wait            ; wait 10 ms
    SUBS R4, R4, #1             ; remainingWaits--
    BHI SysTick_Wait10ms_loop   ; if(R4>0), wait another 10 ms
SysTick_Wait10ms_done
    POP {R4, PC} 
	ALIGN
	END