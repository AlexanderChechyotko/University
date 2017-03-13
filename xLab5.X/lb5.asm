	LIST	p=16F84A
	__CONFIG	03FF18
cblock	0x20
	count			; counter, used in reading bits from shift register loop
	shifting_value		; the temporary variable, used to insert values into PORTB
	; Crazy counts used in Delay procedure
	count1
	counta
	countb
endc

trisa_all	set 0x04	; (0000 0100)
trisb_all	set 0x00
init_shift_val	set 0x40	; (0100 0000)

RST   code	0x00 
      goto	Start

PGM   code
Start		
      bsf	STATUS, RP0
      movlw	trisa_all
      movwf	TRISA
      movlw	trisb_all
      movwf	TRISB
      bcf	STATUS, RP0
START_READ:
      clrf	count
      clrf	PORTA
      clrf	PORTB
		 	 
      movlw	init_shift_val
      movwf	shifting_value
      
      bsf	PORTA, 0x00		; initialize reading data from shift register
      
      ; read the first bit from shift register, to define which screen should be used to display data
      btfsc	PORTA, 0x02
      goto	RIGHT_SCREEN
LEFT_SCREEN:
      bsf	PORTA, 0x03		; L bit = 0
      goto	SHIFTING
RIGHT_SCREEN:
      bsf	PORTA, 0x04		; L bit = 1
SHIFTING:
      incf	count, F
      bsf	PORTA, 0x01		; start receiving bit from shift register
      
      ; modify the PORTB value according to the received bit
      movf	PORTB, W
      btfss	PORTA, 0x02
      addwf	shifting_value, W	; received 1
      movwf	PORTB			; received 0
      
      ; shifting_value is modified to be used with the next bit
      bcf	STATUS, C		; C bit is nulled, so it is not pushed into the shifting_value during the shift
      rrf	shifting_value, F
	         
      bcf	PORTA, 0x01		; bit is received
      movf	count, W
      xorlw	0x07			; checking the loop overflow, we are reading only 7 bits
      btfss	STATUS, Z
      goto	SHIFTING
      
      call	DELAY			; delay, to stop screen from flashing
      goto	START_READ
      
;-----------------------------
;	Crazy Delay
; - expects nothing
; - returns nothing
;-----------------------------
DELAY: 
	movlw	0x7D		; (1 MHz clock)
	movwf	count1
DELAY_OUTER:    
	movlw	0x63
	movwf	counta
	movlw	0x01
	movwf	countb
DELAY_INNER:
	decfsz	counta, F
	goto	DELAY_INNER
	decfsz	countb, F
	goto	DELAY_INNER
       
	decfsz	count1, F
	goto	DELAY_OUTER
	retlw	0x00     

;====================================================================
FINISH:

	end

