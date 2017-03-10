	LIST	p=16F84A
	__CONFIG	03FF18
status	equ	03h
portb	equ	06h
trisb	equ	06h
value	equ	0x2F
n	set	b'00010000'
flag	equ	0x09
L1	EQU	0X14
L2	EQU	0X15

	org 0
	clrf	portb
	bsf	status,5
	clrf	trisb
	bcf	status,5
	bsf	portb,7

click	btfsc       portb,7
	goto        continue 
	goto	change
change
	btfsc	flag,0
	incf	flag
	decf	flag

	bsf	portb,7

continue:
	btfss	flag,0
	goto	loop_right
	goto	loop_left
init:
	movlw	1
	movwf	value
	movlw	1
	movwf	flag
loop_right:
	call	delay
	movf	value,0
	movwf	portb
	bcf	status,0
	rlf	value,1
	bcf	status,2
	movf	value,0
	sublw	n
	btfss	status,2
	goto	loop_right
	goto	init
loop_left:
	call	delay
	movf	value,0
	movwf	portb
	bcf	status,0
	rrf	value,1
	bcf	status,2
	movf	value,0
	sublw	0
	btfss	status,2
	goto	loop_left
	goto	init












delay:
	                         
     MOVLW 50                       
     MOVWF L2                    
 LOOP2
     MOVLW 255                  
     MOVWF L1                    
 LOOP1
     decfsz L1,F                    
         GOTO LOOP1                
     decfsz L2,F                    
         GOTO LOOP2                
     Return
	end