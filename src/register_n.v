module register_n

	#(parameter WIDTH = 8)
	(
		input 	reset,
		input 	clock,
		input 	enable,
		input 	[WIDTH-1:0] D,
		output reg [WIDTH-1:0]	Q
	);
	
	reg [WIDTH-1:0] Q_next;
	
	// current state output logic
	always @(posedge reset, posedge clock)
	begin
		if (reset == 1)
			Q<={WIDTH{1'b0}};
		else
			Q<=Q_next;
		end
	
	// next state logic
	always @(Q, enable, D)
	begin
		if (enable == 1)
			Q_next <= D;
		else
			Q_next <= Q;
		end
		

endmodule
