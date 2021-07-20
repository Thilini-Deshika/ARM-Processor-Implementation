//E/16/078
//adder to get next instruction address (PC+4), PC value if current instruction is not branch

 `timescale  1ns/100ps

module adder1(PC,NEXT_INS);

	//port declaration
	
	//input
	input [31:0] PC;
	
	//output
	output [31:0]NEXT_INS;
	reg [31:0]NEXT_INS;
	
	//output PC+4
	always @ (PC)
	begin
		#1 //pc adder delay
		NEXT_INS = PC +4;
	end
	


endmodule