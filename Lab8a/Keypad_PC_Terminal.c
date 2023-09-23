//**** 0. Documentation Section
//  This get a char from a keypad and send it to a terminal
//  Author: Ramesh Yerraballi & Jon Valvano
//  Date: 5/24/2014
//  R. Lopez Ph. D.
//        7/29/2021
//
// 1. Pre-processor Directives Section
#include <stdio.h>  // Diamond braces for sys lib: Standard I/O
#include <stdint.h> // C99 variable types
/*NOTE1: 
;	1) If Keil debuger is used;
;		Go to Debuger, open windows UART #1 
;NOTE2:
;	2) TIVA stand along
;		a) Download your program to TIVA board
;		b) Locate TIVAiva serial port (In Device and Manager>>Ports)
;   c) Run Putty (serial terminal) or Temite
;   d) In putty or Termite, select serial and COM # (from Device and Manager)
;   e) Set baudreate to 115200
; 	Keypad organization
 ;	 			4 X 4
 ;			Roman Lopez
 ;					Jun/9/2018
 ;    Keypad Organization
 ;    0  1  2  3
 ;    4  5  6  7
 ;    8  9  A  B
 ;    A  D  C  F
 ;       Rows             Cols
 ;                (Connet a Pull up Resistor)
 ;    L1 -> Pb0 (J1-3)   R1 -> Pb4  (J1-7)
 ;    L2 -> Pb1 (J1-4)   R2 -> Pb5  (J1-2)
 ;    L3 -> Pb2 (J2-2)   R3 -> Pb6  (J2-7)
 ;    L4 -> Pb3 (J4-3)   L4 -> Pb6  (J2-6)

 */
void Output_Init(void);
extern  unsigned char KeyPad(void);
extern  void PORTB_Init(void);
extern  void PORTF_Init(void);
extern  void PB_pull_Resistor(void);

int main(void){
  char Value;
	Output_Init();              // initialize output device
// Modified this program to fullfit your proyect
	PORTB_Init();
	PORTF_Init();
	PB_pull_Resistor();
	while(1){
		printf(" Press a key \n ");
		// printf("Press a Key  \n");
		Value= KeyPad();
		printf(" The Key is ");
		printf(" %x \n",Value);	
		};
	}
