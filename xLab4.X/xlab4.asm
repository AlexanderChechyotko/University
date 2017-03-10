	LIST	p=16F84A
	__CONFIG	03FF18
status	equ	03h
portb	equ	06h
trisb	equ	06h
max	set	9
d_number	equ	0Ah
counter	equ	09h
tmp	equ	19h
	org 0
	clrf	tmp
	clrf	portb
	bsf	status,5
	bcf	trisb,5
	bcf	trisb,0
	bcf	trisb,1
	bcf	trisb,2
	bcf	trisb,3
	bcf	trisb,4
	bcf	status,5
	bsf	portb,0
begin
m1	btfsc       portb,0  
	goto        m1 
m2	btfss       portb,0
	goto	m2
	incf	counter
	bcf	status,0
	rlf	counter,0
	movwf	d_number
	btfsc	counter,0
	goto	switchon
	goto	switchoff

switchon	
	bsf	tmp,5
	bsf	tmp,0
	goto	display
switchoff	
	bcf	tmp,5
	bsf	tmp,0
	goto	display
display
	bcf	status,0
	movf	counter,0
	sublw	max
	btfss	status,0
	goto	clear
	movf	tmp,0
	addwf	d_number,0
	movwf	portb
	goto	begin
clear
	clrf	counter
	movlw	b'00100001'
	movwf	portb
	goto	begin
	end
