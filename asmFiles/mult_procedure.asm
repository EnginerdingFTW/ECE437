org 0x0000

ori $29, $0, 0xFFFC  #initialize stack pointer
ori $9, $0, 0xFFF8    #stack is at 1

#create some operands and push to stack
ori $15, $0, 0x0001
push $15
ori $15, $0, 0x0002
push $15
ori $15, $0, 0x0003
push $15
ori $15, $0, 0x0004
push $15

MULT_PROCEDURE:
  beq $29, $9, END_MULT_PROC   #if stack is at 1, we finished mult.
  ori $11, $0, 0x0000          #set counter to 0
  pop $12
  pop $13
  ori $14, $0, 0x0000          #set temp product to 0

  MULT_LOOP:
  beq $13, $11, END_MULT
  addu $14, $14, $12
  addiu $11, $11, 0x0001
  j MULT_LOOP

  END_MULT:
  push $14    #push product back onto stack
  j MULT_PROCEDURE

END_MULT_PROC:
pop $2
halt

