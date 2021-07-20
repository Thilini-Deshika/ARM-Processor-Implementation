//E/16/078
//module to do sign extension(convert to 32 bit) and shift left 2(multiply by 4), of offset

 `timescale  1ns/100ps

module sign_extend_shift_left2(OFFSET,OUT_SIGN_EXTEND_SHIFT_LEFT2);

	//port declaration
	
	//input
	input [7:0]OFFSET;
	
	//output
	output [31:0]OUT_SIGN_EXTEND_SHIFT_LEFT2;
	reg [31:0]OUT_SIGN_EXTEND_SHIFT_LEFT2;
	
	//shift left 2 ---> add two 0 bits to the end of offset
	//sign extend ---> repeat the most significant bit of offset as remaining bits
	//output = [repeating of most significant bit + offset + 00]
	always @ (OFFSET)
	begin
	
		//most significant bit of offset = 0
		if (OFFSET[7] == 1'b0)
		begin
			OUT_SIGN_EXTEND_SHIFT_LEFT2 = {22'b0000000000000000000000,OFFSET,2'b0};
		end
		
		//most significant bit of offset =1
		else
		begin
			OUT_SIGN_EXTEND_SHIFT_LEFT2 = {22'b1111111111111111111111,OFFSET,2'b0};
		end
	
	end
	
endmodule