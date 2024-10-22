/*
   CS/ECE 552 Spring '22
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
`default_nettype none
module decode (/* TODO: Add appropriate inputs/outputs for your decode stage here*/);

   // TODO: Your code here
   //inputs: instruction 
   input wire [15:0] instruction;
   input wire [15:0] Write_Data;

   output wire [15:0] read_Data1;
   output wire [15:0] read_Data2;
   output wire [15:0] imm5_ext_rst;
   output wire [15:0] imm8_ext_rst;
   output wire [15:0] imm11_sign_ext;

   input clk;
   input rst;

   wire [15:0] imm5_sign_ext;
   wire [15:0] imm5_zero_ext;
   wire [15:0] imm8_sign_ext;
   wire [15:0] imm8_zero_ext;

   wire [4:0] imm5;
   wire [7:0] imm8;
   wire [10:0] imm11;
   wire zeroExt;
   wire [2:0] Write_Register;
   wire [1:0] RegDst;
   wire RegWrite; 
   
   
   assign imm5 = instruction[4:0];
   assign imm8 = instruction[7:0];
   assign imm11 = instruction[10:0];

   //the immediate extend part 
   assign imm5_sign_ext = {{11{imm5[4]}}, imm5};
   assign imm5_zero_ext = {11'b0, imm5};

   assign imm8_sign_ext = {{8{imm5[7]}}, imm8};
   assign imm8_zero_ext = {8'b0, imm8};

   assign imm11_sign_ext = {{5{imm5[10]}}, imm11};

   // zeroExt mux 
   // assign value_to_shift = ImmSrc ? Imm11_Ext : Imm8_Ext;
   assign imm5_ext_rst = zeroExt ? imm5_zero_ext : imm5_sign_ext;
   assign imm8_ext_rst = zeroExt ? imm8_zero_ext : imm8_sign_ext;

   assign Write_Register = (RegDst == 2'b00) : instruction[7:5] ?
                              (RegDst == 2'b01) : instruction[10:8] ?
                              (RegDst == 2'b10) : instruction[4:2] ? 3'b111;
   
   // module regFile (read1Data, read2Data, err, clk, rst, read1RegSel, read2RegSel, writeRegSel, writeData, writeEn
   regFile regFile0 (.read1Data(read_Data1),
                  .read2Data(read_Data2),
                  .err(1'b0),
                  .clk(clk),
                  .rst(rst),
                  .read1RegSel(instruction[10:8]),
                  .read2RegSel(instruction[7:5]),
                  .writeRegSel(Write_Register),
                  .writeData(Write_Data),
                  .writeEn(RegWrite));
      
   
endmodule
`default_nettype wire
