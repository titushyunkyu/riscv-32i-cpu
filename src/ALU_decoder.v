module ALU_decoder
	(
		input		[1:0]	ALUOp,
		input		[2:0]	funct3,
		input				funct7b5,
		input				opb5,
		output reg	[3:0]	ALUControl
	);

	always @(ALUOp, funct3, funct7b5, opb5)
		case (ALUOp)

			2'b00: ALUControl <= 3'b000; // add
			2'b01: ALUControl <= 3'b001; // sub

			2'b10: begin
				case (funct3)
					3'b000: begin
						if (funct7b5 && opb5)
							ALUControl <= 4'b0001; // sub
						else
							ALUControl <= 4'b0000; // add
					end
					3'b001: ALUControl <= 4'b0110; // sll / slli (funct7b5 must be 0)
					3'b010: ALUControl <= 4'b0101; // slt / slti
					3'b011: ALUControl <= 4'b1001; // sltu / sltiu
					3'b100: ALUControl <= 4'b0100; // xor / xori
					3'b101: begin                               // srl/srli vs sra/srai
						if (funct7b5)
							ALUControl <= 4'b1000; // sra / srai
						else
							ALUControl <= 4'b0111; // srl / srli
					end
					3'b110: ALUControl <= 4'b0011; // or / ori
					3'b111: ALUControl <= 4'b0010; // and / andi

					default: ALUControl <= 4'bxxxx;
				endcase

			end

			default: ALUControl <= 4'bxxxx;

		endcase

endmodule
