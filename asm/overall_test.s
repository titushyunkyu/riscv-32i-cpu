# This program should written for data at 0x2000 and text at 0 using RARS.
	.text
_start:	call main	# reset entry point for GNU

	.section	.text.load_register_values,"ax",@progbits
	.globl	load_register_values
load_register_values:
# When this function is called, all registers will be assigned a
# value equal to the register number. One exception is x1, which
# contains the return address to return from this function.
	add	x31, x1, x0	# x31 = x1 = return address
	addi	x1, x0,	1	# store x1 = 1
	add	x2, x1, x1	# x2 = x1 + x1 = 2
	ori	x3, x2, 1	# x3 = x2 OR 1 (immediate) = 3
	addi	x4, x3, 1	# x4 = x3 + 1 (immediate ) = 4
	add	x6, x4, x2	# x6 = x4 + x2 = 6
	addi	x5, x6, -1	# x5 = x6 - 1 = 5
	ori	x7, x4, 3	# x7 = x4 OR 3 (immediate) = 7
	addi	x10, x7, 3	# x10 = x7 + 3 (immediate) = 10
	sub	x8, x0, x2	# x8 = x0 - x2 = -2
	add	x8, x10, x8	# x8 = x10 + x8 = 8
	addi	x9, x10, -1	# x9 = x10 + (-1) (immediate) = 9
	addi	x27, x7, 20	# x27 = x7 + 20 (immediate) = 27 (binary ...00011011)
	add	x15, x9, x6	# x15 = x9 + x6 = 15             (binary ...00001111)
	and	x11, x15, x27	# x11 = x15 AND x27 = 11
# Now perform bit manipulations using identifiable strings
	sub	x16, x0, x1	# x16 = x0 - x1 = -1 = ffffffff
	sub	x16, x16, x1	# x16 = x16 - x1 = -2 = fffffffe		
	srl	x17, x16, x1	# x17 = x16 >> x1 (= 1) for (0111....1111) = 7ffffff
	and	x18, x16, x17	# x18 = x16 AND x17 = (0111...1110) = 7ffffffe
	xor	x19, x18, x16	# x19 = x18 XOR x16 = 800000000
	slli	x20, x15, 28	# x20 = x15 << 28 for (1111...0000) = f0000000
	sra	x21, x17, x8	# x21 = x17 >> x8 (arithmetic) = 007fffff
	srai	x23, x19, 8	# x23 = x19 >> 8 (arithmetic immediate) = ff800000
	or	x22, x21, x23	# x22 = x21 OR x23 = ffffffff
# resume filling registers with register values (i.e., 12 in x12, etc.)
	andi	x12, x17, 12	# x12 = x17 AND 12 (immediate) = 12
	srli	x13, x17, 29	# x13 = x17 >> 29 (immediate) = 3
	sll	x13, x13, x2	# x13 = x13 << x2 = 12
	add	x13, x13, x1	# x13 = x13 + x1 = 13
	sra	x14, x18, x27	# x14 = x18 >> x27 (arithmetic) = 15
	sub	x14, x14, x1	# x14 = x14 - x1 = 14
	slti	x16, x15, 16	# Test slti: x16 = x15 < 16 (immediate) = 1
	add	x16, x16, x15	# x16 = x16 + x15 = 16
	sltiu	x17, x16, 16	# Test sltiu: x17 = x16 < 16 (immediate) = 0
	add	x17, x16, x1	# x17 = x16 + x1 = 17
	slt	x18, x18, x19	# Test slt: x18 = x18 < x19 = 0
	add	x18, x17, x1	# x18 = x17 + x1 = 18
	sltu	x19, x19, x20	# Test sltu: x19 = x19 < x20 = 1
	add	x19, x19, x18	# x19 = x19 + x18 = 19
	slti	x20, x21, 1	# Test slti: x20 = x21 < 1 (immediate) = 0
	add	x20, x19, x1	# x20 = x19 + x1 = 20
	addi	x22, x22, 1	# x22 = x22 + 1 (immediate) = 0
	sltiu	x21, x22, 1	# Test sltiu: x21 = x22 < 1 (immediate) = 1
	add	x21, x21, x20	# x21 = x21 + x20 = 21
	slt	x22, x22, x1	# Test slt: x22 = x22 < x1 = 1
	add	x22, x22, x21	# x22 = x22 + x21 = 22
	sltu	x23, x23, x0	# Test sltu: x23 = x23 < x0 = 0
	add	x23, x22, x1	# x23 = x22 + x1 = 23
	sll	x24, x6, x2	# x24 = x6 << x2 = 24
	addi	x25, x27, -2	# x25 = x27 + (-2) (immediate) = 25
	add	x26, x24, x2	# x26 = x24 + x2 = 26
	slli	x28, x14, 1	# x28 = x14 << 1 (immediate) = 28
	add	x1, x31, x0	# x1 = x31 + x0, restore return address to x1
	ori	x31, x28, 3	# x31 = x28 OR 3 (immediate) = 31
	addi	x29, x31, -2	# x29 = x31 + (-2) (immediate) = 29
	srli	x30, x31, 1	# x30 = x31 >> 1 (immediate) = 15
	slli	x30, x30, 1	# x30 = x30 << 1 (immediate) = 30
	ret

	.section	.text.test_load_store,"ax",@progbits
	.globl	test_load_store
test_load_store:
# When this function is called, all registers should contain a
# value equal to the register number. One exception is x1, which
# contains the return address to return from this function. Also,
# x6 will not contain 6 since it is used when this function is called.
	addi	x31, x0, 2	# x31 = x0 + 2 (immediate)
	slli	x31, x31, 12	# x31 = x31 << 12 (immediate) = 0x2000 = RAM[0], start of RAM
	addi	x6, x0, 6	# x6 = x0 + 6 (immediate), store 6 in x6
	sb	x1, 4(x31)	# store byte 0 of x1 at RAM[1]
	sh	x2, 8(x31)	# store half-word 0 of x2 at RAM[2]
	sw	x3, 12(x31)	# store word x3 at RAM[3]
	sb	x4, 16(x31)	# store byte 0 of x4 at RAM[4]
	sh	x5, 20(x31)	# store half-word 0 of x5 at RAM[5]
	sw	x6, 24(x31)	# store word of x6 at RAM[6]
	sb	x7, 28(x31)	# store byte 0 of x7 at RAM[7]
	sh	x8, 32(x31)	# store half-word 0 x8 at RAM[8]
	sw	x9, 36(x31)	# store word of x9 at RAM[9]
	sb	x10, 40(x31)	# store byte 0 of x10 at RAM[10]
	sh	x11, 44(x31)	# store half-word 0 of x11 at RAM[11]
	sw	x12, 48(x31)	# store word of x12 at RAM[12]
	sb	x13, 52(x31)	# store byte 0 of x13 at RAM[13]
	sh	x14, 56(x31)	# store half-word 0 of x14 at RAM[14]
	sw	x15, 60(x31)	# store word of x15 at RAM[15]
	sb	x16, 64(x31)	# store byte 0 of x16 at RAM[16]
	sh	x17, 68(x31)	# store half-word 0 of x17 at RAM[17]
	sw	x18, 72(x31)	# store word of x18 at RAM[18]
	sb	x19, 76(x31)	# store byte 0 of x19 at RAM[19]
	sh	x20, 80(x31)	# store half-word 0 of x20 at RAM[20]
	sw	x21, 84(x31)	# store word of x21 at RAM[21]
	sb	x22, 88(x31)	# store byte 0 of x22 at RAM[22]
	sh	x23, 92(x31)	# store half-word 0 of x23 at RAM[23]
	sw	x24, 96(x31)	# store word of x24 at RAM[24]
	sb	x25, 100(x31)	# store byte 0 of x25 at RAM[25]
	sh	x26, 104(x31)	# store half-word 0 of x26 at RAM[26]
	sw	x27, 108(x31)	# store word of x27 at RAM[27]
	sb	x28, 112(x31)	# store byte 0 of x28 at RAM[28]
	sh	x29, 116(x31)	# store half-word 0 of x29 at RAM[29]
	sw	x30, 120(x31)	# store word of x30 at RAM[30]
	sw	x31, 124(x31)	# store word of x31 at RAM[31]
# Now, reset registers x2-x30 equal to zero before returning. Note that x1
# should not be reset to zero because it contains the return address. Also,
# x31 should not be reset to zero because it points to the start of RAM.
	addi	x2, x0, 0
	addi	x3, x0, 0
	addi	x4, x0, 0
	addi	x5, x0, 0
	addi	x6, x0, 0
	addi	x7, x0, 0
	addi	x8, x0, 0
	addi	x9, x0, 0
	addi	x10, x0, 0
	addi	x11, x0, 0
	addi	x12, x0, 0
	addi	x13, x0, 0
	addi	x14, x0, 0
	addi	x15, x0, 0
	addi	x16, x0, 0
	addi	x17, x0, 0
	addi	x18, x0, 0
	addi	x19, x0, 0
	addi	x20, x0, 0
	addi	x21, x0, 0
	addi	x22, x0, 0
	addi	x23, x0, 0
	addi	x24, x0, 0
	addi	x25, x0, 0
	addi	x26, x0, 0
	addi	x27, x0, 0
	addi	x28, x0, 0
	addi	x29, x0, 0
	addi	x30, x0, 0
	ret

	.section	.text.test_branch,"ax",@progbits
	.globl	test_branch
test_branch:
	lb	x2, 9(x31)	# load x2 = byte 1 of RAM[2] = 0
	beq	x2, x0, X2	# Test x2 = 0: branch to X2 taken
	jal	x0, failed	# jump to failed
X2:	lb	x2, 8(x31)	# load x2 = byte 0 of RAM[2] = 2
	beq	x2, x0, X2	# Test x2 = 0: branch to X2 not taken
	lh	x3, 14(x31)	# load x3 = half word 1 of RAM[3] = 0
	bne	x3, x1, X3	# Test x3 != x1: branch to X3 taken
	jal	x0, failed	# jump to failed
X3:	lh	x3, 12(x31)	# load x3 = half word 0 of RAM[3] = 3
	bne	x3, x3, X3	# Test x3 != x3: branch to X3 not taken
	lbu	x4, 16(x31)	# Load x4 = byte 0 (unsigned) of RAM[4] = 4
X4:	blt	x4, x5, X4	# Test x4 < x5: branch to X4 not taken
	lhu	x5, 20(x31)	# Load x5 = half word 0 (unsigned) of RAM[5] = 5
	blt	x4, x5, X6	# Test x4 < x5: branch to X6 taken
	jal	x0, failed	# jump to failed
X6:	lw	x6, 24(x31)	# load x6 = word of RAM[6] = 6
X7:	bltu	x6, x7, X7	# Test x6 < x7 (unsigned): branch to X7 not taken
	lb	x7, 28(x31)	# load x7 = byte 0 of RAM[7] = 7
	bltu	x6, x7, X8	# Test x6 < x7 (unsigned) branch to X8 taken
	jal	x0, failed	# jump to failed
X8:	lh	x8, 32(x31)	# load x8 = half word 0 of RAM[8] = 8
	bge	x8, x9, X9	# Test x8 >= x9: branch to X9 taken
	jal	x0, failed	# jump to failed
X9:	lbu	x9, 36(x31)	# load x9 = byte 0 (unsigned) of RAM[9] = 9
	bge	x8, x9, X9	# Test x8 >= x9: branch to X9 not taken
	lhu	x10, 40(x31)	# load x10 = half word 0 (unsigned) of RAM[10] = 10
	bgeu	x10, x11, X11	# Test x10 >= x11 (unsigned): branch to X11 taken
	jal	x0, failed	# jump to failed
X11:	lw	x11, 44(x31)	# load x11 = word at RAM[11] = 11
	bgeu	x10, x11, X11	# Test x10 >= x11 (unsigned): branch to X11 not taken
	lb	x12, 48(x31)	# load x12 = byte 0 at RAM[12] = 12
	bge	x12, x11, X27	# Test x12 >= x11: branch to X27 taken
X13:	lh	x13, 52(x31)	# load x13 = half word 0 at RAM[13] = 13
	lbu	x14, 56(x31)	# load x14 = byte 0 (unsigned) at RAM[14] = 14
	beq	x13, x14, X13	# Test x13 = x14: branch to X13 not taken
	lhu	x15, 60(x31)	# load x15 = half word 0 (unsigned) at RAM[15] = 15
	lw	x16, 64(x31)	# load x16 = word at RAM[16] = 16
	bne	x15, x16, X25	# Test x15 != x16: branch to X25 taken
X17:	lb	x17, 68(x31)	# load x17 = byte 0 at RAM[17] = 17
	lh	x18, 72(x31)	# load x18 = half word 0 at RAM[18] = 18
	blt	x18, x17, X17	# Test x18 < x17: branch to X17 not taken
	lbu	x19, 76(x31)	# load x19 = byte 0 (unsigned) at RAM[19] = 19
	lhu	x20, 80(x31)	# load x20 = half word 0 (unsigned) at RAM[20] = 20
	bltu	x19, x20, X23	# Test x19 < x20 (unsigned): branch to X23 taken
X31:	lbu	x29, 116(x31)	# load x29 = byte 0 (unsigend) at RAM[29] = 29
	beq	x29, x0, failed	# Test x29 = x0: branch to failed not taken
	jal	x0, almost	# jump to almost
failed:	beq	x0, x0, failed	# Test x0 = x0: branch to failed taken (infinite loop)
almost:	jal	x0, done	# jump to done
X21:	lw	x21, 84(x31)	# load x21 = word at RAM[21] = 21
	lb	x22, 88(x31)	# load x22 = byte 0 at RAM[22] = 22
	bne	x21, x22, X31	# Test x21 != x22: branch to X31 taken
X27:	lb	x27, 108(x31)	# load x27 = byte 0 at RAM[27] = 27
	lh	x28, 112(x31)	# load x28 = half word at RAM[28] = 28
	bgeu	x28, x27, X13	# Test x28 >= x27 (unsigned): branch to X13 taken
X25:	lhu	x25, 100(x31)	# load x25 = half word 0 (unsigned) at RAM[25] = 25
	lw	x26, 104(x31)	# load x26 = word at RAM[26] = 26
	bgeu	x26, x25, X17	# Test x26 >= x25 (unsigned): branch to X17 taken
X23:	lh	x23, 92(x31)	# load x23 = half word 0 at RAM[23] = 23
	lbu	x24, 96(x31)	# load x24 = byte 0 (unsigned) at RAM[24] = 24
	bne	x23, x24, X21	# Test x23 != x24: branch to X21 taken
done:	lw	x30, 120(x31)	# load x30 = word at RAM[30] = 30
	ret

	.section	.text.main,"ax",@progbits
	.globl	main
main:
	call 	load_register_values
	call 	test_load_store
	call 	test_branch
end:	beq 	x0, x0, end	# infinite loop
