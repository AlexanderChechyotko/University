	LIST	p=16F84A
	__CONFIG	03FF18
status	equ	03h
portb	equ	06h
trisb	equ	06h
value	set	b'00000001'
	org 0
	bsf	status,5
	bcf	trisb,0
	bcf	trisb,1
	bcf	trisb,2
	bcf	trisb,3
	bcf	status,5

	movf	value,0
	movwf	portb

	end


