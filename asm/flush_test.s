.section .text.main
.globl main

main:
    addi s1, x0, 1       # x9  = 1
    addi s2, x0, 1       # x18 = 1
    addi s3, x0, 3       # x19 = 3
    addi t1, x0, 1       # x6  = 1
    addi t6, x0, 6       # x31 = 6
    addi s5, x0, 5       # x21 = 5

    beq  s1, s2, L1      # branch is taken because x9 == x18

    sub  s8, t1, s3      # should be flushed
    or   s9, t6, s5      # should be flushed

L1:
    and  s7, t6, s5      # x23 = x31 AND x21 = 4

done:
    beq x0, x0, done     # infinite loop
    
    