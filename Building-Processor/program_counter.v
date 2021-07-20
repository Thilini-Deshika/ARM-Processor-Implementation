//E/16/078
//program counter module

module program_counter(PC, RESET, CLK, PC_INPUT);

	//port declaration
	
	//inputs
	input RESET;
	input CLK;
	input [31:0]PC_INPUT;
	
	//output
	output [31:0]PC;
	reg [31:0]PC;
	
	
	
	//PC update
	always @(posedge CLK)
	begin
		if(RESET==1'b0)
		begin
			#1 //pc update delay
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

