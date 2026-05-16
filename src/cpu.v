module cpu
  (input 			reset,
   input 			clock,
   input [31:0] 	ReadData,
	input [31:0]	Instr,
   output 			MemWrite,
   output [31:0] 	Addr,
   output [31:0] 	WriteData,
	output [31:0]	PC
	);

	datapath pipelined_datapath
	  (
			.reset(reset),
			.clock(clock),
			.Instr(Instr),
			.ReadData(ReadData),
			.MemWrite(MemWrite),
			.PC(PC),
			.Addr(Addr),
			.WriteData(WriteData)
	  );

endmodule