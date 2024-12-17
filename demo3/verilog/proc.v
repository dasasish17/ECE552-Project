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
   wire [1:0] MemToReg;
   wire [1:0] ALUSrc1, ALUSrc2;
   wire [3:0] ALU_op;
   wire [15:0] ALU_result, nextPC, mem_data_out;
   wire Zero, Neg, Ofl, Cout;
   wire BrnchCnd, ALUJump;
   wire mem_err, alu_err, decode_err;
   wire [15:0] finalPC;
   wire actualRead;
   //wire potRAW_R, potRAW_I;
   wire [2:0] Rs, Rt;

   wire RegWrite;
   wire [2:0] WriteRegister;

   // if_id flop signals
   wire [15:0]if_id_instruction;

  // id_ex flop signals
  wire [15:0] id_ex_read_Data1, id_ex_read_Data2;
  wire id_ex_ImmSrc, id_ex_MemEnable, id_ex_MemWrite, id_ex_memRead, id_ex_ALU_jump;
  wire id_ex_InvA, id_ex_InvB, id_ex_Cin;
  wire id_ex_Beq, id_ex_Bne, id_ex_Blt, id_ex_Bgt;
  wire id_ex_Halt;
  wire [1:0] id_ex_MemToReg;
  wire [1:0] id_ex_ALUSrc1, id_ex_ALUSrc2;
  wire [3:0] id_ex_ALU_op;
  wire [15:0] id_ex_imm5_ext_rst, id_ex_imm8_ext_rst, id_ex_imm11_sign_ext;
  wire [2:0] id_ex_Write_Register;
  wire id_ex_RegWrite;
  wire [15:0] if_id_PC_Updated, id_ex_PC_Updated;
  wire [2:0] id_ex_Rs, id_ex_Rt;

  // ex_mem flop signals
   wire [1:0] ex_mem_MemToReg;
   wire [15:0] ex_mem_PC_Updated;
   wire ex_mem_ImmSrc;
   wire [15:0] ex_mem_Imm8_Ext, ex_mem_Imm11_Ext;
   wire [15:0] ex_mem_aluResult, ex_mem_writeData;
   wire ex_mem_memReadorWrite, ex_mem_memWrite, ex_mem_memRead;
   wire ex_mem_BrchCnd, ex_mem_ALU_Jump;
   wire ex_mem_RegWrite;
   wire [2:0] ex_mem_Write_Register;

  // mem_wb flop signals
  wire [15:0] mem_wb_Read_Data, mem_wb_ALU_Result;
  wire [1:0] mem_wb_MemToReg;
  wire [15:0] mem_wb_PC_Updated;
  wire [2:0] mem_wb_Write_Register;
  wire mem_wb_RegWrite;

  wire [15:0] PC_flush;

  wire flush;
  wire hu_stall;
  wire ex_ex_Rs_fwd, ex_ex_Rt_fwd, mem_ex_Rs_fwd, mem_ex_Rt_fwd;

  wire final_halt, id_ex_halt, ex_mem_halt, mem_wb_halt;
  wire [15:0] final_PC_incr;
  wire final_stall;

  // forwarding wires
  wire [15:0] ex_ex_fwd_readData1, ex_ex_fwd_readData2, mem_ex_fwd_readData1, mem_ex_fwd_readData2;
  // wire [15:0] id_ex_fwd_readRs, id_ex_fwd_readRt;


  // final halt logic
  assign final_halt = (~flush) & (halt | id_ex_halt | ex_mem_halt | mem_wb_halt);
  // flush-based PC_increment logic
  assign final_PC_incr = flush ? PC_flush : PC_current;
  // final stall logic
  assign final_stall = flush ? 1'b0 : hu_stall;

  wire final_MemRead, final_MemWrite, final_MemEnable, final_RegWrite, final_Beq, final_Bne, final_Blt, final_Bgt, final_ALU_jump;

  assign final_MemRead = final_stall ? 1'b0 : actualRead;
  assign final_MemWrite = final_stall ? 1'b0 : MemWrite;
  assign final_MemEnable = final_stall ? 1'b0 : MemRead;
  assign final_RegWrite = final_stall ? 1'b0 : RegWrite;
  assign final_Beq = final_stall ? 1'b0 : Beq;
  assign final_Bne = final_stall ? 1'b0 : Bne;
  assign final_Blt = final_stall ? 1'b0 : Blt;
  assign final_Bgt = final_stall ? 1'b0 : Bgt;
  assign final_ALU_jump = final_stall ? 1'b0 : ALU_jump;

  // Forwarding Logic
  
   assign ex_ex_fwd_readData1 = ex_ex_Rs_fwd ? ex_mem_aluResult : mem_ex_fwd_readData1;
   assign ex_ex_fwd_readData2 = ex_ex_Rt_fwd ? ex_mem_aluResult : mem_ex_fwd_readData2;
   assign mem_ex_fwd_readData1 = mem_ex_Rs_fwd ? write_data : id_ex_read_Data1;
   assign mem_ex_fwd_readData2 = mem_ex_Rt_fwd ? write_data : id_ex_read_Data2;


   // Instantiate fetch stage
   fetch fetch0 (.clk(clk), .rst(rst), .halt(final_halt), .PC_intermediary(final_PC_incr), .instr(instruction), .PC_updated(PC_current), .stall(final_stall));

   // Instantiate the if_id flop
   if_id if_id_0 (.instruction(instruction), .PC_updated(PC_current), .clk(clk), .rst(rst), .if_id_instruction(if_id_instruction), .if_id_PC_Updated(if_id_PC_Updated), .flush(flush), .stall(final_stall));

   // Instantiate decode stage
   decode decode0 (.clk(clk), .rst(rst), .instruction(if_id_instruction), .Write_Data(write_data), .ImmSrc(ImmSrc), .MemEnable(MemRead),
                    .mem_wb_RegWrite(mem_wb_RegWrite), .mem_wb_Write_Register(mem_wb_Write_Register), .MemWrite(MemWrite), .memRead(actualRead), .ALU_jump(ALU_jump),
                    .Rs(Rs), .Rt(Rt), .InvA(InvA), .InvB(InvB), .Cin(Cin), .Beq(Beq), .Bne(Bne), .Blt(Blt), .Bgt(Bgt), .Halt(halt),
                    .MemToReg(MemToReg), .ALUSrc1(ALUSrc1), .ALUSrc2(ALUSrc2), .ALU_op(ALU_op), .err(decode_err), .read_Data1(read_data1),
                    .read_Data2(read_data2), .imm5_ext_rst(imm5_ext_rst), .imm8_ext_rst(imm8_ext_rst), .imm11_sign_ext(imm11_sign_ext),
                    .RegWrite(RegWrite), .Write_Register(WriteRegister));


   // Instantiate the id_ex flop
   id_ex id_ex0 (.clk(clk), .rst(rst), .Flush(flush), .if_id_PC_Updated(if_id_PC_Updated), .read_Data1(read_data1), .read_Data2(read_data2), .ImmSrc(ImmSrc), .MemEnable(final_MemEnable),
                 .MemWrite(final_MemWrite), .memRead(final_MemRead), .ALU_jump(final_ALU_jump), .InvA(InvA), .InvB(InvB), .Cin(Cin), .Beq(final_Beq), .Bne(final_Bne), .Blt(final_Blt),
                 .Bgt(final_Bgt), .Halt(halt), .MemToReg(MemToReg), .ALUSrc1(ALUSrc1), .ALUSrc2(ALUSrc2), .ALU_op(ALU_op), .imm5_ext_rst(imm5_ext_rst),
                 .imm8_ext_rst(imm8_ext_rst), .imm11_sign_ext(imm11_sign_ext), .Write_Register(WriteRegister), .RegWrite(final_RegWrite), .id_ex_read_Data1(id_ex_read_Data1),
                 .id_ex_read_Data2(id_ex_read_Data2), .id_ex_ImmSrc(id_ex_ImmSrc), .id_ex_MemEnable(id_ex_MemEnable), .id_ex_MemWrite(id_ex_MemWrite), .id_ex_memRead(id_ex_memRead),
                 .id_ex_ALU_jump(id_ex_ALU_jump), .id_ex_InvA(id_ex_InvA), .id_ex_InvB(id_ex_InvB), .id_ex_Cin(id_ex_Cin), .id_ex_Beq(id_ex_Beq), .id_ex_Bne(id_ex_Bne),
                 .id_ex_Blt(id_ex_Blt), .id_ex_Bgt(id_ex_Bgt), .id_ex_Halt(id_ex_halt), .id_ex_MemToReg(id_ex_MemToReg), .id_ex_ALUSrc1(id_ex_ALUSrc1), .id_ex_ALUSrc2(id_ex_ALUSrc2),
                 .id_ex_ALU_op(id_ex_ALU_op), .id_ex_imm5_ext_rst(id_ex_imm5_ext_rst), .id_ex_imm8_ext_rst(id_ex_imm8_ext_rst), .id_ex_imm11_sign_ext(id_ex_imm11_sign_ext),
                 .id_ex_Write_Register(id_ex_Write_Register), .id_ex_RegWrite(id_ex_RegWrite), .id_ex_PC_Updated(id_ex_PC_Updated), .Rs(Rs), .Rt(Rt), .id_ex_Rs(id_ex_Rs), .id_ex_Rt(id_ex_Rt));

   // hazard_unit hu0 (.instruction(if_id_instruction), .id_ex_reg_write(id_ex_RegWrite), .ex_mem_reg_write(ex_mem_RegWrite), .id_ex_reg_dst(id_ex_Write_Register),
   //                  .ex_mem_reg_dst(ex_mem_Write_Register), .potRAW_R(potRAW_R), .potRAW_I(potRAW_I), .stall(hu_stall));
   
   hazard_unit hu0 (.instruction(if_id_instruction), .id_ex_reg_dst(id_ex_Write_Register), .ex_mem_reg_dst(ex_mem_Write_Register), .mem_wb_reg_dst(mem_wb_Write_Register), .id_ex_Rs(id_ex_Rs), .id_ex_Rt(id_ex_Rt), 
               .id_ex_regWrite(id_ex_RegWrite), .ex_mem_regWrite(ex_mem_RegWrite), .mem_wb_regWrite(mem_wb_RegWrite), .id_ex_memRead(id_ex_memRead), .ex_mem_memRead(ex_mem_memRead), 
               .stall(hu_stall), .ex_ex_Rs_fwd(ex_ex_Rs_fwd), .ex_ex_Rt_fwd(ex_ex_Rt_fwd), .mem_ex_Rs_fwd(mem_ex_Rs_fwd), .mem_ex_Rt_fwd(mem_ex_Rt_fwd));
   
   // Instantiate execute stage
   execute execute0 (.read1Data(ex_ex_fwd_readData1), .read2Data(ex_ex_fwd_readData2), .id_ex_PC_Updated(id_ex_PC_Updated), .imm5_ext_rst(id_ex_imm5_ext_rst), .imm8_ext_rst(id_ex_imm8_ext_rst), .imm11_sign_ext(id_ex_imm11_sign_ext),
                     .AluSrc1(id_ex_ALUSrc1), .AluSrc2(id_ex_ALUSrc2), .Oper(id_ex_ALU_op), .AluCin(id_ex_Cin), .InvA(id_ex_InvA), .InvB(id_ex_InvB), .Beq(id_ex_Beq), .Bne(id_ex_Bne),
                     .Blt(id_ex_Blt), .Bgt(id_ex_Bgt), .AluRes(ALU_result), .err(alu_err), .BrnchCnd(BrnchCnd));

   // Instnantiate the ex_mem flop
   ex_mem ex_mem0 (.id_ex_PC_Updated(id_ex_PC_Updated), .id_ex_ImmSrc(id_ex_ImmSrc), .id_ex_Imm8_Ext(id_ex_imm8_ext_rst), .id_ex_Imm11_Ext(id_ex_imm11_sign_ext), .aluResult(ALU_result),
                   .id_ex_memReadorWrite(id_ex_MemEnable), .id_ex_memWrite(id_ex_MemWrite), .id_ex_memRead(id_ex_memRead), .id_ex_writeData(ex_ex_fwd_readData2), .id_ex_RegWrite(id_ex_RegWrite),
                   .id_ex_Write_Register(id_ex_Write_Register), .BrchCnd(BrnchCnd), .id_ex_ALU_Jump(id_ex_ALU_jump), .clk(clk), .rst(rst), .Flush(flush), .id_ex_halt(id_ex_halt), .id_ex_MemToReg(id_ex_MemToReg),
                   .ex_mem_MemToReg(ex_mem_MemToReg), .ex_mem_PC_Updated(ex_mem_PC_Updated), .ex_mem_ImmSrc(ex_mem_ImmSrc), .ex_mem_Imm8_Ext(ex_mem_Imm8_Ext), .ex_mem_Imm11_Ext(ex_mem_Imm11_Ext),
                   .ex_mem_aluResult(ex_mem_aluResult), .ex_mem_memReadorWrite(ex_mem_memReadorWrite), .ex_mem_memWrite(ex_mem_memWrite), .ex_mem_memRead(ex_mem_memRead), .ex_mem_writeData(ex_mem_writeData),
                   .ex_mem_BrchCnd(ex_mem_BrchCnd), .ex_mem_ALU_Jump(ex_mem_ALU_Jump), .ex_mem_halt(ex_mem_halt), .ex_mem_RegWrite(ex_mem_RegWrite), .ex_mem_Write_Register(ex_mem_Write_Register));

   // Instantiate memory stage
   memory memory0 (.clk(clk), .rst(rst), .PC_add(ex_mem_PC_Updated), .ImmSrc(ex_mem_ImmSrc), .Imm8_Ext(ex_mem_Imm8_Ext), .Imm11_Ext(ex_mem_Imm11_Ext),
                   .aluResult(ex_mem_aluResult), .ALU_Jump(ex_mem_ALU_Jump), .memWrite(ex_mem_memWrite), .memRead(ex_mem_memRead), .memReadorWrite(ex_mem_memReadorWrite),
                   .writeData(ex_mem_writeData), .BrchCnd(ex_mem_BrchCnd), .final_new_PC(PC_flush), .Read_Data(mem_data_out), .halt(ex_mem_halt), .flush(flush));

   // Instnantiate the mem_wb flop
   mem_wb mem_wb0 (.Read_Data(mem_data_out), .ex_mem_ALU_Result(ex_mem_aluResult), .ex_mem_MemToReg(ex_mem_MemToReg), .ex_mem_PC_Updated(ex_mem_PC_Updated), .ex_mem_halt(ex_mem_halt), .ex_mem_RegWrite(ex_mem_RegWrite),
                   .ex_mem_Write_Register(ex_mem_Write_Register), .clk(clk), .rst(rst), .mem_wb_Read_Data(mem_wb_Read_Data), .mem_wb_ALU_Result(mem_wb_ALU_Result), .mem_wb_MemToReg(mem_wb_MemToReg),
                   .mem_wb_PC_Updated(mem_wb_PC_Updated), .mem_wb_halt(mem_wb_halt), .mem_wb_Write_Register(mem_wb_Write_Register), .mem_wb_RegWrite(mem_wb_RegWrite));
   // above originally it was pc_flush but we changed to ex_mem_PC_Updated
   // Instantiate write back stage
   wb wb0 (.PC_address(mem_wb_PC_Updated), .Read_Data(mem_wb_Read_Data), .ALU_Result(mem_wb_ALU_Result), .MemToReg(mem_wb_MemToReg), .Write_Data(write_data));

   // OR all the err outputs for every sub-module and assign it as this
   // err output

   // As described in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your state machines
   assign err = alu_err | decode_err; // | mem_err;
   // assign err = 1'b0;

endmodule // proc
`default_nettype wire
// DUMMY LINE FOR REV CONTROL :0:
