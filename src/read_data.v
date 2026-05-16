module read_data
	(
		input		[2:0]	LoadType,
		input		[1:0]	Addr,
		input		[31:0]	ReadData,
		output reg	[31:0]	ReadDataExt
	);

	wire [7:0] selected_byte;
	wire [15:0] selected_half;

	assign selected_byte =
		(Addr == 2'b00) ? ReadData[7:0]   :
		(Addr == 2'b01) ? ReadData[15:8]  :
		(Addr == 2'b10) ? ReadData[23:16] :
		                  ReadData[31:24];

	assign selected_half =
		(Addr[1] == 1'b0) ? ReadData[15:0] : ReadData[31:16];

	always @(*) begin
		case (LoadType)
			3'b000: ReadDataExt = ReadData;                           // lw
			3'b001: ReadDataExt = {24'b0, selected_byte};            // lbu
			3'b010: ReadDataExt = {{24{selected_byte[7]}}, selected_byte}; // lb
			3'b100: ReadDataExt = {16'b0, selected_half};            // lhu
			3'b101: ReadDataExt = {{16{selected_half[15]}}, selected_half}; // lh
			default: ReadDataExt = 32'bx;
		endcase
	end

endmodule