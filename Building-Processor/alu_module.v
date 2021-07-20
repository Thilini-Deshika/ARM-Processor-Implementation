//CO224 : Lab 5 : Part 1
//E/16/078 

//include nor gate with 8 input ports
`include "nor_gate_8bit.v"


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
	
	
	//always block to get RESULT
	//sensitivity list: DATA1,DATA2,SELECT : if either of input change, block should execute 
	always @ (DATA1,DATA2,SELECT)
	begin
		case(SELECT)
		
			//FORWARD : DATA2->RESULT
			3'b000:
				begin
				#1
				RESULT = DATA2;
				end
			
			//ADD : add DATA1 and DATA2
			3'b001:
				begin
				#2
				RESULT = DATA1 + DATA2;
				end
			
			//bitwise AND on DATA1 with DATA2
			3'b010:
				begin
				#1
				RESULT = DATA1 & DATA2;
				end
			
			//bitwise OR on DATA1 with DATA2
			3'b011:
				begin
				#1
				RESULT = DATA1 | DATA2;
				end
			
			//Reserved
			default:
				begin
				RESULT = 8'bxxxxxxxx;
				end
		
		endcase	
	end
	
	
	//add nor gate with 8 input ports to get ZERO signal
	//8 bits in RESULT goes to 8 input ports of nor gate
	nor_8bit my_nor_8bit (RESULT[0],RESULT[1],RESULT[2],RESULT[3],RESULT[4],RESULT[5],RESULT[6],RESULT[7],ZERO);
	
endmodule

