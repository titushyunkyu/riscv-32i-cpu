module branch_unit
	(
		input				Branch,
		input		[2:0]	funct3,   // not used yet
		input		[3:0]	flags,    // {v,c,n,z}
		output	reg		taken
	);


	always @(*) begin
		 taken = 1'b0;
		 if (Branch) begin
			  case (funct3)
					3'b000: taken =  flags[0];               // beq  : z
					3'b001: taken = ~flags[0];               // bne  : ~z
					3'b100: taken =  flags[1] ^ flags[3];    // blt  : n ^ v
					3'b101: taken = ~(flags[1] ^ flags[3]);  // bge  : ~(n ^ v)
					3'b110: taken = ~flags[2];               // bltu : ~c
					3'b111: taken =  flags[2];               // bgeu : c
					default: taken = 1'b0;
			  endcase
		 end
	end

endmodule
