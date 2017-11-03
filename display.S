

;;; display.S Version 2 04/12/16 Rosabelle Armstead, Matthew Newberry, Arun Subramaniam, Felix Wolfers
;;; Character and pin defintions for seven segment display
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

;;;include definitions of all ports
#include <avr/io.h> 				

	;; corresponding PORTD pin to segment on display
	SEG_A = 7
	SEG_B = 1
	SEG_C = 2
	SEG_D = 3
	SEG_E = 4
	SEG_F = 5
	SEG_G = 6

	;; all segments off
	CLEAR = _BV(SEG_A) | _BV(SEG_B) | _BV(SEG_C) | _BV(SEG_D) | _BV(SEG_E) | _BV(SEG_F) | _BV(SEG_G)
	
	;; all segments on
	ALL = ~(_BV(SEG_A) | _BV(SEG_B) | _BV(SEG_C) | _BV(SEG_D) | _BV(SEG_E) | _BV(SEG_F) | _BV(SEG_G))
	
	;; bit mask for each digit and letter
	CHAR_0 = ~(_BV(SEG_A) | _BV(SEG_B) | _BV(SEG_C) | _BV(SEG_D) | _BV(SEG_E) | _BV(SEG_F))
	CHAR_1 = ~(_BV(SEG_B) | _BV(SEG_C))
	CHAR_2 = ~(_BV(SEG_A) | _BV(SEG_B) | _BV(SEG_G) | _BV(SEG_E) | _BV(SEG_D))
	CHAR_3 = ~(_BV(SEG_A) | _BV(SEG_B) | _BV(SEG_C) | _BV(SEG_D) | _BV(SEG_G))
	CHAR_4 = ~(_BV(SEG_B) | _BV(SEG_C) | _BV(SEG_F) | _BV(SEG_G))
	CHAR_5 = ~(_BV(SEG_A) | _BV(SEG_C) | _BV(SEG_D) | _BV(SEG_F) | _BV(SEG_G))
	CHAR_6 = ~(_BV(SEG_A) | _BV(SEG_C) | _BV(SEG_D) | _BV(SEG_E) | _BV(SEG_F) | _BV(SEG_G))
	CHAR_7 = ~(_BV(SEG_A) | _BV(SEG_B) | _BV(SEG_C))
	CHAR_8 = ~(_BV(SEG_A) | _BV(SEG_B) | _BV(SEG_C) | _BV(SEG_D) | _BV(SEG_E) | _BV(SEG_F) | _BV(SEG_G))
	CHAR_9 = ~(_BV(SEG_A) | _BV(SEG_B) | _BV(SEG_C) | _BV(SEG_D) | _BV(SEG_F) | _BV(SEG_G))
	CHAR_A = ~(_BV(SEG_A) | _BV(SEG_B) | _BV(SEG_C) | _BV(SEG_E) | _BV(SEG_F) | _BV(SEG_G))
	CHAR_B = ~(_BV(SEG_C) | _BV(SEG_D) | _BV(SEG_E) | _BV(SEG_F) | _BV(SEG_G))
	CHAR_C = ~(_BV(SEG_A) | _BV(SEG_E) | _BV(SEG_F) | _BV(SEG_D))
	CHAR_D = ~(_BV(SEG_B) | _BV(SEG_C) | _BV(SEG_D) | _BV(SEG_E) | _BV(SEG_G))
	CHAR_E = ~(_BV(SEG_A) | _BV(SEG_D) | _BV(SEG_E) | _BV(SEG_F) | _BV(SEG_G))
	CHAR_F = ~(_BV(SEG_A) | _BV(SEG_E) | _BV(SEG_F) | _BV(SEG_G))
	CHAR_G = ~(_BV(SEG_A) | _BV(SEG_C) | _BV(SEG_D) | _BV(SEG_E) | _BV(SEG_F))
	CHAR_H = ~(_BV(SEG_C) | _BV(SEG_E) | _BV(SEG_F) | _BV(SEG_G))
	CHAR_I = ~(_BV(SEG_E) | _BV(SEG_F))
	CHAR_J = ~(_BV(SEG_B) | _BV(SEG_C) | _BV(SEG_D) | _BV(SEG_E))
	CHAR_K = ~(_BV(SEG_A) | _BV(SEG_C) | _BV(SEG_E) | _BV(SEG_F) | _BV(SEG_G))
	CHAR_L = ~(_BV(SEG_D) | _BV(SEG_E) | _BV(SEG_F))
	CHAR_M = ~(_BV(SEG_A) | _BV(SEG_C) | _BV(SEG_E))
	CHAR_N = ~(_BV(SEG_A) | _BV(SEG_B) | _BV(SEG_C) | _BV(SEG_E) | _BV(SEG_F))
	CHAR_O = ~(_BV(SEG_C) | _BV(SEG_D) | _BV(SEG_E) | _BV(SEG_G))
	CHAR_P = ~(_BV(SEG_A) | _BV(SEG_B) | _BV(SEG_E) | _BV(SEG_F) | _BV(SEG_G))
	CHAR_Q = ~(_BV(SEG_A) | _BV(SEG_B) | _BV(SEG_C) | _BV(SEG_F) | _BV(SEG_G))
	CHAR_R = ~(_BV(SEG_A) | _BV(SEG_B) | _BV(SEG_E) | _BV(SEG_F))
	CHAR_S = ~(_BV(SEG_A) | _BV(SEG_C) | _BV(SEG_D) | _BV(SEG_F) | _BV(SEG_G))
	CHAR_T = ~(_BV(SEG_D) | _BV(SEG_E) | _BV(SEG_F) | _BV(SEG_G))
	CHAR_U = ~(_BV(SEG_B) | _BV(SEG_C) | _BV(SEG_D) | _BV(SEG_E) | _BV(SEG_F))
	CHAR_V = ~(_BV(SEG_B) | _BV(SEG_C) | _BV(SEG_D) | _BV(SEG_F))
	CHAR_W = ~(_BV(SEG_B) | _BV(SEG_D) | _BV(SEG_F))
	CHAR_X = ~(_BV(SEG_B) | _BV(SEG_C) | _BV(SEG_E) | _BV(SEG_F) | _BV(SEG_G))
	CHAR_Y = ~(_BV(SEG_B) | _BV(SEG_C) | _BV(SEG_D) | _BV(SEG_F) | _BV(SEG_G))
	CHAR_Z = ~(_BV(SEG_A) | _BV(SEG_B) | _BV(SEG_D) | _BV(SEG_G))
	
	;; bit mask for error character when morse code does not exist or is too long
	CHAR_ERR = ~(_BV(SEG_A) | _BV(SEG_D) | _BV(SEG_G))
