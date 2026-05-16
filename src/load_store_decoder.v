module load_store_decoder
	(
		input		[2:0]	funct3,
		output reg	[2:0]	LoadType,
		output reg	[1:0]	StoreType
	);

	always @(*) begin
		case (funct3)
			3'b010: begin
				LoadType  = 3'b000; // lw
				StoreType = 2'b00;  // sw
			end
			3'b100: begin
				LoadType  = 3'b001; // lbu
				StoreType = 2'bxx;
			end
			3'b000: begin
				LoadType  = 3'b010; // lb
				StoreType = 2'b01;  // sb
			end
			3'b101: begin
				LoadType  = 3'b100; // lhu
				StoreType = 2'bxx;
			end
			3'b001: begin
				LoadType  = 3'b101; // lh
				StoreType = 2'b10;  // sh
			end
			default: begin
				LoadType  = 3'bxxx;
				StoreType = 2'bxx;
			end
		endcase
	end

endmodule