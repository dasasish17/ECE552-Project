/*
   CS/ECE 552 Spring '22
  
   Filename        : wb.v
   Description     : This is the module for the overall Write Back stage of the processor.
*/
`default_nettype none
module wb (PC_address, Read_Data, ALU_Result, MemToReg, Write_Data);

   input wire [15:0] PC_address;
   input wire [15:0] Read_Data;
   input wire [15:0] ALU_Result;
   input wire [1:0] MemToReg;
   output wire [15:0] Write_Data;

   assign Write_Data = (MemToReg == 2'b00) ? PC_address :
                       (MemToReg == 2'b01) ? Read_Data :
                       (MemToReg == 2'b10) ? ALU_Result : 16'h0000;

endmodule
`default_nettype wire
