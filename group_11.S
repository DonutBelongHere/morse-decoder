

;;; group_11.S Version 4 04/12/16 Rosabelle Armstead, Matthew Newberry, Arun Subramaniam, Felix Wolfers
;;; Morse Decoder
;;;	References:
;;;	[ATmega]: General 8-bit Atmel Microcontroller document 
;;;  downloadable from
;;;  www.atmel.com/dyn/resources/prod_documents/8271S.pdf
;;;  [ATmega328p]: Specific ATmega328p document
;;;  downloadable from
;;;  www.atmel.com/Images/doc7810.pdf
;;;  [AVR]: Instruction Set Manual
;;;  downloadable from
;;;  www.atmel.com/Images/doc0856.pdf
;;;

;;; set up decision limits using clock frequency
	CPU_FREQ = 16000000
	TICKS_PER_SEC = CPU_FREQ / (256 * 1024)
	DOTDASH_BOUNDARY = TICKS_PER_SEC / 5 ; 200ms
	INTER_BOUNDARY = 2 * TICKS_PER_SEC / 5 ; 400ms
	
;;; include definitions of all ports
#define __SFR_OFFSET 0
#include <avr/io.h>

;; import character definitions for display
#include "display.S"

;;; button bit of PORTB, ICP1 for timer1
	BUTTON = 0	
	
;;; set up ports, timer and interrupts:
	.section .text
	.global main 
main:
	;; make pins output:
	ldi r24, CLEAR			; initialises clear display
	out DDRD, r24
	out PORTD, r24
	
	;; switch on button pull up
	sbi PORTB, BUTTON

	ldi r22, 0x01			; set initial value of r22 - bit used to make each character unique
	ldi r23, 0x00			; set counter to 0 to count number of button presses for invalid input error checking

	;; set up timer
	clr r16
	sts TCCR1A, r16 		;set timer output mode

	;; enable input capture interrupt and timer overflow interrupt
	ldi r16, _BV(ICIE1) | _BV(OCIE1A)
	sts TIMSK1, r16
	ldi r16, INTER_BOUNDARY		; set timer overflow interrupt to 400ms
	sts OCR1AH, r16
	clr r16
	sts OCR1AL, r16
	

	;; enable noise canceller, set prescaler to 1024, start timer in CTC mode
	ldi r16, _BV(ICNC1) | _BV(CS12) | _BV(CS10) | _BV(WGM12)
	sts TCCR1B, r16

	clr r19 			; reset overflow flag

	sei				; enable global interrupt

infiniteloop:	rjmp infiniteloop 	; wait for interrupts

	.global timer1_compa_isr

timer1_compa_isr:
	;; when 400ms have passed since last button press, timer1_compa_isr runs

	push r16
	in r16, SREG 			; save status register
	push r16

	;; waiting for button press or release?
	lds r16, TCCR1B
	sbrs r16, ICES1 		; skip if waiting for button release
	rjmp waiting_for_press

waiting_for_release:
	;; long press always long press, even if timer overruns

	ser r19				; r19 indicates timer overflow
	rjmp 1f
	
waiting_for_press:
	;; inter boundary time passed since last release so call which_char to determine
	;; which character has been input in morse and display this character
	
	call which_char
	call display_char

	ldi r22, 0x01			; reset r22 after character has been determined
	ldi r23, 0x00			; reset counter after character has been determined

1:	pop r16
	out SREG, r16			; restore status register
	pop r16

	reti


	.global timer1_cpt_isr

timer1_cpt_isr:
	;; when button capture event is detected, timer1_cpt_isr runs

	push r8
	in r8, SREG 			; save the status register
	push r8

	lds r8, ICR1L			; get timer count when capture event happened
	lds r8, ICR1H
	push r17

	;; debounce button:
	mov r17, r19	
	or r17, r8

	breq debounce			; if no timer-overflow, do nothing

	clr r17
	sts TCNT1H, r17 		; reset timer
	sts TCNT1L, r17

	;; check if looking for positive or negative edge
	lds r17, TCCR1B
	sbrs r17, ICES1			; skip if positive edge
	rjmp pressed 			; negative edge so button has been pressed
	rcall released			; positive edge so button has been released

	andi r17, ~(_BV(ICES1))		; positive edge so next time looking for negative edge

	rjmp end_isr	

pressed:
	lsl r22				; shift bits to left so 0 can be added for dot or 1 can be added for dash
	inc r23				; increment counter to keep track of number of button presses
	sbi PORTB, 5
	ldi r24, CLEAR			; clear display when button is pressed
	call display_char
	ori r17, _BV(ICES1) 		; next time looking for a positive edge

end_isr:
	sts TCCR1B, r17			; activate change in edge detection

debounce:
	pop r17
	pop r8
	out SREG, r8			; restore status register
	pop r8

	reti

released:
	push r16
	cbi PORTB, 5

	tst r19				; if timer overflow since last release of button
	brne long_press			; signal is long press

	ldi r16, DOTDASH_BOUNDARY	; compare signal length to 200ms i.e. dot length
	cp r8, r16
	brcs short_press		; if signal shorter than dot length, short press so no increment to r22 as represented by 0

long_press:

	inc r22				; long press represented as 1 in bit pattern so increment r22
	rjmp 1f

short_press:
1:

	pop r16
	clr r19				; clears overflow in case it was set
	ret

display_char:
	;; code to display character
	out PORTD, r24			; transfer bit mask into PORTD
	ret
