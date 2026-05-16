module write_data
	(
		input		[1:0]	StoreType,
		input		[1:0]	Addr,
		input		[31:0]	rd2,
		input		[31:0]	ReadData,
		output reg	[31:0]	WriteData
	);

	always @(*) begin
		case (StoreType)
			2'b00: WriteData = rd2; // sw

			2'b01: begin // sb
				case (Addr)
					2'b00: WriteData = {ReadData[31:8],  rd2[7:0]};
					2'b01: WriteData = {ReadData[31:16], rd2[7:0], ReadData[7:0]};
					2'b10: WriteData = {ReadData[31:24], rd2[7:0], ReadData[15:0]};
					2'b11: WriteData = {rd2[7:0], ReadData[23:0]};
				endcase
			end

			2'b10: begin // sh
				case (Addr[1])
					1'b0: WriteData = {ReadData[31:16], rd2[15:0]};
					1'b1: WriteData = {rd2[15:0], ReadData[15:0]};
				endcase
			end

			default: WriteData = 32'bx;
		endcase
	end

endmodule