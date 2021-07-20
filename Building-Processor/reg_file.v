//E/16/078
//register file module
module reg_file(IN, OUT1, OUT2, INADDRESS, OUT1ADDRESS, OUT2ADDRESS, WRITE, CLK, RESET);

	//port declaration
	input [7:0]IN;
	input [2:0]INADDRESS;
	input [2:0]OUT1ADDRESS;
	input [2:0]OUT2ADDRESS;
	input WRITE;
	input CLK;
	input RESET;
	
	
	output [7:0]OUT1;
	output [7:0]OUT2;
	
	wire [7:0]OUT1;
	wire [7:0]OUT2;
	
	//8 bit reg file
	reg [7:0] a[7:0];
	
	integer i;	//used for reset 
	
	//write operation
	//sensitivity list: positve edge of CLK : in each positive edge of CLK, if write is enabled and reset is in 0, do WRITE operation
	always @ (posedge CLK)
	begin
	
		if((WRITE==1) && (RESET==1'b0))
		begin
			#2	//write delay
			a[INADDRESS] = IN;
		end
	
	end
	
	
	
	//read operation
	//read delay #2
	assign #2 OUT1 = a[OUT1ADDRESS] ;
	assign #2 OUT2 = a[OUT2ADDRESS] ;
	
	
	
	
	//reset operation
	//If RESET is set to 1 : reset should be done
	always @ (*)
	begin
		if(RESET==1'b1) 
		begin
		
			#2	//reset delay
			for(i=0; i<8; i=i+1)
				begin	
					a[i]=8'b0;
				end
			
		end
		
	end
	
endmodule




