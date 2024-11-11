/*
   CS/ECE 552 Spring '22
  
   Filename        : fetch.v
   Description     : This is the module for the overall fetch stage of the processor.
*/
`default_nettype none
module fetch (halt, stall, clk, rst, PC_intermediary, instr, PC_updated);

   // TODO: Your code here
   input wire halt, clk, rst, stall;
   wire [15:0] pcCurrent;
   output wire [15:0] instr;
   output wire [15:0] PC_updated;

   input wire [15:0] PC_intermediary;

   wire [15:0] intermediate_instruction;
   wire c_out;

   
   // use the register to set when we are changing the PC
   // module register(out, in, wr_en, clk, rst);
   // if not halt, we want to update the PC

   // not always write enable anymore// in case of halt and stall, we stop
   register reg0 (.out(pcCurrent), .in(PC_intermediary), .wr_en(~halt & ~stall), .clk(clk), .rst(rst));

    // increment PC by 2
   //module cla_16b(sum, c_out, a, b, c_in);
   cla_16b add0(.sum(PC_updated), .c_out(c_out), .a(pcCurrent), .b(16'h0002), .c_in(1'b0));

   // implement the instrcution memeory 
   //module memory2c (data_out, data_in, addr, enable, wr, createdump, clk, rst);
   memory2c mem0 (.data_out(intermediate_instruction), .data_in(16'b0), .addr(pcCurrent), .enable(1'b1), .wr(1'b0), .createdump(halt), .clk(clk), .rst(rst));
   assign instr = (halt| rst)? 16'b0000_1000_0000_0000 : intermediate_instruction; // ouput instruction
    
endmodule
`default_nettype wire
