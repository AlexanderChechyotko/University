	LIST	p=16F84A
	__CONFIG	03FF18
status	equ	03h
porta	equ	05h
trisa	equ	05h
portb	equ	06h
trisb	equ	06h
fsr	equ	04h
indf	equ	00h
OPTION_REG	equ	81
num1	equ	0x20
num2	equ	0x21
num3	equ	0x22
c_pass	set	0x20
c_adr	set	0x30
offset	equ	0x09
n	set	.3
flag	set	0xA
elem	equ	0x19

	org 0

	bsf	status,5
	movlw	0x10
	movwf	trisa
	movlw	0xf8
	movwf	trisb
			
	bcf	OPTION_REG,7
	bcf	status,5

	clrf	porta
	clrf	portb
	clrf	offset
	clrf	flag
	clrf	elem
	movlw	.3
	movwf	num1
	movlw	.4
	movwf	num2
	movlw	.3
	movwf	num3

Column1	bcf	portb,0
	bsf	portb,1
	bsf	portb,2	
Check1	btfsc	portb,3
	goto	Check4

	movlw 	.3
	movwf	elem
	movwf	porta
	btfsc	flag,0
	goto	write
			
Check4	btfsc	portb,4
	goto	Check7

	movlw	.6
	movwf	elem
	movwf	porta
	btfsc	flag,0
	goto	write
			
Check7	btfsc	portb,5
	goto	Check11

	movlw	.9
	movwf	elem
	movwf	porta
	btfsc	flag,0
	goto	write
		
Check11	btfsc	portb,6
	goto	Column2

	movlw	.11
	movwf	elem
	movwf	porta
	btfsc	flag,0
	goto	write
				
Column2	bsf	portb,0
	bcf	portb,1
	bsf	portb,2
			
Check2	btfsc	portb,3
	goto	Check5

	movlw 	.2
	movwf	elem
	movwf	porta
	btfsc	flag,0
	goto	write
			
Check5	btfsc	portb,4
	goto	Check8

	movlw	.5
	movwf	elem
	movwf	porta
	btfsc	flag,0
	goto	write
			
Check8	btfsc	portb,5
	goto	Check12

	movlw	.8
	movwf	elem
	movwf	porta
	btfsc	flag,0
	goto	write
		
Check12	btfsc	portb,6
	goto	Column3

	movlw	.0
	movwf	porta
	movlw	.0
	movwf	flag

Column3	bsf	portb,0
	bsf	portb,1
	bcf	portb,2
			
Check3	btfsc	portb,3
	goto	Check6

	movlw 	.1
	movwf	elem
	movwf	porta
	btfsc	flag,0
	goto	write
			
Check6	btfsc	portb,4
	goto	Check9

	movlw	.4
	movwf	elem
	movwf	porta
	btfsc	flag,0
	goto	write
			
Check9	btfsc	portb,5
	goto	Check13

	movlw	.7
	movwf	elem
	movwf	porta
	btfsc	flag,0
	goto	write
		
Check13	btfsc	portb,6
	goto	Column1

	movlw	0xC
	movwf	porta
	movlw	.1
	movwf	flag
		
	goto	Column1

true
	movlw	0xA
	movwf	porta
	clrf	flag
	clrf	offset
	goto	Column1

false
	movlw	0xD
	movwf	porta
	clrf	flag
	clrf	offset
	goto	Column1

write	
	movf	elem,0
	movf 	offset,0
	addlw 	c_adr
	movwf 	fsr
	movf 	elem,0
	movwf 	indf

	INCF 	offset,0x1
	MOVLW 	n     
	SUBWF 	offset,0   
	BTFSS 	status,0  
	GOTO 	Column1   
	goto	check

check
	clrf	offset
next
	movf 	offset,0	
	addlw	c_pass		
	movwf 	fsr		
	movf	indf,0		
	movwf 	elem

	movf 	offset,0	
	addlw	c_adr		
	movwf 	fsr		
	movf	indf,0		
	
	xorwf	elem
	btfss	status,2
	goto	false
	
	INCF 	offset,0x1
	MOVLW 	n     
	SUBWF 	offset,0   
	BTFSS 	status,0  
	GOTO 	Column1   
	goto	true

	end