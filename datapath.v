module datapath
	(
	  input               reset,
	  input               clock,
	  input       [31:0]  Instr,
	  input       [31:0]  ReadData,
	  output              MemWrite,
	  output      [31:0]  PC,
	  output      [31:0]  Addr,
	  output      [31:0]  WriteData
	);

	localparam [31:0] NOP = 32'h00000013; 

	// fetch
	wire [31:0] PCF;
	wire [31:0] PCPlus4F;
	wire [31:0] PCNextF;
	wire        StallF;
	wire        StallD;
	wire        FlushD;
	wire        FlushE;

	assign PC = PCF;

	register_n #(32) PC_register
	  (
			.reset(reset),
			.clock(clock),
			.enable(~StallF),
			.D(PCNextF),
			.Q(PCF)
	  );

	adder PC_increment
	  (
			.a(PCF),
			.b(32'd4),
			.y(PCPlus4F)
	  );

	wire        PCSrcE;
	wire [31:0] PCTargetE;

	assign PCNextF = PCSrcE ? PCTargetE : PCPlus4F;

	// fetch/decode pipeline registers
	reg [31:0] InstrD;
	reg [31:0] PCD;
	reg [31:0] PCPlus4D;

	always @(posedge reset, posedge clock) begin
		if (reset) begin
			InstrD   <= NOP;
			PCD      <= 32'b0;
			PCPlus4D <= 32'b0;
		end
		else if (FlushD) begin
			InstrD   <= NOP;
			PCD      <= 32'b0;
			PCPlus4D <= 32'b0;
		end
		else if (~StallD) begin
			InstrD   <= Instr;
			PCD      <= PCF;
			PCPlus4D <= PCPlus4F;
		end
	end

	// decode
	wire [6:0] opD;
	wire [2:0] funct3D;
	wire       funct7b5D;
	wire [4:0] rs1D;
	wire [4:0] rs2D;
	wire [4:0] rdD;

	assign opD       = InstrD[6:0];
	assign rdD       = InstrD[11:7];
	assign funct3D   = InstrD[14:12];
	assign rs1D      = InstrD[19:15];
	assign rs2D      = InstrD[24:20];
	assign funct7b5D = InstrD[30];

	wire [2:0] ImmSrcD;
	wire       unused_PCSrcD;
	wire       unused_PCTargetSrcD;
	wire       unused_ALUSrcAD;
	wire       unused_ALUSrcBD;
	wire [1:0] unused_ResultSrcD;
	wire [3:0] unused_ALUControlD;
	wire       unused_RegWriteD;
	wire       unused_MemWriteD;
	wire [2:0] unused_LoadTypeD;
	wire [1:0] unused_StoreTypeD;

	controller controllerD
	  (
			.op(opD),
			.funct3(funct3D),
			.funct7b5(funct7b5D),
			.flags(4'b0000),
			.ImmSrc(ImmSrcD),
			.PCSrc(unused_PCSrcD),
			.PCTargetSrc(unused_PCTargetSrcD),
			.ALUSrcA(unused_ALUSrcAD),
			.ALUSrcB(unused_ALUSrcBD),
			.ResultSrc(unused_ResultSrcD),
			.ALUControl(unused_ALUControlD),
			.RegWrite(unused_RegWriteD),
			.MemWrite(unused_MemWriteD),
			.LoadType(unused_LoadTypeD),
			.StoreType(unused_StoreTypeD)
	  );

	wire [31:0] ImmExtD;
	wire [31:0] rd1D;
	wire [31:0] rd2D;

	extend extendD
	  (
			.Instr(InstrD),
			.ImmSrc(ImmSrcD),
			.ImmExt(ImmExtD)
	  );

	wire [4:0]  rdW;
	wire [31:0] ResultW;
	wire        RegWriteW;

	register_file rf
	  (
			.reset(reset),
			.clock(clock),
			.we3(RegWriteW),
			.a1(rs1D),
			.a2(rs2D),
			.a3(rdW),
			.wd3(ResultW),
			.rd1(rd1D),
			.rd2(rd2D)
	  );

	wire readsRs1D;
	wire readsRs2D;

	assign readsRs1D = (opD != 7'b1101111) &&   // JAL
	                   (opD != 7'b0010111) &&   // AUIPC
	                   (opD != 7'b0110111);     // LUI

	assign readsRs2D = (opD == 7'b0110011) ||   // R-type
	                   (opD == 7'b0100011) ||   // store
	                   (opD == 7'b1100011);     // branch

	// decode/execute pipeline registers
	reg [31:0] InstrE;
	reg [31:0] PCE;
	reg [31:0] PCPlus4E;
	reg [31:0] ImmExtE;
	reg [31:0] rd1E;
	reg [31:0] rd2E;
	reg [4:0]  rs1E;
	reg [4:0]  rs2E;
	reg [4:0]  rdE;

	always @(posedge reset or posedge clock) begin
	if (reset) begin
		InstrE   <= NOP;
		PCE      <= 32'b0;
		PCPlus4E <= 32'b0;
		ImmExtE  <= 32'b0;
		rd1E     <= 32'b0;
		rd2E     <= 32'b0;
		rs1E     <= 5'b0;
		rs2E     <= 5'b0;
		rdE      <= 5'b0;
	end
	else if (FlushE) begin
		InstrE   <= NOP;
		PCE      <= 32'b0;
		PCPlus4E <= 32'b0;
		ImmExtE  <= 32'b0;
		rd1E     <= 32'b0;
		rd2E     <= 32'b0;
		rs1E     <= 5'b0;
		rs2E     <= 5'b0;
		rdE      <= 5'b0;
	end
	else begin
		InstrE   <= InstrD;
		PCE      <= PCD;
		PCPlus4E <= PCPlus4D;
		ImmExtE  <= ImmExtD;
		rd1E     <= rd1D;
		rd2E     <= rd2D;
		rs1E     <= rs1D;
		rs2E     <= rs2D;
		rdE      <= rdD;
	end
end

	// execute
	wire [6:0] opE;
	wire [2:0] funct3E;
	wire       funct7b5E;

	assign opE       = InstrE[6:0];
	assign funct3E   = InstrE[14:12];
	assign funct7b5E = InstrE[30];

	wire [2:0] unused_ImmSrcE;
	wire       PCTargetSrcE;
	wire       ALUSrcAE;
	wire       ALUSrcBE;
	wire [1:0] ResultSrcE;
	wire [3:0] ALUControlE;
	wire       RegWriteE;
	wire       MemWriteE;
	wire [2:0] LoadTypeE;
	wire [1:0] StoreTypeE;
	wire [3:0] flagsE;

	controller controllerE
	  (
			.op(opE),
			.funct3(funct3E),
			.funct7b5(funct7b5E),
			.flags(flagsE),
			.ImmSrc(unused_ImmSrcE),
			.PCSrc(PCSrcE),
			.PCTargetSrc(PCTargetSrcE),
			.ALUSrcA(ALUSrcAE),
			.ALUSrcB(ALUSrcBE),
			.ResultSrc(ResultSrcE),
			.ALUControl(ALUControlE),
			.RegWrite(RegWriteE),
			.MemWrite(MemWriteE),
			.LoadType(LoadTypeE),
			.StoreType(StoreTypeE)
	  );

	wire [4:0]  rdM;
	wire        RegWriteM;
	wire [31:0] ResultM;
	wire [1:0]  ForwardAE;
	wire [1:0]  ForwardBE;
	wire        isLoadE;

	assign isLoadE = (opE == 7'b0000011);

	hazard_unit hazards
	  (
			.rs1D(rs1D),
			.rs2D(rs2D),
			.rs1E(rs1E),
			.rs2E(rs2E),
			.rdE(rdE),
			.rdM(rdM),
			.rdW(rdW),
			.PCSrcE(PCSrcE),
			.readsRs1D(readsRs1D),
			.readsRs2D(readsRs2D),
			.isLoadE(isLoadE),
			.RegWriteM(RegWriteM),
			.RegWriteW(RegWriteW),
			.StallF(StallF),
			.StallD(StallD),
			.FlushD(FlushD),
			.FlushE(FlushE),
			.ForwardAE(ForwardAE),
			.ForwardBE(ForwardBE)
	  );

	wire [31:0] ForwardedAE;
	wire [31:0] ForwardedBE;
	wire [31:0] SrcAE;
	wire [31:0] SrcBE;
	wire [31:0] ALUResultE;
	wire [31:0] PCTargetAddE;
	wire [31:0] ResultE;

	assign ForwardedAE = (ForwardAE == 2'b10) ? ResultM :
	                     (ForwardAE == 2'b01) ? ResultW :
	                                             rd1E;

	assign ForwardedBE = (ForwardBE == 2'b10) ? ResultM :
	                     (ForwardBE == 2'b01) ? ResultW :
	                                             rd2E;

	assign SrcAE = ALUSrcAE ? 32'b0   : ForwardedAE;
	assign SrcBE = ALUSrcBE ? ImmExtE : ForwardedBE;

	ALU aluE
	  (
			.A(SrcAE),
			.B(SrcBE),
			.ALUcontrol(ALUControlE),
			.result(ALUResultE),
			.flags(flagsE)
	  );

	adder pc_target_adderE
	  (
			.a(PCE),
			.b(ImmExtE),
			.y(PCTargetAddE)
	  );

	assign PCTargetE = PCTargetSrcE ? ALUResultE : PCTargetAddE;


	// execute/memory pipeline registers
	reg [31:0] InstrM;
	reg [31:0] ALUResultM;
	reg [31:0] PCTargetM;
	reg [31:0] PCPlus4M;
	reg [31:0] StoreDataM;

	always @(posedge reset, posedge clock) begin
		if (reset) begin
			InstrM     <= NOP;
			ALUResultM <= 32'b0;
			PCTargetM  <= 32'b0;
			PCPlus4M   <= 32'b0;
			StoreDataM <= 32'b0;
		end
		else begin
			InstrM     <= InstrE;
			ALUResultM <= ALUResultE;
			PCTargetM  <= PCTargetE;
			PCPlus4M   <= PCPlus4E;
			StoreDataM <= ForwardedBE;
		end
	end

	// memory
	wire [6:0] opM;
	wire [2:0] funct3M;
	wire       funct7b5M;

	assign opM       = InstrM[6:0];
	assign funct3M   = InstrM[14:12];
	assign funct7b5M = InstrM[30];
	assign rdM       = InstrM[11:7];

	wire [2:0] unused_ImmSrcM;
	wire       unused_PCSrcM;
	wire       unused_PCTargetSrcM;
	wire       unused_ALUSrcAM;
	wire       unused_ALUSrcBM;
	wire [1:0] ResultSrcM;
	wire [3:0] unused_ALUControlM;
	wire [2:0] LoadTypeM;
	wire [1:0] StoreTypeM;

	controller controllerM
	  (
			.op(opM),
			.funct3(funct3M),
			.funct7b5(funct7b5M),
			.flags(4'b0000),
			.ImmSrc(unused_ImmSrcM),
			.PCSrc(unused_PCSrcM),
			.PCTargetSrc(unused_PCTargetSrcM),
			.ALUSrcA(unused_ALUSrcAM),
			.ALUSrcB(unused_ALUSrcBM),
			.ResultSrc(ResultSrcM),
			.ALUControl(unused_ALUControlM),
			.RegWrite(RegWriteM),
			.MemWrite(MemWrite),
			.LoadType(LoadTypeM),
			.StoreType(StoreTypeM)
	  );

	wire [31:0] ReadDataExtM;
	wire [31:0] WriteDataM;

	read_data read_dataM
	  (
			.LoadType(LoadTypeM),
			.Addr(ALUResultM[1:0]),
			.ReadData(ReadData),
			.ReadDataExt(ReadDataExtM)
	  );

	write_data write_dataM
	  (
			.StoreType(StoreTypeM),
			.Addr(ALUResultM[1:0]),
			.rd2(StoreDataM),
			.ReadData(ReadData),
			.WriteData(WriteDataM)
	  );

	assign Addr      = ALUResultM;
	assign WriteData = WriteDataM;

	assign ResultM = (ResultSrcM == 2'b01) ? ReadDataExtM  :
	                 (ResultSrcM == 2'b10) ? PCPlus4M     :
	                 (ResultSrcM == 2'b11) ? PCTargetM    :
	                                          ALUResultM;

	// memory/writeback pipeline registers
	reg [31:0] InstrW;
	reg [31:0] ALUResultW;
	reg [31:0] PCTargetW;
	reg [31:0] PCPlus4W;
	reg [31:0] ReadDataExtW;

	always @(posedge reset, posedge clock) begin
		if (reset) begin
			InstrW       <= NOP;
			ALUResultW   <= 32'b0;
			PCTargetW    <= 32'b0;
			PCPlus4W     <= 32'b0;
			ReadDataExtW <= 32'b0;
		end
		else begin
			InstrW       <= InstrM;
			ALUResultW   <= ALUResultM;
			PCTargetW    <= PCTargetM;
			PCPlus4W     <= PCPlus4M;
			ReadDataExtW <= ReadDataExtM;
		end
	end

	// writeback
	wire [6:0] opW;
	wire [2:0] funct3W;
	wire       funct7b5W;

	assign opW       = InstrW[6:0];
	assign funct3W   = InstrW[14:12];
	assign funct7b5W = InstrW[30];
	assign rdW       = InstrW[11:7];

	wire [2:0] unused_ImmSrcW;
	wire       unused_PCSrcW;
	wire       unused_PCTargetSrcW;
	wire       unused_ALUSrcAW;
	wire       unused_ALUSrcBW;
	wire [1:0] ResultSrcW;
	wire [3:0] unused_ALUControlW;
	wire       unused_MemWriteW;
	wire [2:0] unused_LoadTypeW;
	wire [1:0] unused_StoreTypeW;

	controller controllerW
	  (
			.op(opW),
			.funct3(funct3W),
			.funct7b5(funct7b5W),
			.flags(4'b0000),
			.ImmSrc(unused_ImmSrcW),
			.PCSrc(unused_PCSrcW),
			.PCTargetSrc(unused_PCTargetSrcW),
			.ALUSrcA(unused_ALUSrcAW),
			.ALUSrcB(unused_ALUSrcBW),
			.ResultSrc(ResultSrcW),
			.ALUControl(unused_ALUControlW),
			.RegWrite(RegWriteW),
			.MemWrite(unused_MemWriteW),
			.LoadType(unused_LoadTypeW),
			.StoreType(unused_StoreTypeW)
	  );

	assign ResultW = (ResultSrcW == 2'b01) ? ReadDataExtW :
	                 (ResultSrcW == 2'b10) ? PCPlus4W    :
	                 (ResultSrcW == 2'b11) ? PCTargetW   :
	                                          ALUResultW;

endmodule