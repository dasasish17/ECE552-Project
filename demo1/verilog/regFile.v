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

   parameter WIDTH = 16;

   input        clk, rst;
   input [2:0]  read1RegSel;
   input [2:0]  read2RegSel;
   input [2:0]  writeregsel;
   input [WIDTH-1:0] writedata;
   input        write;

   output [WIDTH-1:0] read1Data;
   output [WIDTH-1:0] read2Data;
   output        err;

   /* YOUR CODE HERE */


   wire [WIDTH-1:0] regs[7:0]; // Array of 8 registers with width bits each

   //error logic
   assign err = (^clk === 1'bx) ? 1'b1 :
             (^rst === 1'bx) ? 1'b1 :
             (^read1RegSel === 1'bx) ? 1'b1 :
             (^read2RegSel === 1'bx) ? 1'b1 :
             (^writeregsel === 1'bx) ? 1'b1 :
             (^writedata === 1'bx) ? 1'b1 :
             (^write === 1'bx) ? 1'b1 : 1'b0;

   // instantiating the 8 registers with decoder write logic
   register #(.WIDTH(WIDTH)) reg_0 (.out(regs[0]), .in(writedata), .wr_en(write & (writeregsel == 0)), .clk(clk), .rst(rst));
   register #(.WIDTH(WIDTH)) reg_1 (.out(regs[1]), .in(writedata), .wr_en(write & (writeregsel == 1)), .clk(clk), .rst(rst));
   register #(.WIDTH(WIDTH)) reg_2 (.out(regs[2]), .in(writedata), .wr_en(write & (writeregsel == 2)), .clk(clk), .rst(rst));
   register #(.WIDTH(WIDTH)) reg_3 (.out(regs[3]), .in(writedata), .wr_en(write & (writeregsel == 3)), .clk(clk), .rst(rst));
   register #(.WIDTH(WIDTH)) reg_4 (.out(regs[4]), .in(writedata), .wr_en(write & (writeregsel == 4)), .clk(clk), .rst(rst));
   register #(.WIDTH(WIDTH)) reg_5 (.out(regs[5]), .in(writedata), .wr_en(write & (writeregsel == 5)), .clk(clk), .rst(rst));
   register #(.WIDTH(WIDTH)) reg_6 (.out(regs[6]), .in(writedata), .wr_en(write & (writeregsel == 6)), .clk(clk), .rst(rst));
   register #(.WIDTH(WIDTH)) reg_7 (.out(regs[7]), .in(writedata), .wr_en(write & (writeregsel == 7)), .clk(clk), .rst(rst));


   assign read1Data = regs[read1RegSel];
   assign read2Data = regs[read2RegSel];

endmodule