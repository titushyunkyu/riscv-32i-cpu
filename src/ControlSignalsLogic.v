module ControlSignalsLogic
	(
	  input               MemAdr,
	  input               ExecuteI,
	  input               AUIPC,
	  input               ExecuteR,
	  input               LUI,
	  input               BR,
	  input               JALR,
	  input               JAL,
	  input               opb5,
	  output              ALUSrcA,
	  output              ALUSrcB,
	  output      [1:0]   ResultSrc,
	  output              RegWrite,
	  output              MemWrite,
	  output      [1:0]   ALUOp
	);

	wire isLoad;
	wire isStore;

	assign isLoad = MemAdr & ~opb5;
	assign isStore = MemAdr & opb5;

	assign ALUSrcA = LUI;
	assign ALUSrcB = MemAdr | ExecuteI | JALR | LUI;

	assign ResultSrc = AUIPC        ? 2'b11 :
						  (JAL | JALR) ? 2'b10 :
						  isLoad       ? 2'b01 :
											  2'b00;

	assign RegWrite = isLoad | ExecuteI | ExecuteR | JAL | JALR | LUI | AUIPC;
	assign MemWrite = isStore;

	assign ALUOp = BR                   ? 2'b01 :
					 (ExecuteR | ExecuteI)? 2'b10 :
												  2'b00;

	endmodule