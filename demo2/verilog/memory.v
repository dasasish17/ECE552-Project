/*
   CS/ECE 552 Spring '22
  
   Filename        : memory.v
   Description     : This module contains all components in the Memory stage of the 
                     processor.
*/
//Inputs: ImmSrc, PC_add, I
module memory (clk, rst, PC_add, ImmSrc, Imm8_Ext, Imm11_Ext, aluResult, ALU_Jump, memReadorWrite, memWrite, memRead, writeData, BrchCnd, final_new_PC, Read_Data, halt, flush);

   input wire [15:0] PC_add;
   input wire ImmSrc;
   input wire [15:0] Imm8_Ext;
   input wire [15:0] Imm11_Ext;
   input wire [15:0] aluResult;
   input wire memReadorWrite;
   input wire memWrite;
   input wire memRead;
   input wire [15:0] writeData;
   input wire BrchCnd;
   input wire ALU_Jump;
   output wire [15:0] final_new_PC;
   input wire clk;
   input wire rst;
   input wire halt;
   output wire flush;

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
   // assign shift_value = value_to_shift << 1;

   // module cla_16b(sum, c_out, a, b, c_in);
   // instantiate the cla_16b for additon 
   cla_16b add0(.sum(sum), .c_out(c_out), .a(PC_add), .b(value_to_shift), .c_in(1'b0));

   //BrchCnd mux 
   assign address = BrchCnd ? sum : PC_add;
   // ALU_jump mux
   assign final_new_PC = ALU_Jump ? aluResult : address;
   // assign PC_value = PC_add;
   // assign ALU = ALU_Result;

   // wire enable; 
   // assign memRead = ~halt;
  
   // read the main memory logic 
   //module memory2c (data_out, data_in, addr, enable, wr, createdump, clk, rst);
   //enable = 1'b1 or ????
   memory2c mem (.data_out(Read_Data), .data_in(writeData), .addr(aluResult), .enable(memReadorWrite), .wr(memWrite), .createdump(halt), .clk(clk), .rst(rst));
   assign flush = ALU_Result | BrchCnd;
   
endmodule
