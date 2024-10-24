/*
   CS/ECE 552, Fall '22
   Homework #3, Problem #1

   This module creates a 16-bit register.  It has 1 write port, 2 read
   ports, 3 register select inputs, a write enable, a reset, and a clock
   input.  All register state changes occur on the rising edge of the
   clock.
*/
module regFile (
                // Outputs
                read1Data, read2Data, err,
                // Inputs
                clk, rst, read1RegSel, read2RegSel, writeregsel, writedata, write
                );

   input        clk, rst;
   input [2:0]  read1RegSel;
   input [2:0]  read2RegSel;
   input [2:0]  writeregsel;
   input [15:0] writedata;
   input        write;

   output [15:0] read1Data;
   output [15:0] read2Data;
   output        err;

   /* YOUR CODE HERE */

   // Intermediary logic
   wire [15:0] reg_out_1, reg_out_2, reg_out_3, reg_out_4, reg_out_5, reg_out_6, reg_out_7, reg_out_0;

   // Error
   //assign err = (clk === 1'bx | rst === 1'bx | write === 1'bx | writedata === 16'hxxxx | writeregsel === 3'bx | read1RegSel === 3'bx | read2RegSel === 3'bx) ? 1'b1 : 1'b0;
   assign err = (write === 1'bx) ? 1'b1 : 1'b0;

   // Instantiaitng 8 registers
   register i_reg_1(.out(reg_out_0), .in(writedata), .wr_en(write & (writeregsel === 3'b000)), .clk(clk), .rst(rst));
   register i_reg_2(.out(reg_out_1), .in(writedata), .wr_en(write & (writeregsel === 3'b001)), .clk(clk), .rst(rst));
   register i_reg_3(.out(reg_out_2), .in(writedata), .wr_en(write & (writeregsel === 3'b010)), .clk(clk), .rst(rst));
   register i_reg_4(.out(reg_out_3), .in(writedata), .wr_en(write & (writeregsel === 3'b011)), .clk(clk), .rst(rst));
   register i_reg_5(.out(reg_out_4), .in(writedata), .wr_en(write & (writeregsel === 3'b100)), .clk(clk), .rst(rst));
   register i_reg_6(.out(reg_out_5), .in(writedata), .wr_en(write & (writeregsel === 3'b101)), .clk(clk), .rst(rst));
   register i_reg_7(.out(reg_out_6), .in(writedata), .wr_en(write & (writeregsel === 3'b110)), .clk(clk), .rst(rst));
   register i_reg_8(.out(reg_out_7), .in(writedata), .wr_en(write & (writeregsel === 3'b111)), .clk(clk), .rst(rst));


   // Muxes for selecting read
   assign read1Data = (read1RegSel == 3'b000) ? reg_out_0 :
                        (read1RegSel == 3'b001) ? reg_out_1 :
                        (read1RegSel == 3'b010) ? reg_out_2 :
                        (read1RegSel == 3'b011) ? reg_out_3 :
                        (read1RegSel == 3'b100) ? reg_out_4 :
                        (read1RegSel == 3'b101) ? reg_out_5 :
                        (read1RegSel == 3'b110) ? reg_out_6 :
                        (read1RegSel == 3'b111) ? reg_out_7 :
                        16'hxxxx;

   assign read2Data = (read2RegSel == 3'b000) ? reg_out_0 :
                     (read2RegSel == 3'b001) ? reg_out_1 :
                     (read2RegSel == 3'b010) ? reg_out_2 :
                     (read2RegSel == 3'b011) ? reg_out_3 :
                     (read2RegSel == 3'b100) ? reg_out_4 :
                     (read2RegSel == 3'b101) ? reg_out_5 :
                     (read2RegSel == 3'b110) ? reg_out_6 :
                     (read2RegSel == 3'b111) ? reg_out_7 :
                     16'hxxxx;


endmodule
