LIST p=16F84A
 __CONFIG 03FF18
STATUS equ 03h
PORTA equ 05h
TRISA equ 05h
PORTB equ 06h
TRISB equ 06h
FSR equ 04h
INDF equ 00h

num1 equ 0x20
num2 equ 0x21
num3 equ 0x22
c_pass set 0x20
c_adr set 0x25
offset equ 0x40
n set .3
flag set 0x41
z equ 0x42
elem equ 0x43
tmp equ 0x44
 
val equ 0x30
i equ 0x31
j equ 0x32
firstVal equ 0x33
secondVal equ 0x34
mul_i equ 0x35
result equ 0x36
temp equ 0x37
op1 equ 0x38
op2 equ 0x39
switch equ 0x3A
d1 equ 0x3B
d2 equ 0x3C
d3 equ 0x3D
startAddr set 0x10
 
; ------------

; program start
 org     0 
 clrf z
 clrf offset
 clrf flag
 clrf elem
 movlw .3
 movwf num1
 movlw .4
 movwf num2
 movlw .6
 movwf num3
 movlw 0xA
 movwf z
 
 BCF   STATUS,0x5  ; set Bank0 in Data Memory by clearing RP0 bit in STATUS register
 
 CLRF   PORTA    ; ????????????? ??????? PORTA
 CLRF   PORTB    ; ????????????? ??????? PORTB

 BSF   STATUS, 5 ; ??????? ???? 1
 
 MOVLW   b'11110000' ; ???????? ??? ?????????????
 MOVWF TRISA    
 
 MOVLW   b'00000111' 
 MOVWF   TRISB   
 
 BCF   STATUS,0x5  ; set Bank0 in Data Memory by clearing RP0 bit in STATUS register
 
 CLRF  val
 CLRF  op1
 CLRF  op2
 CLRF  switch
 
; ?????????????? ??????
;====================
 CLRF  i
MEM_INIT_LOOP:
 INCF  i,F
 MOVLW  0xB
 SUBWF  i,W
 BTFSC  STATUS,0x0
 GOTO  WRITE_OTHER
 
 DECF  i,W
 ADDLW  startAddr
 MOVWF  FSR
 MOVF  i,W
 MOVWF  INDF
 
 GOTO   MEM_INIT_LOOP
WRITE_OTHER:
 DECF  i,W
 ADDLW  startAddr
 MOVWF  FSR
 MOVLW  0x0
 MOVWF  INDF
 
 INCF  i,F
 DECF  i,W
 ADDLW  startAddr
 MOVWF  FSR
 MOVLW  0xC
 MOVWF  INDF
;====================
 
 
INIT_LOOP:
 MOVLW  0x05  ; ??? n ?????????? ????? ??????? n+1 ???????? ? ???????
 MOVWF  i
 MOVLW  b'10000000'
 MOVWF  val
 
MAIN_LOOP:
 DECFSZ  i
 GOTO  $+2
 GOTO  MAIN_LOOPEND
 
 MOVF  val,W
 MOVWF  PORTB
 
 BTFSS  PORTB,0x0
 GOTO  $+3
 MOVLW  0x0
 GOTO  FORM_ADDR
 
 BTFSS  PORTB,0x1
 GOTO  $+3
 MOVLW  0x1
 GOTO  FORM_ADDR
 
 BTFSS  PORTB,0x2
 GOTO  $+3
 MOVLW  0x2
 GOTO  FORM_ADDR
 
 RRF  val,F
 GOTO  MAIN_LOOP    ; ???? ?? ???? ?????? ?? ??????

FORM_ADDR:
 MOVWF  j 
 
 DECF  i,W
 MOVWF  firstVal
 MOVLW  0x3
 MOVWF  secondVal
 CALL  MULFUNC
 MOVWF  result
 
 MOVLW  startAddr
 ADDWF  j,W
 ADDWF  result,W
 MOVWF  FSR
 MOVF  INDF,W
 
 MOVWF  temp
 SUBLW  0xC
 BTFSS  STATUS, 0x2  ; if result of substraction == 0
 GOTO  $+0x10
 MOVF  op1,W
 MOVWF  firstVal
 MOVF  op2,W
 MOVWF  secondVal
 CALL   MULFUNC
 MOVWF  temp
 SUBLW  0xF
 BTFSC  STATUS,0x0
 GOTO  $+0x4
 BSF  PORTB,0x3
 MOVLW  0xE
 GOTO   $+0x3
 BCF  PORTB,0x3
 MOVF  temp,W
 
 GOTO  $+0xB
 
 MOVF  temp,W
 BTFSS  switch, 0x0
 GOTO  $+3
 MOVWF  op1
 GOTO  $+2
 MOVWF  op2
 MOVF  switch,W
 XORLW  0x01
 MOVWF  switch
 MOVF  temp,W


P: MOVWF  PORTA
 CALL  DELAY
 movf FSR,0
 movwf tmp
 
 movf temp,W
 movwf elem
 btfsc flag,0
 goto write
 
 movf temp,W
 xorwf z,0
 btfss STATUS,2
 goto Z
 movlw .1
 movwf flag
Z: 
 MOVF temp,W
 movf tmp,0
 movwf FSR
MAIN_LOOPEND:
 GOTO  INIT_LOOP
 GOTO  END_PROG
; ------------

MULFUNC:
 INCF  firstVal,F
 DECFSZ  firstVal
 GOTO  $+2 
 RETLW  0x0
 
 INCF  secondVal,F
 DECFSZ  secondVal
 GOTO  $+2 
 RETLW  0x0
        ; ???????? ???????
 MOVF  secondVal,W
 MOVWF  mul_i
 MOVF  firstVal,W
MUL_LOOP: 
 DECFSZ  mul_i
 GOTO  $+2
 GOTO  MUL_LOOPEND
 
 ADDWF  firstVal,W
 GOTO  MUL_LOOP
MUL_LOOPEND:
 RETURN

; delay procedure
DELAY
 movlw 0x3F
 movwf d1
 movlw 0x9D
 movwf d2
Delay_0
 decfsz d1, f
 goto $+2
 decfsz d2, f
 goto Delay_0

   ;2 cycles
 goto $+1
 RETURN
; ------------

true
 movlw 0xA
 movwf PORTA
 clrf flag
 clrf offset
 goto INIT_LOOP

false
 movlw 0xD
 movwf PORTA
 clrf flag
 clrf offset
 goto INIT_LOOP

write 
 movf elem,0
 movf  offset,0
 addlw  c_adr
 movwf  FSR
 movf  elem,0
 movwf  INDF

 INCF  offset,0x1
 MOVLW  n     
 SUBWF  offset,0   
 BTFSS  STATUS,0  
 GOTO  INIT_LOOP   
 goto check

check
 clrf offset
next
 movf  offset,0 
 addlw c_pass  
 movwf  FSR  
 movf INDF,0  
 movwf  elem

 movf  offset,0 
 addlw c_adr  
 movwf  FSR  
 movf INDF,0  
 
 xorwf elem
 btfss STATUS,2
 goto false
 
 INCF  offset,0x1
 MOVLW  n     
 SUBWF  offset,0   
 BTFSS  STATUS,0  
 GOTO  next   
 goto true

END_PROG:

 end