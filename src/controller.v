module controller
	(
	  input       [6:0]   op,
	  input       [2:0]   funct3,
	  input               funct7b5,
	  input       [3:0]   flags,
	  output      [2:0]   ImmSrc,
	  output              PCSrc,
	  output              PCTargetSrc,
	  output              ALUSrcA,
	  output              ALUSrcB,
	  output      [1:0]   ResultSrc,
	  output      [3:0]   ALUControl,
	  output              RegWrite,
	  output              MemWrite,
	  output      [2:0]   LoadType,
	  output      [1:0]   StoreType
	);
	
	wire [1:0] ALUOp;
	wire       Branch;
	wire       BranchTaken;
	wire       ExecuteI;
	wire       ExecuteR;
	wire       JAL;
	wire       JALR;
	wire       Jump;
	wire       LUI;
	wire       AUIPC;
	wire       MemAdr;

	instruction_decoder instr_dec
	  (
			.op(op),
			.MemAdr(MemAdr),
			.ExecuteI(ExecuteI),
			.ExecuteR(ExecuteR),
			.BR(Branch),
			.JAL(JAL),
			.LUI(LUI),
			.AUIPC(AUIPC),
			.JALR(JALR)
	  );

	ControlSignalsLogic control_logic
	  (
			.MemAdr(MemAdr),
			.ExecuteI(ExecuteI),
			.AUIPC(AUIPC),
			.ExecuteR(ExecuteR),
			.LUI(LUI),
			.BR(Branch),
			.JALR(JALR),
			.JAL(JAL),
			.opb5(op[5]),
			.ALUSrcA(ALUSrcA),
			.ALUSrcB(ALUSrcB),
			.ResultSrc(ResultSrc),
			.RegWrite(RegWrite),
			.MemWrite(MemWrite),
			.ALUOp(ALUOp)
	  );

	imm_src_decoder imm_dec
	  (
			.op(op),
			.ImmSrc(ImmSrc)
	  );

	ALU_decoder alu_dec
	  (
			.ALUOp(ALUOp),
			.funct3(funct3),
			.funct7b5(funct7b5),
			.opb5(op[5]),
			.ALUControl(ALUControl)
	  );

	load_store_decoder ls_dec
	  (
			.funct3(funct3),
			.LoadType(LoadType),
			.StoreType(StoreType)
	  );

	branch_unit br_unit
	  (
			.Branch(Branch),
			.funct3(funct3),
			.flags(flags),
			.taken(BranchTaken)
	  );

	assign Jump = JAL | JALR;
	assign PCTargetSrc = JALR;
	assign PCSrc = BranchTaken | Jump;

endmodule