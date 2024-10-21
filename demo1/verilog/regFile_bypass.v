/*
   CS/ECE 552, Fall '22
   Homework #3, Problem #2

   This module creates a wrapper around the 8x16b register file, to do
   do the bypassing logic for RF bypassing.
*/
module regFile_bypass (
                       // Outputs
                       read1Data, read2Data, err,
                       // Inputs
                       clk, rst, read1RegSel, read2RegSel, writeRegSel, writeData, writeEn
                       );
   input        clk, rst;
   input [2:0]  read1RegSel;
   input [2:0]  read2RegSel;
   input [2:0]  writeRegSel;
   input [15:0] writeData;
   input        writeEn;

   output [15:0] read1Data;
   output [15:0] read2Data;
   output        err;

   /* YOUR CODE HERE */

   wire [15:0] out1, out2;


   // instantiating the register file
   regFile u_regFile (.read1Data(out1), .read2Data(out2), .err(err), .clk(clk), .rst(rst), .read1RegSel(read1RegSel), .read2RegSel(read2RegSel), .writeRegSel(writeRegSel), .writeData(writeData), .writeEn(writeEn));

   // Adding bypass logic

   //if write register is the same as read register, then the output is the writeData, otherwise the output is the register output
   assign read1Data = (writeEn & (read1RegSel == writeRegSel)) ? writeData : out1;
   assign read2Data = (writeEn & (read2RegSel == writeRegSel)) ? writeData : out2;

endmodule