module instruction_decoder

	(
		input	[6:0]	op,
		output		MemAdr,		// lw or sw instructions
		output		ExecuteI,	// I-type instructions
		output		ExecuteR,	// R-type instructions
		output		BR,			// conditional branches
		output		JAL,			// jumps
		// new
		output 		LUI,			// load upper immediate
		output		AUIPC,		// add upper immediate to pc
		output		JALR			// jump and link register
	);
	
	wire isLoad;
	wire isStore;
	wire isItype;
	wire isRtype;
	wire isBranch;
	wire isJump;
	// new
	wire isLUI;
	wire isAUIPC;
	wire isJALR;
	
	assign isLoad = (op == 7'h03);
	assign isStore = (op == 7'h23);
	assign isItype = (op == 7'h13);
	assign isRtype = (op == 7'h33);
	assign isBranch = (op == 7'h63);
	assign isJump = (op == 7'h6f);
	//new
	assign isLUI = (op == 7'h37);
	assign isAUIPC = (op == 7'h17);
	assign isJALR = (op == 7'h67);
	
	assign MemAdr = (isLoad || isStore);
	assign ExecuteI = (isItype);
	assign ExecuteR = (isRtype);
	assign BR = (isBranch);
	assign JAL = (isJump);
	// new
	assign LUI = (isLUI);
	assign AUIPC = (isAUIPC);
	assign JALR = (isJALR);
	

endmodule
