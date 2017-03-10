	LIST	p=16F84A
	__CONFIG	03FF18
status	equ	03h
portb	equ	06h
trisb	equ	06h
value	equ	0x2F
n	set	b'00010000'
 L1        EQU 0X14
 L2         EQU 0X15

	org 0
	clrf	portb
	bsf	status,5
	clrf	trisb
	bcf	status,5
init:
	movlw	0x1
	movwf	value
loop1:
	call	delay
	movf	value,0
	movwf	portb
	bcf	status,0
	rlf	value,1
	bcf	status,2
	movf	value,0
	sublw	n
	btfss	status,2
	goto	loop1
loop2:
	call	delay
	movf	value,0
	movwf	portb
	bcf	status,0
	rrf	value,1
	bcf	status,2
	movf	value,0
	sublw	0
	btfss	status,2
	goto	loop2
	goto	init

delay:
	                         ; Time Delay Routines
     MOVLW 50                        ; Copy 50 to W
     MOVWF L2                    ; Copy W into L2
 LOOP2
     MOVLW 255                   ; Copy 255 into W
     MOVWF L1                    ; Copy W into L1
 LOOP1
     decfsz L1,F                    ; Decrement L1. If 0 Skip next instruction
         GOTO LOOP1                ; ELSE Keep counting down
     decfsz L2,F                    ; Decrement L2. If 0 Skip next instruction
         GOTO LOOP2                ; ELSE Keep counting down
     Return
	end