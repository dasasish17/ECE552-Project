/* $Author: karu $ */
/* $LastChangedDate: 2009-04-24 09:28:13 -0500 (Fri, 24 Apr 2009) $ */
/* $Rev: 77 $ */

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
   
   output wire [15:0] DataOut; //changed from reg to wire
   output wire        Done;
   output wire        Stall;
   output wire        CacheHit;
   output wire        err;

   wire [4:0] tag;
   wire [7:0] index;
   wire [2:0] offset, offset_in;

   wire mem_stall, comp, write, hit1, hit2, enable1, enable2, mem_rd, mem_wr, valid1, valid2, valid_in, dirty1, dirty2, err_mem, err_cache1, err_cache2, err_controller;
   wire [15:0] data_from_cache1, data_from_cache2, data_in, data_from_mem, data_to_mem, mem_addr;
   wire [4:0] tag_out1, tag_out2, tag_in;
   wire [3:0] busy;

   assign tag = Addr[15:11];
   assign index = Addr[10:3];
   assign offset = Addr[2:0]; 
   assign err = err_mem | err_cache1 | err_cache2 | err_controller | ((Rd | Wr) & offset[0]);

   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter memtype = 0;
   cache #(0 + memtype) c0(// Outputs
                          .tag_out              (tag_out1),
                          .data_out             (data_from_cache1),
                          .hit                  (hit1),
                          .dirty                (dirty1),
                          .valid                (valid1),
                          .err                  (err_cache1),
                          // Inputs
                          .enable               (enable1),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (tag_in),
                          .index                (index),
                          .offset               (offset_in),
                          .data_in              (data_in),
                          .comp                 (comp),
                          .write                (write),
                          .valid_in             (valid_in));
   cache #(2 + memtype) c1(// Outputs
                          .tag_out              (tag_out2),
                          .data_out             (data_from_cache2),
                          .hit                  (hit2),
                          .dirty                (dirty2),
                          .valid                (valid2),
                          .err                  (err_cache2),
                          // Inputs
                          .enable               (enable2),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (tag_in),
                          .index                (index),
                          .offset               (offset_in),
                          .data_in              (data_in),
                          .comp                 (comp),
                          .write                (write),
                          .valid_in             (valid_in));

   four_bank_mem mem(// Outputs
                     .data_out          (data_from_mem),
                     .stall             (mem_stall),
                     .busy              (busy),
                     .err               (err_mem),
                     // Inputs
                     .clk               (clk),
                     .rst               (rst),
                     .createdump        (createdump),
                     .addr              (mem_addr),
                     .data_in           (data_to_mem),
                     .wr                (mem_wr),
                     .rd                (mem_rd));
   
   // your code here
   mem_control controller(
                     // Inputs
                     .Rd(Rd),
                     .Wr(Wr),
                     .address(Addr),
                     .hit1(hit1),
                     .hit2(hit2),
                     .dirty1(dirty1),
                     .dirty2(dirty2),
                     .valid1(valid1),
                     .valid2(valid2),
                     .cache_data_out1(data_from_cache1),
                     .cache_data_out2(data_from_cache2),
                     .tag_out1(tag_out1),
                     .tag_out2(tag_out2),
                     .data_in_mem(data_from_mem),
                     .proc_data_in(DataIn),
                     .clk(clk),
                     .rst(rst),
                     // Outputs
                     .enable1(enable1),
                     .enable2(enable2),
                     .comp(comp),
                     .write(write),
                     .tag_in(tag_in),
                     .cache_data_in(data_in),
                     .valid_in(valid_in),
                     .offset_in(offset_in),
                     .Done(Done),
                     .mem_addr(mem_addr),
                     .mem_data(data_to_mem),
                     .mem_wr(mem_wr),
                     .mem_rd(mem_rd),
                     .proc_data_out(DataOut),
                     .proc_stall(Stall),
                     .CacheHit(CacheHit),
                     .Error(err_controller)
                     );
   
endmodule // mem_system
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :9: