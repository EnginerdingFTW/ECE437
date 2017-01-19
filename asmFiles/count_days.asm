org 0x0000
ori $29, $0, 0xFFFC #stack pointer

#initialize operands
ori $4, $0, 0x0006  #current day
ori $5, $0, 0x0001  #current month
ori $6, $0, 0x07E1  #current year

ori $7, $0, 0x001E    #30
ori $3, $0, 0x0001    #1
subu $5, $5, $3
push $5
push $7
jal MULT
pop $5

ori $7, $0, 0x016D  #365
ori $3, $0, 0x07D0  #2000
subu $6, $6, $3
push $7
push $6
jal MULT
pop $6

addu $4, $4, $5
addu $4, $4, $6
halt

MULT:       #2 stack -> mult -> prod on stack
pop $9
pop $10

ori $8, $0, 0x0000  #initialize counter
ori $11, $0, 0x0000 #initialize product

  MULT_LOOP:
  beq $8, $10, MULT_DONE
  addu $11, $11, $9
  addiu $8, $8, 0x0001
  j MULT_LOOP

MULT_DONE:
push $11
jr $31
