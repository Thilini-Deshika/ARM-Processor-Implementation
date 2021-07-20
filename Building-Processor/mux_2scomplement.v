//E/16/078
//mux to check whether regout2 or 2s complement to be output

module mux_2scomplement (REGOUT2, MUX_2C, OUT_MUX_2C);

	//port declaration
	input [7:0]REGOUT2;
	input MUX_2C;
	
	output [7:0]OUT_MUX_2C;
	
	//specify output to a register
	reg [7:0]OUT_MUX_2C;
	

	//check output
	always @(REGOUT2,MUX_2C)
	begin
	
		//output regout
		if (MUX_2C == 1'b0)
			begin
				OUT_MUX_2C = REGOUT2;
			end
		
		//output 2s complement (invert all bits+1)	
		else
			begin
				OUT_MUX_2C = ~REGOUT2 +1;
			end
		end
	
	
	
endmodule
