//E/16/078
//mux to check whether immediate value or output of mux_2scomplememnt (OUT_MUX_2C) to be output

module mux_immediate (IMMEDIATE, OUT_MUX_2C, MUX_IM, OUT_MUX_IM);

	//port declaration
	input [7:0]IMMEDIATE;
	input [7:0]OUT_MUX_2C;
	input MUX_IM;
	
	output [7:0]OUT_MUX_IM;
	
	//specify output to a register
	reg [7:0]OUT_MUX_IM;
	

	//check output
	always @(IMMEDIATE,OUT_MUX_2C,MUX_IM)
	begin
	
		//output immediate
		if (MUX_IM == 1'b0)
			begin
				OUT_MUX_IM = IMMEDIATE;
			end
		
		//output of mux_2scomplememnt (OUT_MUX_2C)
		else
			begin
				OUT_MUX_IM = OUT_MUX_2C;
			end
		end
	
	
	
endmodule
