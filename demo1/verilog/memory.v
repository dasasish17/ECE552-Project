/*
   CS/ECE 552 Spring '22
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/
`default_nettype none
//Inputs: ImmSrc, PC_add, I
module memory (clk, rst, PC_add, ImmSrc, Imm8_Ext, Imm11_Ext, ALU_Result, ALU_Jump, MemWrite, MemEnable, ReadData2, BrchCnd, final_new_PC, PC_value, Read_Data, ALU);

   input wire [15:0] PC_add;
   input wire ImmSrc;
   input wire [15:0] Imm8_Ext;
   input wire [15:0] Imm11_Ext;
   input wire [15:0] ALU_Result;
   input wire MemWrite;
   input wire MemEnable;
   input wire [15:0] ReadData2;
   input wire BrchCnd;
   output wire [15:0] final_new_PC;
   input wire clk;
   input wire rst;
   input wire Halt;

   // change the output below 
   // output wire [15:0] PC_value;
   output wire [15:0] Read_Data;
   // output wire [15:0] ALU;
   wire [15:0] value_to_shift;
   wire [15:0] shift_value;
   wire [15:0] sum;
   wire c_out;
   wire [15:0] address;

   //write the ImmSrc Mux logic 
   //assign y = sel ? b : a; 
   assign value_to_shift = ImmSrc ? Imm11_Ext : Imm8_Ext;
   assign shift_value = value_to_shift << 1;

   // module cla_16b(sum, c_out, a, b, c_in);
   // instantiate the cla_16b for additon 
   cla_16b add0(.sum(sum), .c_out(c_out), .a(PC_add), .b(shift_value), .c_in(1'b0));

   //BrchCnd mux 
   assign address = BrchCnd ? sum : PC_add;
   // ALU_jump mux
   assign final_new_PC = ALU_Jump ? ALU_Result : address;
   // assign PC_value = PC_add;
   // assign ALU = ALU_Result;

   // read the main memory logic 
   //module memory2c (data_out, data_in, addr, enable, wr, createdump, clk, rst);
   memory2c mem (.data_out(Read_Data), .data_in(ReadData2), .addr(ALU_Result), .enable(MemEnable), .wr(MemWrite), .createdump(Halt), .clk(clk), .rst(rst));

   
endmodule
`default_nettype wire
