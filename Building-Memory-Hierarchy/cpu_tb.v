//testbench module for cpu
//run as: iverilog -o testcpu.vvp cpu_tb.v
//wave file of timing diagram : cpu_wavedata.vcd

`include "cpu_module.v"
`include "dmem_for_dcache.v"
`include "dcache.v"
`include "icache.v"
`include "imem_for_icache.v"

`timescale  1ns/100ps

module cpu_tb;

    reg CLK, RESET;
    wire [31:0] PC;
    wire [31:0] INSTRUCTION; //was wire
	
	//ports to connect cpu and cache
	wire READ;
	wire WRITE;
	wire [7:0]WRITEDATA;
	wire [7:0]READDATA;
	wire [7:0]ADDRESS;
	
	//ports to connect cache and data_memory 
	wire MEM_BUSYWAIT;
	wire MEM_READ;
	wire MEM_WRITE;
	wire [31:0]MEM_WRITEDATA;
	wire [31:0]MEM_READDATA;
	wire [5:0]MEM_ADDRESS;
	
	
    	
	//ports to connect icache and instruction_memory
	wire IMEM_READ;
	wire [5:0]IMEM_ADDRESS;
	wire [127:0]IMEM_READDATA;
	wire IMEM_BUSYWAIT;
	
	//ports connect with or gate which outputs busywait to cpu
	wire INS_BUSYWAIT;		//busywait comes from instruction cache
	wire DATA_BUSYWAIT;		//busywait comes from data cache
	wire BUSYWAIT;			//busywait goes to cpu : output of or gate
	
	//get busywait : INS_BUSYWAIT || DATA_BUSYWAIT
	//output send to cpu as the busywait signal
	or get_busywait(BUSYWAIT,INS_BUSYWAIT,DATA_BUSYWAIT);
	
	
	icache my_icache(CLK,RESET,PC,INSTRUCTION,INS_BUSYWAIT,IMEM_READ,IMEM_ADDRESS,IMEM_READDATA,IMEM_BUSYWAIT);
	ins_data_memory my_ins_data_memory(CLK,IMEM_READ,IMEM_ADDRESS,IMEM_READDATA,IMEM_BUSYWAIT);
	dcache my_dcache(CLK,RESET,DATA_BUSYWAIT,READ,WRITE,WRITEDATA,READDATA,ADDRESS,MEM_BUSYWAIT,MEM_READ,MEM_WRITE,MEM_WRITEDATA,MEM_READDATA,MEM_ADDRESS);
	data_memory my_dmem(CLK,RESET,MEM_READ,MEM_WRITE,MEM_ADDRESS,MEM_WRITEDATA,MEM_READDATA,MEM_BUSYWAIT);
    cpu mycpu(PC, INSTRUCTION, CLK, RESET,READ,WRITE,BUSYWAIT,READDATA,WRITEDATA,ADDRESS);

    initial
    begin
    
        // generate files needed to plot the waveform using GTKWave
        $dumpfile("cpu_wavedata.vcd");
		$dumpvars(0, cpu_tb);

       	
        CLK = 1'b0;
        RESET = 1'b0;
        
        // TODO: Reset the CPU (by giving a pulse to RESET signal) to start the program execution
		
		//first reset signal to start program
		
		#1
		RESET = 1'b1;
		
		#5
		RESET = 1'b0;
		
		
		//second reset 
		#3000
		RESET = 1'b1;
		
		#1
		RESET = 1'b0;
		
				
        // finish simulation after some time
        #10000
        $finish;
        
    end
    
    // clock signal generation
	//clk period = #8
    always
        #4 CLK = ~CLK;
        

endmodule