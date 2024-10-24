/*
   CS/ECE 552 Spring '22
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
`default_nettype none
module fetch (halt, clk, rst, PC_current, instruction, PC_updated);

   // TODO: Your code here
   input wire halt, clk, rst;
   input wire [15:0] PC_current;
   output wire [15:0] instruction;
   output wire [15:0] PC_updated;
   wire [15:0] PC_intermediary;
   wire c_out;

   // use the register to set when we are changing the PC
   // module register(out, in, wr_en, clk, rst);
   // if not halt, we want to update the PC
   register reg0 (.out(PC_intermediary), .in(PC_current), .wr_en(~halt), .clk(clk), .rst(rst));

   // implement the instrcution memeory 
   //module memory2c (data_out, data_in, addr, enable, wr, createdump, clk, rst);
   memory2c mem0 (.data_out(instruction), .data_in(16'b0), .addr(PC_intermediary), .enable(1'b1), .wr(1'b0), .createdump(halt), .clk(clk), .rst(rst));

   // increment PC by 2
   //module cla_16b(sum, c_out, a, b, c_in);
   cla_16b add0(.sum(PC_updated), .c_out(c_out), .a(PC_intermediary), .b(16'h0002), .c_in(1'b0));
   
endmodule
`default_nettype wire
