//E/16/078
//mux to select data word from data words, according to the offset

 `timescale  1ns/100ps

module mux_get_dataword (word0, word1, word2, word3, offset, dataword);

	//port declaration
	input [7:0]word0;
	input [7:0]word1;
	input [7:0]word2;
	input [7:0]word3;
	input [1:0]offset;
	
	output reg [7:0]dataword;
	
	always @ (word0, word1, word2, word3, offset)
	begin
	
		#1 //data word selection delay 
		
		case(offset)			
			2'b00: dataword = word0;
			2'b01: dataword = word1;
			2'b10: dataword = word2;
			2'b11: dataword = word3;		
		endcase
	end
	
endmodule