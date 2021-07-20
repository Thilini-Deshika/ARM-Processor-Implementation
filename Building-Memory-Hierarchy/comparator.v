//E/16/078
//comparator to check if two 3 bit inputs are equal
//use to do tag comparison

 `timescale  1ns/100ps

module comparator (tag_stored,tag_in,tag_check);

	//port declaration
	input [2:0]tag_stored;
	input [2:0]tag_in;	
	output reg tag_check;
	
	//ports inside block
	//outputs of xnor
	reg check1;
	reg check2;
	reg check3;
	
	
	always @ (tag_stored,tag_in)
	begin
		
		#0.9 //tag comparison delay
		
		//get xnor of corresponding bits of two inputs
		check1 = ~(tag_stored[0] ^ tag_in[0]);
		check2 = ~(tag_stored[1] ^ tag_in[1]);
		check3 = ~(tag_stored[2] ^ tag_in[2]);
		
		//get AND of three xnor outputs
		tag_check = check1 && check2 && check3 ;
		
	end

endmodule
