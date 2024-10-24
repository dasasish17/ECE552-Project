/* $Author: sinclair $ */
/* $LastChangedDate: 2020-02-09 17:03:45 -0600 (Sun, 09 Feb 2020) $ */
/* $Rev: 46 $ */
`default_nettype none
module proc (/*AUTOARG*/
   // Outputs
   err, 
   // Inputs
   clk, rst
   );

   input wire clk;
   input wire rst;

   output wire err;

   // None of the above lines can be modified


   
   /* your code here -- should include instantiations of fetch, decode, execute, mem and wb modules */

      // Internal signal declarations
       wire halt;
       wire [15:0] PC_current, PC_updated;
       wire [15:0] instruction;
       wire [15:0] write_data;
       wire [15:0] read_data1, read_data2;
       wire [15:0] imm5_ext_rst, imm8_ext_rst, imm11_sign_ext;
       wire ImmSrc, MemRead, MemWrite, ALU_jump, InvA, InvB, Cin, Beq, Bne, Blt, Bgt;
       wire [1:0]MemToReg;
       wire [1:0] ALUSrc1, ALUSrc2;
       wire [3:0] ALU_op;
       wire [15:0] ALU_result, nextPC, mem_data_out;
       wire Zero, Neg, Ofl, Cout;
       wire BrnchCnd, ALUJump;
       wire mem_err, alu_err, decode_err;
       wire [15:0]finalPC;
       wire actualRead;

       // Instantiate fetch stage
       fetch fetch0 (
           .clk(clk),
           .rst(rst),
           .halt(halt),
           .PC_intermediary(PC_updated),
           .instr(instruction),
           .PC_updated(PC_current)
       );

       // Instantiate decode stage
       decode decode0 (
           .clk(clk),
           .rst(rst),
           .instruction(instruction),
           .Write_Data(write_data),
           .ImmSrc(ImmSrc),
           .MemEnable(MemRead),
           .MemWrite(MemWrite),
           .ALU_jump(ALU_jump),
           .InvA(InvA),
           .InvB(InvB),
           .Cin(Cin),
           .Beq(Beq),
           .Bne(Bne),
           .Blt(Blt),
           .Bgt(Bgt),
           .Halt(halt),
           .MemToReg(MemToReg),
           .ALUSrc1(ALUSrc1),
           .ALUSrc2(ALUSrc2),
           .ALU_op(ALU_op),
           .err(decode_err),
           .read_Data1(read_data1),
           .read_Data2(read_data2),
           .imm5_ext_rst(imm5_ext_rst),
           .imm8_ext_rst(imm8_ext_rst),
           .imm11_sign_ext(imm11_sign_ext)
       );

       // Instantiate execute stage
       execute execute0 (
           .read1Data(read_data1),
           .read2Data(read_data2),
           .imm5_ext_rst(imm5_ext_rst),
           .imm8_ext_rst(imm8_ext_rst),
           .imm11_sign_ext(imm11_sign_ext),
           .AluSrc1(ALUSrc1),
           .AluSrc2(ALUSrc2),
           .Oper(ALU_op),
           .AluCin(Cin),
           .InvA(InvA),
           .InvB(InvB),
           .Beq(Beq),
           .Bne(Bne),
           .Blt(Blt),
           .Bgt(Bgt),
           .AluRes(ALU_result),
           .err(alu_err),
           .BrnchCnd(BrnchCnd)
       );

       // Instantiate memory stage
       memory memory0 (
           .clk(clk),
           .rst(rst),
           .PC_add(PC_current),
           .ImmSrc(ImmSrc),
           .Imm8_Ext(imm8_ext_rst),
           .Imm11_Ext(imm11_sign_ext),
           .aluResult(ALU_result),
           .ALU_Jump(ALU_jump),
           .memWrite(MemWrite),
           .memRead(actualRead),
           .memReadorWrite(MemRead),
           .writeData(read_data2),
           .BrchCnd(BrnchCnd),
           .final_new_PC(PC_updated),
           .Read_Data(mem_data_out),
           .halt(halt)
       );

       // Instantiate write back stage
       wb wb0 (
           .PC_address(PC_current),
           .Read_Data(mem_data_out),
           .ALU_Result(ALU_result),
           .MemToReg(MemToReg),
           .Write_Data(write_data)
       );

        // OR all the err ouputs for every sub-module and assign it as this
      // err output

      // As desribed in the homeworks, use the err signal to trap corner
      // cases that you think are illegal in your statemachines
      assign err = alu_err | decode_err; // | mem_err;
      // assign err = 1'b0;

endmodule // proc
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :0:
