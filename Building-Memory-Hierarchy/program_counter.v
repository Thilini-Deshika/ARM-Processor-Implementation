//E/16/078
//program counter module

 `timescale  1ns/100ps

module program_counter(PC, RESET, CLK, PC_INPUT,BUSYWAIT);

	//port declaration
	
	//inputs
	input RESET;
	input CLK;
	input [31:0]PC_INPUT;
	input BUSYWAIT;
	
	//output
	output [31:0]PC;
	reg [31:0]PC;
	
	
	
	//PC update : when both reset and busywait signals are not asserted
	always @(posedge CLK)
	begin
		#1; //pc update delay
		if(RESET==1'b0 && BUSYWAIT==1'b0)
		begin
			
			PC = PC_INPUT;
		end
	end
	
	
	//reset operation
	//If RESET is set to 1 : reset should be done
	always @ (*)
	begin
		if(RESET==1'b1) 
		begin
			#1 //pc reset delay
			PC = -32'd4 ;
			
		end
		
	end
	

endmodule

