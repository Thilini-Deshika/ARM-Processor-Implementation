//E/16/078
//control unit module
module control_unit(INSTRUCTION,READREG2,READREG1,WRITEREG,WRITEENABLE,ALUOP,IMMEDIATE,MUX_2C,MUX_IM,RESET,BRANCH,JUMP,BNOT,SHIFT,SHIFT_ARITH,DIRECTION);

	//port declaration
	
	//inputs
	input [31:0]INSTRUCTION;
	input RESET;
	
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
	output BNOT;		//enable if bne (branch not equal) is done
	output SHIFT; 		//enable if shift operation is done
	output SHIFT_ARITH; //to check arithematic or logical shift : arithematic=1, logical=0
	output DIRECTION; 	//for shifting direction : right=1, left=0
	
	
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
	reg BNOT;	//set high if bne
	reg SHIFT;
	reg SHIFT_ARITH;
	reg DIRECTION;

	//declare decoding parameters
	reg [7:0] OP_CODE,DESTINATION,SOURCE_1,SOURCE_2;
	
	
	//control writeenable
	always @(RESET)
	begin
		if(RESET == 1'b1)
		begin
			WRITEENABLE = 1'b0;
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
					BNOT = 1'b0;		//not branch not equal
					SHIFT = 1'b0;		//not a shift operation
					SHIFT_ARITH = 1'bx;	//no shift
					DIRECTION = 1'bx;	//no shift direction needed
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
					BNOT = 1'b0;		//not branch not equal
					SHIFT = 1'b0;		//not a shift operation
					SHIFT_ARITH = 1'bx;	//no shift
					DIRECTION = 1'bx;	//no shift direction needed
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
					BNOT = 1'b0;		//not branch not equal
					SHIFT = 1'b0;		//not a shift operation
					SHIFT_ARITH = 1'bx;	//no shift
					DIRECTION = 1'bx;	//no shift direction needed
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
					BNOT = 1'b0;		//not branch not equal
					SHIFT = 1'b0;		//not a shift operation
					SHIFT_ARITH = 1'bx;	//no shift
					DIRECTION = 1'bx;	//no shift direction needed
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
					BNOT = 1'b0;		//not branch not equal
					SHIFT = 1'b0;		//not a shift operation
					SHIFT_ARITH = 1'bx;	//no shift
					DIRECTION = 1'bx;	//no shift direction needed
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
					BNOT = 1'b0;		//not branch not equal
					SHIFT = 1'b0;		//not a shift operation
					SHIFT_ARITH = 1'bx;	//no shift
					DIRECTION = 1'bx;	//no shift direction needed
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
					BNOT = 1'b0;		//not branch not equal
					SHIFT = 1'b0;		//not a shift operation
					SHIFT_ARITH = 1'bx;	//no shift
					DIRECTION = 1'bx;	//no shift direction needed
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
					BNOT = 1'b0;		//not branch not equal
					SHIFT = 1'b0;		//not a shift operation
					SHIFT_ARITH = 1'bx;	//no shift
					DIRECTION = 1'bx;	//no shift direction needed
				end
			
			//bne
			8'b00001010:
				begin
					#1 //decode delay
					WRITEENABLE = 1'b0;
					ALUOP = 3'b001;		//alu operation is done
					MUX_2C = 1'b1;		//get 2s complement
					MUX_IM = 1'b1;		//get mux_2c output
					BRANCH = 1'b0;		//not a branch signal
					JUMP = 1'b0;		//not a jump
					BNOT = 1'b1;		//a branch not equal signal
					SHIFT = 1'b0;		//not a shift operation
					SHIFT_ARITH = 1'bx;	//no shift
					DIRECTION = 1'bx;	//no shift direction needed
				end
				
			//sll
			8'b00001011:
				begin
					#1 //decode delay
					WRITEENABLE = 1'b1;
					ALUOP = 3'bxxx;		//no alu operation is done
					MUX_2C = 1'bx;		//mux_2c not needed
					MUX_IM = 1'bx;		//mux_im not needed
					BRANCH = 1'b0;		//not a branch signal
					JUMP = 1'b0;		//not a jump
					BNOT = 1'b0;		//not branch not equal signal
					SHIFT = 1'b1;		//a shift operation
					SHIFT_ARITH = 1'b0;	//logical shift
					DIRECTION = 1'b0;	//shift direction = left =0
				end
			
			//srl
			8'b00001100:
				begin
					#1 //decode delay
					WRITEENABLE = 1'b1;
					ALUOP = 3'bxxx;		//no alu operation is done
					MUX_2C = 1'bx;		//mux_2c not needed
					MUX_IM = 1'bx;		//mux_im not needed
					BRANCH = 1'b0;		//not a branch signal
					JUMP = 1'b0;		//not a jump
					BNOT = 1'b0;		//not branch not equal signal
					SHIFT = 1'b1;		//a shift operation
					SHIFT_ARITH = 1'b0;	//logical shift
					DIRECTION = 1'b1;	//shift direction = right = 1
				end
		
			//sra
			8'b00001101:
				begin
					#1 //decode delay
					WRITEENABLE = 1'b1;
					ALUOP = 3'bxxx;		//no alu operation is done
					MUX_2C = 1'bx;		//mux_2c not needed
					MUX_IM = 1'bx;		//mux_im not needed
					BRANCH = 1'b0;		//not a branch signal
					JUMP = 1'b0;		//not a jump
					BNOT = 1'b0;		//not branch not equal signal
					SHIFT = 1'b1;		//a shift operation
					SHIFT_ARITH = 1'b1;	//arithematic shift
					DIRECTION = 1'b1;	//shift direction = right = 1
				end
		
		endcase
		
		end
	
	end
	
		
endmodule

