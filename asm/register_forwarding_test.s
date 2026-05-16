.section .text.main
.globl main

main:
    addi t2, x0, 2       # x7  = 2
    addi s3, x0, 3       # x19 = 3
    addi s4, x0, 4       # x20 = 4
    addi s5, x0, 5       # x21 = 5
    addi t6, x0, 6       # x31 = 6

    add  s8, s4, s5      # x24 = x20 + x21 = 9
    sub  s2, s8, s3      # x18 = x24 - x19 = 6
    or   s9, t6, s8      # x25 = x31 OR x24 = 15
    and  s7, s8, t2      # x23 = x24 AND x7 = 0

done:
    beq x0, x0, done     # infinite loop
    
    
    