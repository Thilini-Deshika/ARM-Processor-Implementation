//E/16/078
//or gate with two input ports
//to check if jump or branch when ZERO is high

 `timescale  1ns/100ps

module or_gate (in1,in2,out);

	//port declaration
	
	//inputs
	input in1;
	input in2;
	
	//output
	output out;
	reg out;
	
	//sensitivity list : in1,in2
	//out = 1 if one of the inputs are 1
	always @ (in1,in2)
	begin
		out = in1|in2 ;
	end

endmodule