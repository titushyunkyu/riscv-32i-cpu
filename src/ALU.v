module ALU
	(
		input [31:0]	A,
		input [31:0]	B,
		input [3:0]		ALUcontrol,
		output reg [31:0] result,
		output [3:0] flags
	);
	
	wire [31:0] condinvb;
	wire [31:0] sum;
	wire			v, c, n, z; // flags: overflow, carry out, negative, zero
	wire			cout; // carry out of adder
	
	// condition 1: is addition, subtraction, or set less than (slt)?

	wire			Condition1;
	assign Condition1 = (~ALUcontrol[3] & ~ALUcontrol[2] & ~ALUcontrol[1]) |
							  (~ALUcontrol[1] & ~ALUcontrol[1] & ALUcontrol[0]) |
							  (~ALUcontrol[3] & ALUcontrol[2] & ~ALUcontrol[1] & ALUcontrol[0]) |
	                    (ALUcontrol[3] & ~ALUcontrol[2] & ~ALUcontrol[1] & ALUcontrol[0]);
	
	// condition 2: A and result have different signs
	wire			Condition2;
	assign Condition2 = (A[31] ^ sum[31]);
	
	
	// condition 3: overflow is possible
	wire 			Condition3;
	assign Condition3 = ~(A[31] ^ B[31] ^ ALUcontrol[0]);
	
	
	// logic to perform arithmetic and logic operations.
	assign condinvb = B ^ {32{ALUcontrol[0]}};
	assign {cout, sum} = A + condinvb + ALUcontrol[0];
	
	// logic to produce flags
	assign flags = {v, c, n, z};
	assign z = (result == 32'b0);
	assign n = result[31];
	assign c = cout & Condition1;
	assign v = Condition1 & Condition2 & Condition3;
	
	// decoder to produce ALU result based on value of ALUcontrol
	always @(ALUcontrol, sum, A, B, v, c, cout)
		case (ALUcontrol)
			3'b000:	result <= sum;									// add
			3'b001:	result <= sum;									// subtract
			3'b010:	result <= A & B;								// and
			3'b011:	result <= A | B;								// or
			4'b0100: result <= A ^ B;								// xor
			3'b101: 	result <= {31'b0, (sum[31] ^ v)};		// slt (signed)
			3'b110: 	result <= A << B[4:0];						// sll
			4'b0111: result <= A >> B[4:0];                 // srl   (NEW)
			4'b1000: result <= $signed(A) >>> B[4:0];			// sra   (NEW)
			4'b1001: result <= {31'b0, ~cout};					// sltu  (NEW)
			default:	result <= 32'bx;
		endcase // case(ALUcontrol)
			
endmodule
