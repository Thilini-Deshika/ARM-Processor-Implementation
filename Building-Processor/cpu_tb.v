//testbench module for cpu
//run as: iverilog -o testcpu.vvp cpu_tb.v
//wave file of timing diagram : cpu_wavedata.vcd

`include "cpu_module.v"

module cpu_tb;

    reg CLK, RESET;
    wire [31:0] PC;
    reg [31:0] INSTRUCTION; //was wire
    
    /* 
    ------------------------
     SIMPLE INSTRUCTION MEM
    ------------------------
    */
    
    // TODO: Initialize an array of registers (8x1024) to be used as instruction memory
	reg [7:0] instr_mem[1024:0];
    
    // TODO: Create combinational logic to fetch an instruction from instruction memory, given the Program Counter(PC) value 
    //       (make sure you include the delay for instruction fetching here)
	always @(PC)
	begin
		if (PC != -4)
		begin
			#2 //Instruction Memory Read delay
			INSTRUCTION = {instr_mem[PC+ 32'd3],instr_mem[PC+32'd2],instr_mem[PC+32'd1],instr_mem[PC]};
		end
	end
    
	
    initial
    begin
        // TODO: Initialize instruction memory with a set of instructions
        //Hint: you can use something like this to load the instruction "loadi 4 0x19" onto instruction memory,
        //{instr_mem[10'd3], instr_mem[10'd2], instr_mem[10'd1], instr_mem[10'd0]} = 32'b00000000000001000000000000011001;
		
			
		{instr_mem[8'd3], instr_mem[8'd2], instr_mem[8'd1], instr_mem[8'd0]} = 32'b00000000000000010000000000000101;			//loadi 1 0x05
		{instr_mem[8'd7], instr_mem[8'd6], instr_mem[8'd5], instr_mem[8'd4]} = 32'b00000001000000100000000000000001;			//mov 2 1
		{instr_mem[8'd11], instr_mem[8'd10], instr_mem[8'd9], instr_mem[8'd8]} = 32'b00000000000000110000000000000001;			//loadi 3 0x01
		{instr_mem[8'd15], instr_mem[8'd14], instr_mem[8'd13], instr_mem[8'd12]} = 32'b00000000000001000000000000000100;		//loadi 4 0x04
		{instr_mem[8'd19], instr_mem[8'd18], instr_mem[8'd17], instr_mem[8'd16]} = 32'b00000000000001110000000000001001;		//loadi 7 0x09
		{instr_mem[8'd23], instr_mem[8'd22], instr_mem[8'd21], instr_mem[8'd20]} = 32'b00000010000001000000000100000100;		//add 4 1 4
		{instr_mem[8'd27], instr_mem[8'd26], instr_mem[8'd25], instr_mem[8'd24]} = 32'b00000111111111100000010000000111;		//beq 0xFE 4 7
		{instr_mem[8'd31], instr_mem[8'd30], instr_mem[8'd29], instr_mem[8'd28]} = 32'b00000000000001100000000010100011;		//loadi 6 0xA3
		{instr_mem[8'd35], instr_mem[8'd34], instr_mem[8'd33], instr_mem[8'd32]} = 32'b00000011000000000000010000000111;		//sub 0 4 7
		{instr_mem[8'd39], instr_mem[8'd38], instr_mem[8'd37], instr_mem[8'd36]} = 32'b00000001000000010000000000000000;		//mov 1 0
		{instr_mem[8'd43], instr_mem[8'd42], instr_mem[8'd41], instr_mem[8'd40]} = 32'b00001010000001000000000100000000;		//bne 0x04 1 0
		{instr_mem[8'd47], instr_mem[8'd46], instr_mem[8'd45], instr_mem[8'd44]} = 32'b00000010000001000000010000000010;		//add 4 4 2
		{instr_mem[8'd51], instr_mem[8'd50], instr_mem[8'd49], instr_mem[8'd48]} = 32'b00001010000001000000001000000100;		//bne 0x04 2 4
		{instr_mem[8'd55], instr_mem[8'd54], instr_mem[8'd53], instr_mem[8'd52]} = 32'b00000001000000100000000000000101;		//mov 2 5
		{instr_mem[8'd59], instr_mem[8'd58], instr_mem[8'd57], instr_mem[8'd56]} = 32'b00000000000000100000000010100011;		//loadi 2 0xA3
		{instr_mem[8'd63], instr_mem[8'd62], instr_mem[8'd61], instr_mem[8'd60]} = 32'b00000000000000110000000010110111;		//loadi 3 0xB7
		{instr_mem[8'd67], instr_mem[8'd66], instr_mem[8'd65], instr_mem[8'd64]} = 32'b00000011000001000000001100000010;		//sub 4 3 2
		{instr_mem[8'd71], instr_mem[8'd70], instr_mem[8'd69], instr_mem[8'd68]} = 32'b00000110000000010000000000000000;		//j 0x01
		{instr_mem[8'd75], instr_mem[8'd74], instr_mem[8'd73], instr_mem[8'd72]} = 32'b00000110000000010000000000000000;		//j 0x01
		{instr_mem[8'd79], instr_mem[8'd78], instr_mem[8'd77], instr_mem[8'd76]} = 32'b00000110111111100000000000000000;		//j 0xFE
		{instr_mem[8'd83], instr_mem[8'd82], instr_mem[8'd81], instr_mem[8'd80]} = 32'b00000001000001010000000000000100;		//mov 5 4
		{instr_mem[8'd87], instr_mem[8'd86], instr_mem[8'd85], instr_mem[8'd84]} = 32'b00000010000001100000001100000010;		//add 6 3 2
		{instr_mem[8'd91], instr_mem[8'd90], instr_mem[8'd89], instr_mem[8'd88]} = 32'b00000001000001110000000000000110;		//mov 7 6
		{instr_mem[8'd95], instr_mem[8'd94], instr_mem[8'd93], instr_mem[8'd92]} = 32'b00000100000000000000001100000010;		//and 0 3 2
		{instr_mem[8'd99], instr_mem[8'd98], instr_mem[8'd97], instr_mem[8'd96]} = 32'b00000001000001000000000000000000;		//mov 4 0
		{instr_mem[8'd103], instr_mem[8'd102], instr_mem[8'd101], instr_mem[8'd100]} = 32'b00000101000000010000001100000010;	//or 1 3 2
		{instr_mem[8'd107], instr_mem[8'd106], instr_mem[8'd105], instr_mem[8'd104]} = 32'b00000001000001010000000000000001;	//mov 5 1
		{instr_mem[8'd111], instr_mem[8'd110], instr_mem[8'd109], instr_mem[8'd108]} = 32'b00000011000000100000000100000101;	//sub 2 1 5
		{instr_mem[8'd115], instr_mem[8'd114], instr_mem[8'd113], instr_mem[8'd112]} = 32'b00000100000000110000000100000010;	//and 3 1 2
		{instr_mem[8'd119], instr_mem[8'd118], instr_mem[8'd117], instr_mem[8'd116]} = 32'b00000001000001110000000000000011;	//mov 7 3
		
		{instr_mem[8'd123], instr_mem[8'd122], instr_mem[8'd121], instr_mem[8'd120]} = 32'b00000000000000010000000000000110;	//loadi 1 0x06
		{instr_mem[8'd127], instr_mem[8'd126], instr_mem[8'd125], instr_mem[8'd124]} = 32'b00001011000000100000000100000011;	//sll 2 1 0x03
		{instr_mem[8'd131], instr_mem[8'd130], instr_mem[8'd129], instr_mem[8'd128]} = 32'b00000001000000110000000000000010;	//mov 3 2
		{instr_mem[8'd135], instr_mem[8'd134], instr_mem[8'd133], instr_mem[8'd132]} = 32'b00000000000001000000000010100010;	//loadi 4 0xA2
		{instr_mem[8'd139], instr_mem[8'd138], instr_mem[8'd137], instr_mem[8'd136]} = 32'b00001100000000100000010000000100;	//srl 2 4 0x04
		{instr_mem[8'd143], instr_mem[8'd142], instr_mem[8'd141], instr_mem[8'd140]} = 32'b00000001000001010000000000000010;	//mov 5 2
		{instr_mem[8'd147], instr_mem[8'd146], instr_mem[8'd145], instr_mem[8'd144]} = 32'b00000000000001100000000010100101;	//loadi 6 0xA5
		{instr_mem[8'd151], instr_mem[8'd150], instr_mem[8'd149], instr_mem[8'd148]} = 32'b00001101000000100000011000000101;	//sra 2 6 0x05
		{instr_mem[8'd155], instr_mem[8'd154], instr_mem[8'd153], instr_mem[8'd152]} = 32'b00000001000001110000000000000010;	//mov 7 2
		
    end
    
    /* 
    -----
     CPU
    -----
    */
    cpu mycpu(PC, INSTRUCTION, CLK, RESET);

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
		
		#2
		RESET = 1'b0;
		
		
		//second reset 
		#48
		RESET = 1'b1;
		
		#1
		RESET = 1'b0;
		
		
		
		//3rd reset : to check functionality when reset at positive edge of clock
		#53
		RESET = 1'b1;
		
		#20
		RESET = 1'b0;
		
        // finish simulation after some time
        #500
        $finish;
        
    end
    
    // clock signal generation
    always
        #5 CLK = ~CLK;
        

endmodule