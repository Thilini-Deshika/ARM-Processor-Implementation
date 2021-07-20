//E/16/078
//cache

//include submodules
`include "comparator.v"
`include "mux_get_dataword.v"


 `timescale  1ns/100ps

module dcache (clock,reset,busywait,read,write,writedata,readdata,address,mem_busywait,mem_read,mem_write,mem_writedata,mem_readdata,mem_address);
    
    /*
    Combinational part for indexing, tag comparison for hit deciding, etc.
    ...
    ...
    */
    
	///port declaration
	
	//inputs
	input clock;
	input reset;
	input read;
	input write;
	input [7:0]writedata;
	input [7:0]address;
	input mem_busywait;
	input [31:0]mem_readdata;
	
	//outputs
	output reg busywait;
	output reg [7:0]readdata;
	output reg mem_read;
	output reg mem_write;
	output reg [31:0]mem_writedata;
	output reg [5:0]mem_address;
	
	
	//intialize cache
	reg [31:0] cache[7:0];
	
	//initalize tag array
	reg [2:0] tag_array[7:0];
	
	//intialize valid bit array
	reg [0:0] valid_array[7:0];
	
	//initalize dirty bit array
	reg [0:0] dirty_array[7:0];
	
	//get index from address
	wire [2:0]index = address[4:2];
	
	//ports inside module : from indexing
	reg [2:0]tag; 
	reg valid_bit;
	reg dirty_bit;
	reg [31:0]data_block;
	
	//ports inside module : output of tag comparison
	wire tag_check;
	
	//ports inside module : Hit status : hit=1, miss=0
	reg hit;
	
	//ports inside module : dataword : output of mux
	wire [7:0]dataword;
	
	
	//assert busywait for read and write
	always @(read, write)
	begin
		busywait = (read || write)? 1 : 0;
	end
	
		
	//indexing : get stored tag, valid bit, dirty bit, data_block
	always @ (*)
	begin
		#1	//indexing latency
		tag = tag_array[index];
		valid_bit = valid_array[index];
		dirty_bit = dirty_array[index];
		data_block = cache[index];
	end
	
	//add comparator to do tag comparison
	comparator my_comparator(tag,address[7:5],tag_check);
	
	
	//tag validation : get hit or miss
	always @ (valid_bit,tag_check)
	begin	
		//check if both valid_bit and tag_check is true 
		hit = valid_bit && tag_check;
	end
	
	
	//add mux to select data word from data block from, according the offset
	mux_get_dataword my_mux_get_dataword(data_block[7:0],data_block[15:8],data_block[23:16],data_block[31:24],address[1:0],dataword);
	

	
	//handle read hit
	//send dataword to cpu
	always @(*)
	begin
		readdata = dataword;
	end
	
	
	//handle write hit
	always @(posedge clock)
	begin
		if(hit==1'b1 && write==1'b1)
		begin
			
			//writing latency #1			
			//write writedata to corresponding word of cache data block : select word according to offset (least significant two bits of address)
			case(address[1:0])						
				2'b00:	cache[index][7:0] = #1 writedata;
				2'b01:	cache[index][15:8] = #1	writedata;
				2'b10:	cache[index][23:16] = #1 writedata;
				2'b11:	cache[index][31:24] = #1 writedata;				
			endcase		

			//update dirty bit
			dirty_array[index] = 1'b1;
						
		end
	end
	
	
	
	//deassert busywait for hits
	always @ (posedge clock)
	begin
		if(hit == 1'b1)
		begin
			busywait = 1'b0;
		end
	end
	
	
	
	
    /* Cache Controller FSM Start */

    parameter IDLE = 3'b000, MEM_READ = 3'b001, MEM_WRITE = 3'b010, CACHE_UPDATE = 3'b011;
    reg [2:0] state, next_state;

    // combinational next state logic
	
    always @(*)
    begin
        case (state)
            IDLE:
                if ((read|| write) && !dirty_bit && !hit)  
                    next_state = MEM_READ;
                else if ((read || write) && dirty_bit && !hit)
                    next_state = MEM_WRITE;
                else
                    next_state = IDLE;
            
			
            MEM_READ:
                if (!mem_busywait)
                    next_state = CACHE_UPDATE;
                else    
                    next_state = MEM_READ;
			
			
			MEM_WRITE:
				if (!mem_busywait)
                    next_state = MEM_READ;
                else    
                    next_state = MEM_WRITE;
			
			
			CACHE_UPDATE:
				next_state = IDLE;
						
        endcase
    end
	

    // combinational output logic
    always @(*)
    begin
        case(state)
            IDLE:
            begin
                mem_read = 0;
                mem_write = 0;
                mem_address = 8'dx;
                mem_writedata = 8'dx;
                busywait = 0;
            end
         
            MEM_READ: 
            begin
                mem_read = 1;
                mem_write = 0;
				mem_address = address[7:2];
                mem_writedata = 32'dx;
                busywait = 1;
            end
            
			MEM_WRITE:
			begin
				mem_read = 0;
                mem_write = 1;
                mem_address = {tag_array[index],index};
                mem_writedata = cache[index];
                busywait = 1;
				
				if(!mem_busywait)begin
					dirty_array[index] = 0;
				end
			end
			
			CACHE_UPDATE:
			begin
				mem_read = 0;
                mem_write = 0;
                mem_address = address[7:2];
                mem_writedata = 32'dx;
                busywait = 1;
				cache[index] = #1 mem_readdata;
				
				dirty_array[index] = 0;
				valid_array[index] = 1;
				tag_array[index] = address[7:5];	
				
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

    /* Cache Controller FSM End */
	
	
	
	//when reset signal is coming
	//reset cache,valid_array and dirty_array to zero
	//reset tag_array to don't care
	integer i;
	always @(posedge reset)
	begin
		if(reset==1'b1) 
		begin
			for(i=0; i<8; i=i+1)
			begin	
				valid_array[i] = 1'b0;
				dirty_array[i] = 1'b0;
				tag_array[i] = 3'bx;
				cache[i] = 32'b0;
			end			
		end
	end
	
	
	
endmodule