//E/16/078
//mux to select whether next instruction to execute is whether PC or PC+offset

 `timescale  1ns/100ps

module mux_pc(in0,in1,sel,out);

	//port declaration
	
	//inputs
	input sel;
	input [31:0]in0;
	input [31:0]in1;
	
	//output
	output [31:0]out;
	reg out;
	
	//sel = output of AND gate
	//if sel=0 ----> out PC value
	//if sel=1 ----> out PC+offset
	always @ (in0,in1,sel)
	begin
		
		//PC + offset
		if (sel == 1'b1)
		begin
			out = in1;
		end
		
		//PC
		else
		begin
			out = in0;
		end
	end

endmodule