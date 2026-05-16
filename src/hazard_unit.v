module hazard_unit
	(
		input       [4:0] rs1D,
		input       [4:0] rs2D,
		input       [4:0] rs1E,
		input       [4:0] rs2E,
		input       [4:0] rdE,
		input       [4:0] rdM,
		input       [4:0] rdW,
		input             PCSrcE,
		input             readsRs1D,
		input             readsRs2D,
		input             isLoadE,
		input             RegWriteM,
		input             RegWriteW,
		output            StallF,
		output            StallD,
		output            FlushD,
		output            FlushE,
		output reg  [1:0] ForwardAE,
		output reg  [1:0] ForwardBE
	);

	wire rs1LoadHazard;
	wire rs2LoadHazard;
	wire lwStall;

	assign rs1LoadHazard = readsRs1D && (rs1D == rdE) && (rdE != 5'b00000);
	assign rs2LoadHazard = readsRs2D && (rs2D == rdE) && (rdE != 5'b00000);
	assign lwStall       = isLoadE && (rs1LoadHazard || rs2LoadHazard);

	assign StallF = lwStall;
	assign StallD = lwStall;

	assign FlushD = PCSrcE;
	assign FlushE = PCSrcE || lwStall;

	always @(*) begin
		if ((rs1E == rdM) && RegWriteM && (rs1E != 5'b00000))
			ForwardAE = 2'b10;       // forward from Memory stage
		else if ((rs1E == rdW) && RegWriteW && (rs1E != 5'b00000))
			ForwardAE = 2'b01;       // forward from Writeback stage
		else
			ForwardAE = 2'b00;       // use register file value
	end

	always @(*) begin
		if ((rs2E == rdM) && RegWriteM && (rs2E != 5'b00000))
			ForwardBE = 2'b10;       // forward from Memory stage
		else if ((rs2E == rdW) && RegWriteW && (rs2E != 5'b00000))
			ForwardBE = 2'b01;       // forward from Writeback stage
		else
			ForwardBE = 2'b00;       // use register file value
	end

endmodule
