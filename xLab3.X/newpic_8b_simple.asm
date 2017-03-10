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
	movlw	1
	movwf	flag
	movlw	1
	movwf	value

click	btfsc       portb,7
	goto        continue 
	goto	change
change
m2	btfss       portb,7
	goto	m2
	incf	flag
	bsf	portb,7

continue:
	btfsc	flag,0
	goto	loop_right
	goto	loop_left

loop_right:
	call	delay
	movf	value,0
	movwf	portb
	bcf	status,0
	bcf	portb,7
	rlf	value,1
	bsf	portb,7
	bcf	status,2
	movf	value,0
	sublw	n
	btfss	status,2
	goto	click
	goto	init_start
loop_left:
	call	delay
	movf	value,0
	movwf	portb
	bcf	status,0
	bcf	portb,7
	rrf	value,1
	bsf	portb,7
	bcf	status,2
	movf	value,0
	sublw	0
	btfss	status,2
	goto	click
	goto	init_end


init_start
	movlw	1
	movwf	value
	goto	loop_right
init_end
	movlw	b'10001000'
	movwf	value
	goto	loop_left








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