//E/16/078
//mux to get IN = data to be written to the register file
//select from READDATA and ALURESULT

 `timescale  1ns/100ps

module mux_write (READDATA,ALURESULT,SEL_MUX_WRITE,OUT_MUX_WRITE);

	//port declaration
	input [7:0]READDATA;
	input [7:0]ALURESULT;
	input SEL_MUX_WRITE;
	
	output [7:0]OUT_MUX_WRITE;
	reg [7:0]OUT_MUX_WRITE;
	

	//check output
	always @(READDATA,ALURESULT,SEL_MUX_WRITE)
	begin
	
		//output READDATA
		if (SEL_MUX_WRITE == 1'b0)
			begin
				OUT_MUX_WRITE = READDATA;
			end
		
		//output ALURESULT
		else if (SEL_MUX_WRITE == 1'b1)
			begin
				OUT_MUX_WRITE = ALURESULT;
			end
		end
	
	
	
endmodule