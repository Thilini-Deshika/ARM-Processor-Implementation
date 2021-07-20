//E/16/078
//and gate with two input ports
//to check if both ZERO signal and BRANCH signal is set to high


module and_gate (in1,in2,out);

	//port declaration
	
	//inputs
	input in1;
	input in2;
	
	//output
	output out;
	reg out;
	
	//sensitivity list : in1,in2
	//out = 1 if both inputs are 1
	always @ (in1,in2)
	begin
		out = in1 & in2 ;
	end

endmodule