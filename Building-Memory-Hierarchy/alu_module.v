//CO224 : Lab 5 : Part 1
//E/16/078 

//include nor gate with 8 input ports
`include "nor_gate_8bit.v"


 `timescale  1ns/100ps

//ALU module
module alu(DATA1, DATA2, RESULT, SELECT,ZERO);

	//port declaration
	input [7:0]DATA1;
	input [7:0]DATA2;
	input [2:0]SELECT;
	output [7:0]RESULT;
	output ZERO;	//ZERO = 1 if alu result=0 
	
	reg [7:0]RESULT;
	wire ZERO;
	
	//ports inside module
	wire [7:0] FORWARD_RESULT, ADD_RESULT, AND_RESULT, OR_RESULT;
	
	
	assign #1 FORWARD_RESULT = DATA2;		//forward
	assign #2 ADD_RESULT = DATA1 + DATA2;	//add
	assign #1 AND_RESULT = DATA1 & DATA2;	//and
	assign #1 OR_RESULT = DATA1 | DATA2;	//or
	
	
	always @(SELECT,FORWARD_RESULT,ADD_RESULT,AND_RESULT,OR_RESULT)
	begin
		case(SELECT)
		
			3'b000: RESULT = FORWARD_RESULT;	//forward
			3'b001: RESULT = ADD_RESULT;		//add		
			3'b010: RESULT = AND_RESULT;		//and	
			3'b011: RESULT = OR_RESULT;			//or
			
		endcase	
	end
	
	
	//add nor gate with 8 input ports to get ZERO signal
	//8 bits in RESULT goes to 8 input ports of nor gate
	nor_8bit my_nor_8bit (RESULT[0],RESULT[1],RESULT[2],RESULT[3],RESULT[4],RESULT[5],RESULT[6],RESULT[7],ZERO);
	
endmodule

