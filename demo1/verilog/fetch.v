/*
   CS/ECE 552 Spring '22
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
`default_nettype none
module fetch (/* TODO: Add appropriate inputs/outputs for your fetch stage here*/);

   // TODO: Your code here
   input wire Halt, clk, rst;
   input wire [15:0] PC_address;
   output wire [15:0] instruction;
   output wire [15:0] PC_add;

   wire [15:0] PC_value;
   wire c_out;

   // use the register to set when we are changing the PC
   // module register(out, in, wr_en, clk, rst);
   // if not half, we want to update the PC
   register reg0 (.out(PC_value), .in(PC_address), wr_en(~Halt), .clk(clk), .rst(rst));

   // implement the instrcution memeory 
   //module memory2c (data_out, data_in, addr, enable, wr, createdump, clk, rst);
   memory2c mem0 (.data_out(instruction), .data_in(1'b0), addr(PC_value), .enable(1'b1), .wr(1'b0), .clk(clk), .rst(rst));

   // increment PC by 2
   //module cla_16b(sum, c_out, a, b, c_in);
   cla_16b add0(.sum(PC_add), .c_out(c_out), .a(PC_value), .b(16'h0002), .c_in(1'b0));

   
endmodule
`default_nettype wire
