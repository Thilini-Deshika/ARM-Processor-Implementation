//E/16/078
//module to get the shift bit
//logical shift : shift bit = 0
//arithematic shift : shift bit = most significant bit

module shift_bit(READ_DATA,SHIFT_ARITH,SHIFT_BIT);

	//port declaration
	input [7:0]READ_DATA;
	input SHIFT_ARITH;
	
	//output
	output SHIFT_BIT;
	reg SHIFT_BIT;
	
	always @ (SHIFT_ARITH,READ_DATA)
	begin
	
		//arithematic shift : shift bit = most significant bit of read data
		if(SHIFT_ARITH == 1'b1)
		begin
			SHIFT_BIT = READ_DATA[7];
		end
		
		//logical shift : shift bit = 0
		else if (SHIFT_ARITH == 1'b0)
		begin
			SHIFT_BIT = 1'b0;
		end
	
	end
	
endmodule