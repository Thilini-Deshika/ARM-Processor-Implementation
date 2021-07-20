//E/16/078
//instruction cache module

//`include "comparator.v"
`include "mux_get_ins_word.v"
`include "comparator_tag_check.v"

`timescale  1ns/100ps
 

module icache (clock,reset,address_pc,instruction,busywait,imem_read,imem_address,imem_readdata,imem_busywait);

	//port declaration
	
	//inputs
	input clock;
	input reset;
	input [31:0]address_pc;
	input [127:0]imem_readdata;
	input imem_busywait;
	
	
	//outputs
	output reg [31:0]instruction;
	output reg busywait;
	output reg imem_read;
	output reg [5:0]imem_address;
	
	
	//intialize cache
	reg [127:0] icache_array[7:0];
	
	//initalize tag array
	reg [2:0] itag_array[7:0];
	
	//intialize valid bit array
	reg [0:0] ivalid_array[7:0];
	
	
	//get index from address
	wire [2:0]index = address_pc[6:4];
	
	//ports inside module : from indexing
	reg [2:0]itag; 
	reg ivalid_bit;
	reg [127:0]ins_block;
	
	//ports inside module : output of tag comparison
	wire itag_check;
	
	//ports inside module : Hit status : hit=1, miss=0
	reg ihit;
	
	//ports inside module : dataword : output of mux
	wire [31:0]ins_word;
	
	//ports inside module : read
	reg read;
	
	//enable read if pc != -4
	always @(address_pc)
	begin
		if(address_pc != -4)
		begin
			read = 1'b1;
		end	
	end
	
	
		
	//indexing : get stored tag, valid bit, dirty bit, data_block
	always @ (*)
	begin
		#1	//indexing latency
		itag = itag_array[index];
		ivalid_bit = ivalid_array[index];
		ins_block = icache_array[index];
	end
	

	//add comparator to do tag comparison
	comparator_tag_check my_comparator_itag_check(itag,address_pc[9:7],itag_check);
	
	
	//tag validation : get hit or miss
	always @ (ivalid_bit,itag_check)
	begin	
		//check if both valid_bit and tag_check is true 
		ihit = ivalid_bit && itag_check;
	end

	
	//add mux to select data word from data block from, according the offset
	mux_get_ins_word my_mux_get_ins_word(ins_block[31:0],ins_block[63:32],ins_block[95:64],ins_block[127:96],address_pc[3:2],ins_word);
	
	
	//handle read hit
	//send instruction word to cpu
	always @(*)
	begin
		instruction = ins_word;
	end
	
	
	
	/* instruction cache Controller FSM Start */

    parameter IDLE = 3'b000, IMEM_READ = 3'b001, ICACHE_UPDATE = 3'b010;
    reg [2:0] state, next_state;
	
	
	// combinational next state logic	
    always @(*)
    begin
        case (state)
            IDLE:
                if (!ihit && read)  
                    next_state = IMEM_READ;
                else
                    next_state = IDLE;
            
			
            IMEM_READ:
                if (!imem_busywait)
                    next_state = ICACHE_UPDATE;
                else    
                    next_state = IMEM_READ;
			
		
			ICACHE_UPDATE:
				next_state = IDLE;
						
        endcase
    end
	
	
	// combinational output logic
    always @(*)
    begin
        case(state)
            IDLE:
            begin
                imem_read = 0;
                imem_address = 6'dx;
                busywait = 0;
            end
         
            IMEM_READ: 
            begin
                imem_read = 1;
				imem_address = address_pc[9:4];
                busywait = 1;
            end
            
						
			ICACHE_UPDATE:
			begin
				imem_read = 0;
                imem_address = address_pc[9:4];
                busywait = 1;
				icache_array[index] = #1 imem_readdata;
				ivalid_array[index] = 1;
				itag_array[index] = address_pc[9:7];	
				
			end
			
        endcase
    end


	// sequential logic for state transitioning 
    always @(posedge clock, reset)
    begin
        if(reset)
            state = IDLE;
        else
            state = next_state;
    end

    /* Instruction Cache Controller FSM End */

	
	//when reset signal is coming
	//reset cache,valid_array to zero
	//reset tag_array to don't care
	//deassert read & busywait
	integer i;
	always @(posedge reset)
	begin
		if(reset==1'b1) 
		begin
			for(i=0; i<8; i=i+1)
			begin	
				ivalid_array[i] = 1'b0;
				itag_array[i] = 3'bx;
				icache_array[i] = 128'b0;
				busywait = 1'b0;
				read = 1'b0;
			end			
		end
	end


endmodule