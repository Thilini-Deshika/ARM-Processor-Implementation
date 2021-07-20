//E/16/078
//mux to select instruction word from instruction word block, according to the offset

 `timescale  1ns/100ps

module mux_get_ins_word (ins_word0, ins_word1, ins_word2, ins_word3, offset, ins_word);

	//port declaration
	input [31:0]ins_word0;
	input [31:0]ins_word1;
	input [31:0]ins_word2;
	input [31:0]ins_word3;
	input [1:0]offset;
	
	output reg [31:0]ins_word;
	
	always @ (ins_word0, ins_word1, ins_word2, ins_word3, offset)
	begin
	
		#1 //instruction word selection delay 
		
		case(offset)			
			2'b00: ins_word = ins_word0;
			2'b01: ins_word = ins_word1;
			2'b10: ins_word = ins_word2;
			2'b11: ins_word = ins_word3;		
		endcase
	end
	
endmodule