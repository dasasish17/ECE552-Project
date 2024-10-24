/*
   CS/ECE 552, Fall '22
   Homework #3, Problem #1

   This module creates a 16-bit register.  It has 1 write port, 2 read
   ports, 3 register select inputs, a write enable, a reset, and a clock
   input.  All register state changes occur on the rising edge of the
   clock.
*/
module regFile #(parameter WIDTH = 16)
               (
                // Outputs
                read1Data, read2Data, err,
                // Inputs
                clk, rst, read1RegSel, read2RegSel, writeregsel, writedata, writeEn
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

   wire [7:0] errors;
   wire [WIDTH-1:0]reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7;
   register #(.WIDTH(WIDTH)) reg_0(.clk(clk), .rst(rst), .data_in(writedata), .write_en(write & (writeregsel == 3'b000)), .data_out(reg0), .err(errors[0]));
   register #(.WIDTH(WIDTH)) reg_1(.clk(clk), .rst(rst), .data_in(writedata), .write_en(write & (writeregsel == 3'b001)), .data_out(reg1), .err(errors[1]));
   register #(.WIDTH(WIDTH)) reg_2(.clk(clk), .rst(rst), .data_in(writedata), .write_en(write & (writeregsel == 3'b010)), .data_out(reg2), .err(errors[2]));
   register #(.WIDTH(WIDTH)) reg_3(.clk(clk), .rst(rst), .data_in(writedata), .write_en(write & (writeregsel == 3'b011)), .data_out(reg3), .err(errors[3]));
   register #(.WIDTH(WIDTH)) reg_4(.clk(clk), .rst(rst), .data_in(writedata), .write_en(write & (writeregsel == 3'b100)), .data_out(reg4), .err(errors[4]));
   register #(.WIDTH(WIDTH)) reg_5(.clk(clk), .rst(rst), .data_in(writedata), .write_en(write & (writeregsel == 3'b101)), .data_out(reg5), .err(errors[5]));
   register #(.WIDTH(WIDTH)) reg_6(.clk(clk), .rst(rst), .data_in(writedata), .write_en(write & (writeregsel == 3'b110)), .data_out(reg6), .err(errors[6]));
   register #(.WIDTH(WIDTH)) reg_7(.clk(clk), .rst(rst), .data_in(writedata), .write_en(write & (writeregsel == 3'b111)), .data_out(reg7), .err(errors[7]));

   assign read1Data =   (read1RegSel == 3'h0) ? reg0 :
                        (read1RegSel == 3'h1) ? reg1 :
                        (read1RegSel == 3'h2) ? reg2 :
                        (read1RegSel == 3'h3) ? reg3 :
                        (read1RegSel == 3'h4) ? reg4 :
                        (read1RegSel == 3'h5) ? reg5 :
                        (read1RegSel == 3'h6) ? reg6 :
                        (read1RegSel == 3'h7) ? reg7 :
                        16'h0000;

   assign read2Data =   (read2RegSel == 3'h0) ? reg0 :
                        (read2RegSel == 3'h1) ? reg1 :
                        (read2RegSel == 3'h2) ? reg2 :
                        (read2RegSel == 3'h3) ? reg3 :
                        (read2RegSel == 3'h4) ? reg4 :
                        (read2RegSel == 3'h5) ? reg5 :
                        (read2RegSel == 3'h6) ? reg6 :
                        (read2RegSel == 3'h7) ? reg7 :
                        16'h0000;

assign err = |errors | ^read1RegSel == 1'bx | ^read2RegSel == 1'bx | ^writeregsel == 1'bx | writeregsel == 1'bx |
                      ^read1RegSel == 1'bz | ^read2RegSel == 1'bz | ^writeregsel == 1'bz | writeregsel == 1'bz;

endmodule