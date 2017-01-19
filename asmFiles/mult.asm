org 0x0000  #program starting address

ori $29, $0, 0xFFFC #initialize stack pointer
ori $8, $0, 0x0000  #initialize counter
ori $11, $0, 0x0000 #initialize product

ori $12, $0, 0x0005 #initialize operand 1
ori $13, $0, 0x0004 #initialize operand 2

push $12
push $13

pop $9
pop $10

MULT_LOOP:             #  5 * 4 = 5 + 5 + 5 + 5. simulate mult with add
beq $8, $10, MULT_DONE #compare loop counter to number of times to loop
addu $11, $11, $9      #add another operand - unsigned
addiu $8, $8, 0x0001   #increment counter - unsigned
j MULT_LOOP            #continue looping

MULT_DONE:
halt
