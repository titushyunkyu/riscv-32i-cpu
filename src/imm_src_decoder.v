module imm_src_decoder
	(
		input				[6:0]	op,
		output	reg	[2:0]	ImmSrc
	);
	
		
		always @(op)
		case (op)
			7'b0000011: ImmSrc <= 3'b000; // load
			7'b0010011: ImmSrc <= 3'b000; // ALU immediate
			7'b1100111: ImmSrc <= 3'b000; // jalr
			7'b0100011: ImmSrc <= 3'b001; // store
			7'b1100011: ImmSrc <= 3'b010; // branch
			7'b1101111: ImmSrc <= 3'b011; // jal
			7'b0010111: ImmSrc <= 3'b100; // auipc
			7'b0110111: ImmSrc <= 3'b100; // lui
			default:    ImmSrc <= 3'bxxx;
		endcase
		
endmodule
