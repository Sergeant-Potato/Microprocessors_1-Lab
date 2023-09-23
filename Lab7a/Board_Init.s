; Ports Init

; debugger out of the processor and make it permanently unable to be
; debugged or re-programmed.
;************************PortB Registers
GPIO_PORTB_DATA_R 	EQU 	0x400053FC
GPIO_PORTB_DIR_R	EQU 	0x40005400
GPIO_PORTB_AFSEL_R 	EQU 	0x40005420
GPIO_PORTB_PUR_R 	EQU 	0x40005510
GPIO_PORTB_DEN_R 	EQU 	0x4000551C
GPIO_PORTB_CR_R 	EQU 	0x40005524
GPIO_PORTB_AMSEL_R 	EQU 	0x40005528
GPIO_PORTB_PCTL_R   EQU 	0x4000552C

GPIO_PORTF_DATA_R   EQU 	0x400253FC
GPIO_PORTF_DIR_R    EQU 	0x40025400
GPIO_PORTF_AFSEL_R  EQU 	0x40025420
GPIO_PORTF_PUR_R    EQU 	0x40025510
GPIO_PORTF_DEN_R    EQU 	0x4002551C
GPIO_PORTF_LOCK_R   EQU 	0x40025520
GPIO_PORTF_CR_R     EQU 	0x40025524
GPIO_PORTF_AMSEL_R  EQU 	0x40025528
GPIO_PORTF_PCTL_R   EQU 	0x4002552C
GPIO_LOCK_KEY       EQU 	0x4C4F434B  ; Unlocks the GPIO_CR register

SYSCTL_RCGCGPIO_R  EQU 0x400FE608
SYSCTL_RCGC2_GPIOF EQU 0x00000020  ; port F Clock Gating Control
SYSCTL_RCGC2_GPIOB EQU 0x00000002  ; port B Clock Gating Control

        AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
		EXPORT	GPIO_PORTF_DATA_R
		EXPORT	GPIO_PORTB_DATA_R
	    EXPORT  PORTB_Init
		EXPORT 	PORTF_Init
 
;------------Board_Init------------
; Initialize GPIO Port F for negative logic switches

; disabled.
; Input: none
; Output: none
; Modifies: R0, R1
PORTF_Init
    ; activate clock for Port F
	PUSH {R0,R1,LR}					;Store register into the stack area
    LDR R1, =SYSCTL_RCGCGPIO_R      ; R1 = &SYSCTL_RCGCGPIO_R
    LDR R0, [R1]                    ; R0 = [R1]
    ORR R0, R0, #SYSCTL_RCGC2_GPIOF ; R0 = R0|SYSCTL_RCGC2_GPIOF
    STR R0, [R1]                    ; [R1] = R0
    NOP
	NOP
	NOP
    NOP                             ; allow time to finish activating
    ; unlock the lock register
    LDR R1, =GPIO_PORTF_LOCK_R      ; R1 = &GPIO_PORTF_LOCK_R
    LDR R0, =GPIO_LOCK_KEY          ; R0 = GPIO_LOCK_KEY (unlock GPIO Port F Commit Register)
    STR R0, [R1]                    ; [R1] = R0 = 0x4C4F434B
    ; set commit register
    LDR R1, =GPIO_PORTF_CR_R        ; R1 = &GPIO_PORTF_CR_R
    MOV R0, #0xFF                   ; R0 = 0x01 (enable commit for PF0)
    STR R0, [R1]                    ; [R1] = R0 = 0x1
    ; set direction register
    LDR R1, =GPIO_PORTF_DIR_R       ; R1 = &GPIO_PORTF_DIR_R
    MOV R0,#0X0E
	STR R0, [R1]                    ; [R1] = R0
    ; regular port function
    LDR R1, =GPIO_PORTF_AFSEL_R     ; R1 = &GPIO_PORTF_AFSEL_R
    LDR R0, [R1]                    ; R0 = [R1]
    MOV R0,#0X00
    STR R0, [R1]                    ; [R1] = R0
    ; put a delay here if you are seeing erroneous NMI
    ; enable pull-up resistors
    LDR R1, =GPIO_PORTF_PUR_R       ; R1 = &GPIO_PORTF_PUR_R
    MOV  R0,#0X11
	STR R0, [R1]                    ; [R1] = R0
    ; enable digital port
    LDR R1, =GPIO_PORTF_DEN_R       ; R1 = &GPIO_PORTF_DEN_R
    MOV  R0,#0XFF
	STR R0, [R1]                    ; [R1] = R0
    ; configure as GPIO
    LDR R1, =GPIO_PORTF_PCTL_R      ; R1 = &GPIO_PORTF_PCTL_R
    LDR R0, [R1]                    ; R0 = [R1]
    BIC R0, R0, #0x000F000F         ; R0 = R0&~0x000F000F (clear port control field for PF0 and PF4)
    ADD R0, R0, #0x00000000         ; R0 = R0+0x00000000 (configure PF0 and PF4 as GPIO)
    STR R0, [R1]                    ; [R1] = R0
    ; disable analog functionality
    LDR R1, =GPIO_PORTF_AMSEL_R     ; R1 = &GPIO_PORTF_AMSEL_R
    MOV R0, #0                      ; R0 = 0 (disable analog functionality on PF)
    STR R0, [R1]                    ; [R1] = R0
	POP {R0,R1,LR}					;Recover register from the stack area
    BX  LR                          ; return
	
	;------------PORTB_Init------------
; Initialize GPIO Port B for eight LEDs
; Input: none
; Output: none
; Modifies: R0, R1
PORTB_Init
	PUSH {R0,R1,LR}					;Store register into the stack area
    ; activate clock for Port F
    LDR R1, =SYSCTL_RCGCGPIO_R      ; R1 = &SYSCTL_RCGCGPIO_R
    LDR R0, [R1]                    ; R0 = [R1]
    ORR R0, R0, #SYSCTL_RCGC2_GPIOB ; R0 = R0|SYSCTL_RCGC2_GPIOF
    STR R0, [R1]                    ; [R1] = R0
    NOP
    NOP 
	NOP	; allow time to finish activating
	NOP
    ; set commit register
    LDR R1, =GPIO_PORTB_CR_R        ; R1 = &GPIO_PORTB_CR_R
    MOV R0, #0xFF                   ; R0 = 0x01 (enable commit for PF0)
    STR R0, [R1]                    ; [R1] = R0 = 0x1
    ; set direction register
    LDR R1, =GPIO_PORTB_DIR_R       ; R1 = &GPIO_PORTB_DIR_R
    MOV R0,#0XFF
	STR R0, [R1]                    ; [R1] = R0
    ; regular port function
    LDR R1, =GPIO_PORTB_AFSEL_R     ; R1 = &GPIO_PORTB_AFSEL_R
    LDR R0, [R1]                    ; R0 = [R1]
    MOV R0,#0X00
    STR R0, [R1]                    ; [R1] = R0
    ; put a delay here if you are seeing erroneous NMI
    ; enable pull-up resistors
    LDR R1, =GPIO_PORTB_PUR_R       ; R1 = &GPIO_PORTB_PUR_R
    MOV  R0,#0X00
	STR R0, [R1]                    ; [R1] = R0
    ; enable digital port
    LDR R1, =GPIO_PORTB_DEN_R       ; R1 = &GPIO_PORTB_DEN_R
    MOV  R0,#0XFF
	STR R0, [R1]                    ; [R1] = R0
    ; configure as GPIO
    LDR R1, =GPIO_PORTB_PCTL_R      ; R1 = &GPIO_PORTB_PCTL_R
    LDR R0, [R1]                    ; R0 = [R1]
    BIC R0, R0, #0x000F000F         ; R0 = R0&~0x000F000F (clear port control field for PF0 and PF4)
    ADD R0, R0, #0x00000000         ; R0 = R0+0x00000000 (configure PF0 and PF4 as GPIO)
    STR R0, [R1]                    ; [R1] = R0
    ; disable analog functionality
    LDR R1, =GPIO_PORTB_AMSEL_R     ; R1 = &GPIO_PORTB_AMSEL_R
    MOV R0, #0                      ; R0 = 0 (disable analog functionality on PF)
    STR R0, [R1]                    ; [R1] = R0
	POP {R0,R1,LR}					;Recover register from the stack area
    BX  LR                          ; return
	ALIGN 
    END
	
                        ; end of file
