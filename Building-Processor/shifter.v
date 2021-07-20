//E/16/078
//shifting module

module shifter (VALUE,OFFSET,SHIFT_BIT,DIRECTION,SHIFTED_VALUE);

	//port declaration
	
	//inputs
	input [7:0]VALUE;
	input [7:0]OFFSET;
	input SHIFT_BIT;
	input DIRECTION; //right=1, left=0
	
	//outputs
	output [7:0]SHIFTED_VALUE;
	wire [7:0]SHIFTED_VALUE;
	
	//parameters inside module
	wire [7:0]OUT_SHIFT1;	//output of 1 bit shifer
	wire [7:0]OUT_SHIFT2;	//output of 2 bit shifer
	wire [7:0]OUT_SHIFT4;	//output of 4 bit shifer
	
	
	
	//add shifting modules
	shift_1 my_shift_1(VALUE,SHIFT_BIT,DIRECTION,OFFSET[0],OUT_SHIFT1);
	shift_2 my_shift_2(OUT_SHIFT1,SHIFT_BIT,DIRECTION,OFFSET[1],OUT_SHIFT2);
	shift_4 my_shift_4(OUT_SHIFT2,SHIFT_BIT,DIRECTION,OFFSET[2],OUT_SHIFT4);
	shift_8 my_shift_8(OUT_SHIFT4,SHIFT_BIT,OFFSET[3],SHIFTED_VALUE);
	
endmodule


//shift 1 bit module
module shift_1 (VALUE,SHIFT_BIT,DIRECTION,SHIFT_ENABLE,OUT_SHIFT1);

	input [7:0]VALUE;
	input SHIFT_BIT;
	input DIRECTION;
	input SHIFT_ENABLE;
	
	output [7:0]OUT_SHIFT1;
	reg [7:0]OUT_SHIFT1;
	
	always @(*) begin
	
	//right shift 1 bit
	if (SHIFT_ENABLE == 1'b1 && DIRECTION == 1'b1)
	begin
		#1 //shifting delay
		OUT_SHIFT1 = {SHIFT_BIT,VALUE[7:1]};
	end
	
	//left shift 1 bit
	else if (SHIFT_ENABLE == 1'b1 && DIRECTION == 1'b0)
	begin
		#1 //shifting delay
		OUT_SHIFT1 = {VALUE[6:0],SHIFT_BIT};
	end
	
	//no shifting
	else
	begin
		#1 //shifting delay
		OUT_SHIFT1 = VALUE;
	end
	
	end
endmodule




//shift 2 bit module
module shift_2 (VALUE,SHIFT_BIT,DIRECTION,SHIFT_ENABLE,OUT_SHIFT2);

	input [7:0]VALUE;
	input SHIFT_BIT;
	input DIRECTION;
	input SHIFT_ENABLE;
	
	output [7:0]OUT_SHIFT2;
	reg [7:0]OUT_SHIFT2;
	
	
	always @(*) begin
	
	//right shift 2 bit
	if (SHIFT_ENABLE == 1'b1 && DIRECTION == 1'b1)
	begin
		#1 //shifting delay
		OUT_SHIFT2 = {SHIFT_BIT,SHIFT_BIT,VALUE[7:2]};
	end
	
	//left shift 2 bit
	else if (SHIFT_ENABLE == 1'b1 && DIRECTION == 1'b0)
	begin
		#1 //shifting delay
		OUT_SHIFT2 = {VALUE[5:0],SHIFT_BIT,SHIFT_BIT};
	end
	
	//no shifting
	else
	begin
		#1 //shifting delay
		OUT_SHIFT2 = VALUE;
	end
	
	end
	
endmodule


//shift 4 bit module
module shift_4 (VALUE,SHIFT_BIT,DIRECTION,SHIFT_ENABLE,OUT_SHIFT4);

	input [7:0]VALUE;
	input SHIFT_BIT;
	input DIRECTION;
	input SHIFT_ENABLE;
	
	output [7:0]OUT_SHIFT4;
	reg [7:0]OUT_SHIFT4;
	
	
	always @(*) begin
	
	//right shift 4 bit
	if (SHIFT_ENABLE == 1'b1 && DIRECTION == 1'b1)
	begin
		#1 //shifting delay
		OUT_SHIFT4 = {SHIFT_BIT,SHIFT_BIT,SHIFT_BIT,SHIFT_BIT,VALUE[7:4]};
	end
	
	//left shift 4 bit
	else if (SHIFT_ENABLE == 1'b1 && DIRECTION == 1'b0)
	begin
		#1 //shifting delay
		OUT_SHIFT4 = {VALUE[3:0],SHIFT_BIT,SHIFT_BIT,SHIFT_BIT,SHIFT_BIT};
	end
	
	//no shifting
	else
	begin
		#1 //shifting delay
		OUT_SHIFT4 = VALUE;
	end
	
	end
endmodule


//shift 8 bit module
module shift_8 (VALUE,SHIFT_BIT,SHIFT_ENABLE,OUT_SHIFT8);

	input [7:0]VALUE;
	input SHIFT_BIT;
	input SHIFT_ENABLE;
	
	output [7:0]OUT_SHIFT8;
	reg [7:0]OUT_SHIFT8;
	
	
	always @(*) begin
	
	//shift 8 bits with shift bit
	if (SHIFT_ENABLE == 1'b1)
	begin
		#1 //shifting delay
		OUT_SHIFT8 = {SHIFT_BIT,SHIFT_BIT,SHIFT_BIT,SHIFT_BIT,SHIFT_BIT,SHIFT_BIT,SHIFT_BIT,SHIFT_BIT};
	end
	
		
	//no shifting
	else
	begin
		#1 //shifting delay
		OUT_SHIFT8 = VALUE;
	end
	
	end
endmodule



















