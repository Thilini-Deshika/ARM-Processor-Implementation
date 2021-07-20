//E/16/078
//adder to add offset to next pc value

 `timescale  1ns/100ps

module adder2(in1,in2,out);

	//port declaration
	
	//inputs
	input [31:0]in1;
	input [31:0]in2;
	
	//output
	output [31:0]out;
	reg out;
	
	//sensitivity list : in1,in2
	//get the output byb adding in1 and in2
	always @ (in1,in2)
	begin
		#2	//adder delay
		out = in1+in2;
	end

endmodule