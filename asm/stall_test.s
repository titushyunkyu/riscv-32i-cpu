.section .text.main
.globl main

main:
    addi s5, x0, 0       # x21 = 0
    addi s4, x0, 4       # x20 = 4
    sw   s4, 40(s5)      # memory[40] = 4

    addi t3, x0, 3       # x28 = 3
    addi s6, x0, 6       # x22 = 6
    addi s2, x0, 2       # x18 = 2

    lw   s7, 40(s5)      # x23 = memory[40] = 4
    and  s8, s7, t3      # x24 = x23 AND x28 = 0
    or   t2, s6, s7      # x7  = x22 OR x23 = 6
    sub  s3, s7, s2      # x19 = x23 - x18 = 2

done:
    beq x0, x0, done     # infinite loop
    
    