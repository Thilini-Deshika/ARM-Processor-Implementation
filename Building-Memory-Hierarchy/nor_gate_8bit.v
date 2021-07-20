//E/16/078
//NOR  gate with 8 bit input ports
//to get ZERO signal from 8 bits in alu result

 `timescale  1ns/100ps

module nor_8bit (in1,in2,in3,in4,in5,in6,in7,in8,out);

	//port declaration
	
	//inputs
	input in1;
	input in2;
	input in3;
	input in4;
	input in5;
	input in6;
	input in7;
	input in8;
	
	//output
	output out;
	
	//changing parameters inside module
	reg out;
	
	//block to get the output of 8 bit input nor gate
	//sensitivity list : in1,in2,in3,in4,in5,in6,in7,in8
	always @ (in1,in2,in3,in4,in5,in6,in7,in8)
	begin
		out = ~(in1|in2|in3|in4|in5|in6|in7|in8);
	end

endmodule