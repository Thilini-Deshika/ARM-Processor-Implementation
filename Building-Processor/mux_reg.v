//E/16/078
//mux to select the write data of register file : shifter output / alu result

module mux_reg (ALU_RESULT,SHIFTED_VALUE,SHIFT,WRITE_DATA);


	//port declaration
	input [7:0]ALU_RESULT;
	input [7:0]SHIFTED_VALUE;
	input SHIFT;

	//output
	output [7:0]WRITE_DATA;
	reg [7:0]WRITE_DATA;
	
	always @ (ALU_RESULT,SHIFTED_VALUE,SHIFT)
	begin
		
		//write alu result
		if (SHIFT == 1'b0)
		begin
			WRITE_DATA = ALU_RESULT;
		end
		
		//write shiter output
		else if (SHIFT == 1'b1)
		begin
			WRITE_DATA = SHIFTED_VALUE;
		end
		
	end

endmodule