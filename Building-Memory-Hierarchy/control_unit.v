//E/16/078
//control unit module

 `timescale  1ns/100ps

module control_unit(INSTRUCTION,READREG2,READREG1,WRITEREG,WRITEENABLE,ALUOP,IMMEDIATE,MUX_2C,MUX_IM,RESET,BRANCH,JUMP,SEL_MUX_WRITE,READ,WRITE,BUSYWAIT);

	//port declaration
	
	//inputs
	input [31:0]INSTRUCTION;
	input RESET;
	input BUSYWAIT;
	
	//outputs
	output [2:0]READREG2;
	output [2:0]READREG1;
	output [2:0]WRITEREG;
	output WRITEENABLE;
	output [2:0]ALUOP;
	output [7:0]IMMEDIATE;
	output MUX_2C;
	output MUX_IM;
	output BRANCH;
	output JUMP;
	output SEL_MUX_WRITE;
	output READ;
	output WRITE;
	
	
	//changing outputs
	reg [2:0]READREG2;
	reg [2:0]READREG1;
	reg [2:0]WRITEREG;
	reg WRITEENABLE;
	reg [2:0]ALUOP;
	reg [7:0]IMMEDIATE;
	reg MUX_2C;
	reg MUX_IM;
	reg BRANCH;
	reg JUMP;
	reg SEL_MUX_WRITE;
	reg READ;
	reg WRITE; 

	//declare decoding parameters
	reg [7:0] OP_CODE,DESTINATION,SOURCE_1,SOURCE_2;
	
	
	//control signals when RESET is high
	always @(RESET)
	begin
		if(RESET == 1'b1)
		begin
			WRITEENABLE = 1'b0;
			READ = 1'b0;
			WRITE = 1'b0;
			JUMP = 1'b0;
			BRANCH = 1'b0;
		end
	end
	
	

	//execute new instruction
	always @(INSTRUCTION)
	
	begin
		
		if (RESET == 1'b0) 
		begin
		
		
		//instruction decode
		OP_CODE = INSTRUCTION[31:24];
		DESTINATION = INSTRUCTION[23:16];
		SOURCE_1 = INSTRUCTION[15:8];
		SOURCE_2 = INSTRUCTION[7:0];
		
		
		//inputs to reg file and muxes
		READREG2 = SOURCE_2[2:0];
		READREG1 = SOURCE_1[2:0];
		WRITEREG = DESTINATION[2:0];
		IMMEDIATE = SOURCE_2;
		
		
		//reset control signals send to dmem, before instruction encoding
		READ = 1'b0;
		WRITE = 1'b0;
		
		
		//check opcode
		case (OP_CODE)
		
			//add
			8'b00000010:	
				begin
					#1 //decode delay
					WRITEENABLE = 1'b1;
					ALUOP =  3'b001;
					MUX_2C = 1'b0; 		//get regout2
					MUX_IM	= 1'b1;		//get mux_2c output
					BRANCH = 1'b0;		//not a branch signal
					JUMP = 1'b0;		//not a jump
					SEL_MUX_WRITE = 1'b1; //write alu result
					READ = 1'b0;		//no read from data memory
					WRITE = 1'b0;		//no write to data memory
				end
			
			
			//sub 
			8'b00000011:
				begin
					#1 //decode delay
					WRITEENABLE = 1'b1;
					ALUOP = 3'b001;
					MUX_2C = 1'b1; 		//get 2s complement
					MUX_IM = 1'b1;		//get mux_2c output
					BRANCH = 1'b0;		//not a branch signal
					JUMP = 1'b0;		//not a jump
					SEL_MUX_WRITE = 1'b1; //write alu result
					READ = 1'b0;		//no read from data memory
					WRITE = 1'b0;		//no write to data memory
				end
				
			
			
			//and
			8'b00000100:
				begin
					#1 //decode delay
					WRITEENABLE = 1'b1;
					ALUOP = 3'b010;
					MUX_2C = 1'b0;		//get regout2
					MUX_IM = 1'b1;		//get mux_2c output
					BRANCH = 1'b0;		//not a branch signal
					JUMP = 1'b0;		//not a jump
					SEL_MUX_WRITE = 1'b1; //write alu result
					READ = 1'b0;		//no read from data memory
					WRITE = 1'b0;		//no write from data memory
				end
				
				
				
			//or
			8'b00000101:
				begin
					#1 //decode delay
					WRITEENABLE = 1'b1;
					ALUOP = 3'b011;
					MUX_2C = 1'b0;		//get regout2
					MUX_IM = 1'b1;		//get mux_2c output
					BRANCH = 1'b0;		//not a branch signal
					JUMP = 1'b0;		//not a jump
					SEL_MUX_WRITE = 1'b1; //write alu result
					READ = 1'b0;		//no read from data memory
					WRITE = 1'b0;		//no write to data memory
				end
				
				
			
			//mov
			8'b00000001:
				begin
					#1 //decode delay
					WRITEENABLE = 1'b1;
					ALUOP = 3'b000;
					MUX_2C = 1'b0;		//get regout2
					MUX_IM = 1'b1;		//get mux_2c output
					JUMP = 1'b0;		//not a jump
					SEL_MUX_WRITE = 1'b1; //write alu result
					READ = 1'b0;		//no read from data memory
					WRITE = 1'b0;		//no write to data memory
				end
				
				
			//loadi
			8'b00000000:
				begin
					#1 //decode delay
					WRITEENABLE = 1'b1;
					ALUOP = 3'b000;
					MUX_2C = 1'b0;		//get regout2
					MUX_IM = 1'b0;		//get immediate
					BRANCH = 1'b0;		//not a branch signal
					JUMP = 1'b0;		//not a jump
					SEL_MUX_WRITE = 1'b1; //write alu result
					READ = 1'b0;		//no read from data memory
					WRITE = 1'b0;		//no write to data memory
				end
				
			//beq
			8'b00000111:
				begin
					#1 //decode delay
					WRITEENABLE = 1'b0;
					ALUOP = 3'b001;		//to do substract operation
					MUX_2C = 1'b1;		//get 2s complement
					MUX_IM = 1'b1;		//get mux_2c output
					BRANCH = 1'b1;		//a branch signal
					JUMP = 1'b0;		//not a jump
					SEL_MUX_WRITE = 1'bx; //no write done
					READ = 1'b0;		//no read from data memory
					WRITE = 1'b0;		//no write to data memory
				end
				
			//jump
			8'b00000110:
				begin
					#1 //decode delay
					WRITEENABLE = 1'b0;
					ALUOP = 3'bxxx;		//no alu operation is done
					MUX_2C = 1'b0;		//get regout2
					MUX_IM = 1'b1;		//get mux_2c output
					BRANCH = 1'b0;		//not a branch signal
					JUMP = 1'b1;		//a jump
					SEL_MUX_WRITE = 1'bx; //no write done
					READ = 1'b0;		//no read from data memory
					WRITE = 1'b0;		//no write to data memory
				end
				
			//instructions in lab6
			
			//lwd
			8'b00001000:
				begin
					#1 //decode delay
					WRITEENABLE = 1'b1;	//write is done
					ALUOP = 3'b000;		//forward data2 -> aluresult
					MUX_2C = 1'b0;		//get regout2
					MUX_IM = 1'b1;		//get mux_2c output
					BRANCH = 1'b0;		//not a branch signal
					JUMP = 1'b0;		//not a jump
					SEL_MUX_WRITE = 1'b0; //write readdata
					READ = 1'b1;		//read from data memory
					WRITE = 1'b0;		//no write from data memory
				end
				
			
			//lwi
			8'b00001001:
				begin
					#1 //decode delay
					WRITEENABLE = 1'b1;	//write is done
					ALUOP = 3'b000;		//forward data2 -> aluresult
					MUX_2C = 1'b0;		//get regout2
					MUX_IM = 1'b0;		//get immediate
					BRANCH = 1'b0;		//not a branch signal
					JUMP = 1'b0;		//not a jump
					SEL_MUX_WRITE = 1'b0; //write readdata
					READ = 1'b1;		//read from data memory
					WRITE = 1'b0;		//no write to data memory
				end
			
			//swd
			8'b00001010:
				begin
					#1 //decode delay
					WRITEENABLE = 1'b0;	//no write to register file is done
					ALUOP = 3'b000;		//forward data2 -> aluresult
					MUX_2C = 1'b0;		//get regout2
					MUX_IM = 1'b1;		//get mux_2c output
					BRANCH = 1'b0;		//not a branch signal
					JUMP = 1'b0;		//not a jump
					SEL_MUX_WRITE = 1'bx; //no write done to reg file
					READ = 1'b0;		//no read from data memory
					WRITE = 1'b1;		//write to data memory
				end
			
			//swi
			8'b00001011:
				begin
					#1 //decode delay
					WRITEENABLE = 1'b0;	//no write to register file is done
					ALUOP = 3'b000;		//forward data2 -> aluresult
					MUX_2C = 1'b0;		//get regout2
					MUX_IM = 1'b0;		//get immediate
					BRANCH = 1'b0;		//not a branch signal
					JUMP = 1'b0;		//not a jump
					SEL_MUX_WRITE = 1'bx; //no write done to reg file
					READ = 1'b0;		//no read from data memory
					WRITE = 1'b1;		//write to data memory
				end
		
		endcase
		
		end
	
	end
	
		
endmodule

