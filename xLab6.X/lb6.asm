	LIST	p=16F84A
	__CONFIG	03FF18
status	equ	03h
porta	equ	05h
trisa	equ	05h
portb	equ	06h
trisb	equ	06h
OPTION_REG	equ	81

	org 0
Start	bsf	status,5

	movlw	0x10
	movwf	trisa

	movlw	0xf8
	movwf	trisb
			
	bcf	OPTION_REG,7
	bcf	status,5

	clrf	porta
	clrf	portb

Column1	bcf	portb,0
	bsf	portb,1
	bsf	portb,2
			
Check1	btfsc	portb,3
	goto	Check4

	movlw 	.3
	movwf	porta
			
Check4	btfsc	portb,4
	goto	Check7

	movlw	.6
	movwf	porta
			
Check7	btfsc	portb,5
	goto	Check11

	movlw	.9
	movwf	porta
		
Check11	btfsc	portb,6
	goto	Column2

	movlw	.11
	movwf	porta
				
Column2	bsf	portb,0
	bcf	portb,1
	bsf	portb,2
			
Check2	btfsc	portb,3
	goto	Check5

	movlw 	.2
	movwf	porta
			
Check5	btfsc	portb,4
	goto	Check8

	movlw	.5
	movwf	porta
			
Check8	btfsc	portb,5
	goto	Check12

	movlw	.8
	movwf	porta
		
Check12	btfsc	portb,6
	goto	Column3

	movlw	.0
	movwf	porta

Column3	bsf	portb,0
	bsf	portb,1
	bcf	portb,2
			
Check3	btfsc	portb,3
	goto	Check6

	movlw 	.1
	movwf	porta
			
Check6	btfsc	portb,4
	goto	Check9

	movlw	.4
	movwf	porta
			
Check9	btfsc	portb,5
	goto	Check13

	movlw	.7
	movwf	porta
		
Check13	btfsc	portb,6
	goto	Column1

	movlw	.15
	movwf	porta
		
	goto	Column1

	end