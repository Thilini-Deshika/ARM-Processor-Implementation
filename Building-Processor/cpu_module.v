//E/16/078
//CPU : top module

//include sub modules
`include "control_unit.v"
`include "reg_file.v"
`include "mux_2scomplement.v"
`include "mux_immediate.v"
`include "alu_module.v"
`include "program_counter.v"
`include "and_gate.v"
`include "sign_extend_shift_left2.v"
`include "adder1.v"
`include "adder2.v"
`include "mux_pc.v"
`include "or_gate.v"
`include "shifter.v"
`include "shift_bit.v"
`include "mux_reg.v"

//cpu module : main module
module cpu(PC, INSTRUCTION, CLK, RESET);

	//port declaration
	
	//inputs
	input [31:0]INSTRUCTION;
	input CLK;
	input RESET;
	
	//output
	output [31:0]PC;
	
	//parameters inside block
	//for cotrol unit
	wire [2:0]READREG2;
	wire [2:0]READREG1;
	wire [2:0]WRITEREG;
	wire WRITEENABLE;
	wire [2:0]ALUOP;
	wire [7:0]IMMEDIATE;
	wire MUX_2C;
	wire MUX_IM;
	wire BRANCH;
	wire JUMP;
	wire BNOT;
	wire SHIFT;
	wire SHIFT_ARITH;
	wire DIRECTION;
	
	//parameters inside block
	//for reg file
	wire [7:0]WRITE_DATA;
	wire [7:0]REGOUT2;
	wire [7:0]REGOUT1;
	
	//parameters inside block
	//for mux_2scomplement output
	wire [7:0]OUT_MUX_2C;
	
	//parameters inside block
	//for mux_immediate output
	wire [7:0]OUT_MUX_IM;
	
	//parameters inside block
	//for alu module
	wire ZERO;
	wire [7:0]ALURESULT;
	
	//parameters inside block
	//for output of and_gate connected to BRANCH and ZERO
	wire OUT_AND_GATE;
	
	//parameters inside block
	//for sign extension and shift left 2 of immediate
	wire [31:0]OUT_SIGN_EXTEND_SHIFT_LEFT2;
	
	//parameters inside block
	//for adder1 : adder to get next instruction address (PC+4), PC value if current instruction is not branch
	wire [31:0]NEXT_INS;
	
	//parameters inside block
	//for adder2 : addition of next instruction pc value and offset
	wire [31:0]PC_WITH_OFFSET;
	
	//parameters inside block
	//for mux_pc : to select whether next instruction to execute is whether PC or PC+offset
	//output of mux ----> input of program_counter
	wire [31:0]PC_INPUT;
	
	
	//parameters inside block
	//for or_gate : to check if jump or branch with ZERO is high
	wire OUT_OR_GATE;
	
	//parameters inside block
	//for output of and_gate connected to BNOT and ZERO
	wire OUT_AND_GATE_2;
	
	//parameters inside block
	//for shift_bit module to get the shift bit
	wire SHIFT_BIT;
	
	//parameters inside block
	//for shifter
	wire [7:0]SHIFTED_VALUE;
	
	//add control unit module to decode
	control_unit my_control_unit(INSTRUCTION,READREG2,READREG1,WRITEREG,WRITEENABLE,ALUOP,IMMEDIATE,MUX_2C,MUX_IM,RESET,BRANCH,JUMP,BNOT,SHIFT,SHIFT_ARITH,DIRECTION);
	

	//add register file to do reading and writing
	reg_file my_reg_file(WRITE_DATA,REGOUT1,REGOUT2,WRITEREG,READREG1,READREG2,WRITEENABLE,CLK,RESET);
	
	
	//add mux 2scomplement to check whether REGOUT2 or its 2scomplement
	mux_2scomplement my_mux_2scomp(REGOUT2,MUX_2C,OUT_MUX_2C);
	
	
	//add mux immediate to check whether output of mux 2scomplement or immediate
	mux_immediate my_mux_imm(IMMEDIATE,OUT_MUX_2C, MUX_IM, OUT_MUX_IM);
	
	//add ALU to do relavant ALU operation
	alu my_alu(REGOUT1,OUT_MUX_IM,ALURESULT,ALUOP,ZERO);
	
	//add program counter to increment and then update at posititve edge clk
	program_counter my_pc(PC, RESET, CLK, PC_INPUT);
	
	//add and gate to get check if both ZERO signal and BRANCH signal set to high
	and_gate my_and_gate(BRANCH,ZERO,OUT_AND_GATE);
	
	//add sign_extend_shift_left2 module to do sign extension and shift left 2(multiply by 4), of the immediate operand(offset)
	sign_extend_shift_left2 my_sign_extend_shift_left2(INSTRUCTION[23:16],OUT_SIGN_EXTEND_SHIFT_LEFT2);
	
	//add adder1 to increment PC by 4
	adder1 my_adder1 (PC,NEXT_INS);
	
	//add adder2 to get the addition of next instruction pc value and offset
	adder2 my_adder2 (NEXT_INS,OUT_SIGN_EXTEND_SHIFT_LEFT2,PC_WITH_OFFSET);
	
	//add mux_pc to select whether next instruction to execute is whether PC or PC+offset
	mux_pc my_mux_pc (NEXT_INS,PC_WITH_OFFSET,OUT_OR_GATE,PC_INPUT);
	
	//add or_gate to check if jump or branch with ZERO is high
	or_gate my_or_gate (JUMP,OUT_AND_GATE,OUT_AND_GATE_2,OUT_OR_GATE);
	
	//add and gate to check if ZERO signal is not high when BNOT signal set to high
	and_gate my_and_gate_2 (BNOT,~ZERO,OUT_AND_GATE_2);
	
	//add module to get the shift bit
	shift_bit my_shift_bit(REGOUT1,SHIFT_ARITH,SHIFT_BIT);
	
	//add shifter to do shift operations
	shifter my_shifter(REGOUT1,IMMEDIATE,SHIFT_BIT,DIRECTION,SHIFTED_VALUE);
	
	//add mux to select the write data of register file : shifter output / alu result
	mux_reg my_mux_reg(ALURESULT,SHIFTED_VALUE,SHIFT,WRITE_DATA);
	
		
endmodule