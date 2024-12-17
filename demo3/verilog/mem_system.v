`default_nettype none
module mem_system(/*AUTOARG*/
   // Outputs
   DataOut, Done, Stall, CacheHit, err,
   // Inputs
   Addr, DataIn, Rd, Wr, createdump, clk, rst
   );

   input wire [15:0] Addr;
   input wire [15:0] DataIn;
   input wire        Rd;
   input wire        Wr;
   input wire        createdump;
   input wire        clk;
   input wire        rst;

   output wire [15:0] DataOut;
   output wire        Done;
   output wire        Stall;
   output wire        CacheHit;
   output wire        err;

   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter memtype = 0;

   // Cache signals
   wire [4:0] tag_out_way0, tag_out_way1;
   wire [15:0] c_data_out_way0, c_data_out_way1;
   wire hit_way0, hit_way1, dirty_way0, dirty_way1, valid_way0, valid_way1;
   wire enable;
   wire [15:0] m_data_out;
   wire comp, write, valid_in;
   wire stall;
   wire [15:0] m_addr;
   wire wr, rd;
   wire [2:0] offset;
   wire [15:0] c_data_in;
   wire err_c0, err_c1, err_mem, err_fsm;

   // Victimway flip-flop
   wire victimway;
   wire victimway_d;
   wire victimway_q;

   // Compute next state
   assign victimway_d = Done ? ~victimway_q : victimway_q;

   // Instantiate the DFF
   dff victimway_ff (
      .q(victimway_q),
      .d(victimway_d),
      .clk(clk),
      .rst(rst)
   );

   // Use victimway_q where you previously used victimway
   assign victimway = victimway_q;

   // Compute hit signals
   wire hit;
   assign hit = hit_way0 | hit_way1;

   // Compute victim selection logic
   wire victim;
   assign victim = (~valid_way0) ? 1'b0 : ((~valid_way1) ? 1'b1 : ~victimway);

   // Compute activeway based on hits and victim selection
   wire activeway;
   assign activeway = hit_way1 ? 1'b1 : (hit_way0 ? 1'b0 : victim);

   // Cache way 0
   wire c0_write;
   assign c0_write = (activeway == 1'b0) ? write : 1'b0;
   cache #(0 + memtype) cache_way0(
      .tag_out        (tag_out_way0),
      .data_out       (c_data_out_way0),
      .hit            (hit_way0),
      .dirty          (dirty_way0),
      .valid          (valid_way0),
      .err            (err_c0),
      .enable         (enable),
      .clk            (clk),
      .rst            (rst),
      .createdump     (createdump),
      .tag_in         (Addr[15:11]),
      .index          (Addr[10:3]),
      .offset         (offset),
      .data_in        (c_data_in),
      .comp           (comp),
      .write          (c0_write),
      .valid_in       (valid_in)
   );

   // Cache way 1
   wire c1_write;
   assign c1_write = (activeway == 1'b1) ? write : 1'b0;
   cache #(1 + memtype) cache_way1(
      .tag_out        (tag_out_way1),
      .data_out       (c_data_out_way1),
      .hit            (hit_way1),
      .dirty          (dirty_way1),
      .valid          (valid_way1),
      .err            (err_c1),
      .enable         (enable),
      .clk            (clk),
      .rst            (rst),
      .createdump     (createdump),
      .tag_in         (Addr[15:11]),
      .index          (Addr[10:3]),
      .offset         (offset),
      .data_in        (c_data_in),
      .comp           (comp),
      .write          (c1_write),
      .valid_in       (valid_in)
   );

   // Select data output based on activeway
   wire [15:0] c_data_out;
   assign c_data_out = activeway ? c_data_out_way1 : c_data_out_way0;
   assign DataOut = c_data_out;

   // Cache input data logic
   assign c_data_in = (write & ~comp) ? m_data_out : DataIn;

   // Memory module
   four_bank_mem mem(
      .data_out       (m_data_out),
      .stall          (stall),
      .busy           (), // Not used
      .err            (err_mem),
      .clk            (clk),
      .rst            (rst),
      .createdump     (createdump),
      .addr           (m_addr),
      .data_in        (victim ? c_data_out_way1 : c_data_out_way0), // Write-back data based on victim
      .wr             (wr),
      .rd             (rd)
   );

   // Cache controller
   cache_controller cache_controller(
      .done(Done),
      .stall_out(Stall),
      .cache_hit(CacheHit),
      .err(err_fsm),
      .enable(enable),
      .offset_out(offset),
      .comp(comp),
      .write_cache(write),
      .valid_out(valid_in),
      .addr(m_addr),
      .write_mem(wr),
      .read_mem(rd),
      .Rd(Rd),
      .Wr(Wr),
      .tag_in(Addr[15:11]),
      .index(Addr[10:3]),
      .offset_in(Addr[2:0]),
      .clk(clk),
      .rst(rst),
      .hit(hit), // Use the computed hit
      .dirty(activeway ? dirty_way1 : dirty_way0), // Dirty bit based on activeway
      .valid_in(activeway ? valid_way1 : valid_way0), // Valid bit based on activeway
      .tag_out(activeway ? tag_out_way1 : tag_out_way0), // Tag based on activeway
      .stall(stall)
   );

   // Error handling
   assign err = err_c0 | err_c1 | err_mem | err_fsm | ((Rd | Wr) & Addr[0]);

endmodule // mem_system
`default_nettype wire
