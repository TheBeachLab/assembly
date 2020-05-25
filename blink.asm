; Hello world blink
; by Fran Sanchez 2020
; DWTFYW license
; this code blinks the internal led
; every half a second
; at 16MHz is 8M clock cycles

.INCLUDE "m328pdef.inc"	; directive to include 
.CSEG			; code segment (there are eeprom .ESEG and sram .DSEG)
.ORG 0x0000		; the next instruction has to be written to address 0x0000

rjmp START	; the reset vector: jump to "main"
		; Vector	Interrupt definition		Vector name
		; 2		External Interrupt Request 0 	INT0_vect
		; 3 		External Interrupt Request 1 	INT1_vect
		; 4 		Pin Change Interrupt Request 0 	PCINT0_vect
		; 5 		Pin Change Interrupt Request 1 	PCINT1_vect
		; 6 		Pin Change Interrupt Request 2 	PCINT2_vect
		; 7 		Watchdog Time-out Interrupt 	WDT_vect
		; 8 		Timer/Counter2 Compare Match A 	TIMER2_COMPA_vect
		; 9 		Timer/Counter2 Compare Match B 	TIMER2_COMPB_vect
		; 10		Timer/Counter2 Overflow 	TIMER2_OVF_vect
		; 11		Timer/Counter1 Capture Event 	TIMER1_CAPT_vect
		; 12		Timer/Counter1 Compare Match A 	TIMER1_COMPA_vect
		; 13		Timer/Counter1 Compare Match B 	TIMER1_COMPB_vect
		; 14		Timer/Counter1 Overflow 	TIMER1_OVF_vect
		; 15		Timer/Counter0 Compare Match A 	TIMER0_COMPA_vect
		; 16		Timer/Counter0 Compare Match B 	TIMER0_COMPB_vect
		; 17		Timer/Counter0 Overflow 	TIMER0_OVF_vect
		; 18		SPI Serial Transfer Complete 	SPI_STC_vect
		; 19		USART Rx Complete 	USART_RX_vect
		; 20		USART Data Register Empty 	USART_UDRE_vect
		; 21		USART Tx Complete 	USART_TX_vect
		; 22		ADC Conversion Complete 	ADC_vect
		; 23		EEPROM Ready 	EE_READY_vect
		; 24		Analog Comparator 	ANALOG_COMP_vect
		; 25		Two-wire Serial Interface 	TWI_vect
		; 26		Store Program Memory Read 	SPM_READY_vect



START:

; set up the sram stack SPL:HPL
; SPL stack pointer low, SPH stack pointer high
; SPH needed because
; atmega328 has 2kb sram
; stack not used in this example
ldi r16, low(RAMEND)	; load the start address of the sram in r16
out SPL, r16		; store r16 (start address) in SPL register
ldi r16, high(RAMEND)	; load the end address of the sram in r16
out SPH, r16		; store r16 (end address) in SPH register

; set up DDRB where led is located
ldi r16, 0xFF	; load register 16 with 0xFF (all bits 1)
out DDRB, r16	; write the value in r16 (0xFF) to DDRB   

LOOP:  
sbi PORTB, 5	; switch on the LED  
rcall delay_05	; wait for half a second  
cbi PORTB, 5	; switch it off  
rcall delay_05	; wait for half a second  
rjmp LOOP	; jump to loop

DELAY_05:	; the subroutine:  
ldi r16, 31	; 1cc load r16 with 31

OUTER_LOOP:		; outer loop label  
ldi r24, low(1021)	; load registers r24:r25 with 1021, our new init value  
ldi r25, high(1021)	; 2cc total

DELAY_LOOP:	; the loop label         
adiw r24, 1	; 2cc - increment word r24:r25    
brne DELAY_LOOP	; 2cc - if no overflow ("branch if not equal to 0"), go back to "delay_loop"
; outer loop takes
; 2cc for the 2 ldi
; + the delay loop
; if r24:r25 was loaded with 0, it would overflow at 65535
; 65535*4=262140 cc
; + 3cc overflow
; total 262145 

dec r16		; 1cc decrement r16  
brne OUTER_LOOP	; 2cc and loop if outer loop not finished
; +3 cc
; total 262148*31=8126588
; excess of 126588 cc
; load a bigger number in r24:r25
; 126588/31= 4083.48... cc
; redo the math
; (65535-1021)*4=258056 cc + 3cc overflow + 2cc ldi = 258061 cc
; +3cc = 258064*31=7999984
; +8cc overfow + 1cc ldi r16 + 1cc rcall + 1cc ret = 7999995 cc
  
ret	; 1cc return from rcall subroutine
