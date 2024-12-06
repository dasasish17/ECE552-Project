module cache_controller (
	// Inputs
	dirty, index, valid_in, tag_in, clk, Wr, hit, stall, tag_out, Rd, offset_in, rst,

     // Outputs
	done, stall_out, cache_hit, err,
	stall_out, write_cache, read_mem, addr, offset_out, err, write_mem, enable, cache_hit, valid_out, done, comp
	);
	
	input dirty;
    input [7:0] index;
    input valid_in;
    input [4:0] tag_in;
    input clk;
    input Wr;
    input hit;
    input stall;
    input [4:0] tag_out;
    input Rd;
    input [2:0] offset_in;
    input rst;

	
    output reg stall_out;
    output reg write_cache;
    output reg read_mem;
    output reg [15:0] addr;
    output reg [2:0] offset_out;
    output reg err;
    output reg write_mem;
    output reg enable;
    output reg cache_hit;
    output reg valid_out;
    output reg done;
    output reg comp;
    // 2 states
	localparam IDLE = 4'b0000;
	localparam WB0 = 4'b0001;
	localparam WB1 = 4'b0010;
	localparam WB2 = 4'b0011;
	localparam WB3 = 4'b0100;
	localparam ALLOC0 = 4'b0101;
	localparam ALLOC1 = 4'b0110;
	localparam ALLOC2 = 4'b0111;
	localparam ALLOC3 = 4'b1000;
	localparam ALLOC4 = 4'b1001;
	localparam ALLOC5 = 4'b1010;
	localparam CACHE_HANDLER= 4'b1011;
	localparam FINAL = 4'b1100;
	
	// flip flop
	wire [3:0] curr_state;
	reg [3:0] nxt_state;
	dff state_reg [3:0](
		.q(curr_state),
		.d(nxt_state),
		.clk(clk),
		.rst(rst)
	);
	
	// Finite state machine
	always @(*) begin
		nxt_state = curr_state;
        stall_out = 1'b1;
        write_cache = 1'b0;
        read_mem = 1'b0;
        addr = 16'h0000;
        offset_out = 3'b000;
        err = 1'b0;
        write_mem = 1'b0;
        enable = 1'b1;
        cache_hit = 1'b0;
        valid_out = 1'b0;
        done = 1'b0;
        comp = 1'b0;

		case(curr_state)
			IDLE: begin
				// nxt_state = (Rd | Wr) ? ((hit & valid_in) ? IDLE : (~hit & valid_in & dirty) ? WB0 : ALLOC0) : IDLE;
                //nxt_state = (Rd | Wr) && ~hit && valid_in ? (dirty ? WB0 : ALLOC0): IDLE;
                nxt_state = (Rd | Wr) ? (valid_in ? (hit ? IDLE : (dirty ? WB0 : ALLOC0)) : ALLOC0) : IDLE;

				comp = Rd | Wr;
				offset_out = offset_in;
				write_cache = Wr;
				done = (Rd | Wr) & (hit & valid_in);
				cache_hit = hit & valid_in;
				stall_out = 1'b0;
			end
			
			WB0: begin
				nxt_state = stall ? WB0 : WB1;
				write_mem = 1'b1;
				addr = {tag_out, index, 3'b000};
				offset_out = 3'b000;
			end
			
			WB1: begin
				nxt_state = stall ? WB1 : WB2;
				write_mem = 1'b1;
				addr = {tag_out, index, 3'b010};
				offset_out = 3'b010;
			end
			
			WB2: begin
				nxt_state = stall ? WB2 : WB3;
				write_mem = 1'b1;
				addr = {tag_out, index, 3'b100};
				offset_out = 3'b100;
			end
			
			WB3: begin
				nxt_state = stall ? WB3 : ALLOC0;
				write_mem = 1'b1;
				addr = {tag_out, index, 3'b110};
				offset_out = 3'b110;
			end
			
			ALLOC0: begin
				nxt_state = stall ? ALLOC0 : ALLOC1;
				read_mem = 1'b1;
				addr = {tag_in, index, 3'b000};
			end
			
			ALLOC1: begin
				nxt_state = stall ? ALLOC1 : ALLOC2;
				read_mem = 1'b1;
				addr = {tag_in, index, 3'b010};
			end
			
			ALLOC2: begin
				nxt_state = stall ? ALLOC2 : ALLOC3;
				write_cache = 1'b1;
				read_mem = 1'b1;
				addr ={tag_in, index, 3'b100};
				offset_out = 3'b000;
			end
			
			ALLOC3: begin
				nxt_state = stall ? ALLOC3 : ALLOC4;
				write_cache = 1'b1;
				read_mem = 1'b1;
				addr = {tag_in, index, 3'b110};
				offset_out = 3'b010;
			end
			
			ALLOC4: begin
				nxt_state = ALLOC5;
				write_cache = 1'b1;
				offset_out = 3'b100;
			end
			
			ALLOC5: begin
				nxt_state = CACHE_HANDLER;
				write_cache = 1'b1;
				valid_out = 1'b1;
				offset_out = 3'b110;
			end

			CACHE_HANDLER: begin
				nxt_state = FINAL;
				comp = 1'b1;
				write_cache = Wr;
				offset_out = offset_in;
			end
			
			FINAL: begin
				nxt_state = IDLE;
				done = 1'b1;
				offset_out = offset_in;
			end
			
			default: begin
				err = 1'b1;
			end
		endcase
	end

endmodule