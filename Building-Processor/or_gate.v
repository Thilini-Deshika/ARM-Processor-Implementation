//E/16/078
//or gate with 3 input ports
//to check if jump | branch when ZERO is high | Branch not eqaul when zero is low


module or_gate (in1,in2,in3,out);

	//port declaration
	
	//inputs
	input in1;
	input in2;
	input in3;
	
	//output
	output out;
	reg out;
	
	//sensitivity list : in1,in2
	//out = 1 if one of the inputs are 1
	always @ (in1,in2,in3)
	begin
		out = in1|in2|in3 ;
	end

endmodule