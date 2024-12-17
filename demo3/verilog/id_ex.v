`default_nettype none

module id_ex (
    clk, 
    rst,
    Flush,
    read_Data1,
    read_Data2,
    ImmSrc,
    MemEnable,
    MemWrite,
    memRead,
    ALU_jump,
    InvA,
    InvB,
    Cin,
    Beq,
    Bne,
    Blt,
    Bgt,
    Halt,
    MemToReg,
    ALUSrc1,
    ALUSrc2,
    ALU_op,
    imm5_ext_rst,
    imm8_ext_rst,
    imm11_sign_ext,
    Write_Register, //writeRegSel
    RegWrite,
    id_ex_read_Data1,
    id_ex_read_Data2,
    id_ex_ImmSrc,
    id_ex_MemEnable,
    id_ex_MemWrite,
    id_ex_memRead,
    id_ex_ALU_jump,
    id_ex_InvA,
    id_ex_InvB,
    id_ex_Cin,
    id_ex_Beq,
    id_ex_Bne,
    id_ex_Blt,
    id_ex_Bgt,
    id_ex_Halt,
    id_ex_MemToReg,
    id_ex_ALUSrc1,
    id_ex_ALUSrc2,
    id_ex_ALU_op,
    id_ex_imm5_ext_rst,
    id_ex_imm8_ext_rst,
    id_ex_imm11_sign_ext,
    id_ex_Write_Register, // id_ex_writeRegSel
    id_ex_RegWrite,
    if_id_PC_Updated,
    id_ex_PC_Updated,
    Rs,
    Rt,
    id_ex_Rs,
    id_ex_Rt,
    StallDMem
);
    input wire clk;
    input wire rst;
    input wire Flush;
    input wire [15:0] read_Data1;
    input wire [15:0] read_Data2;
    input wire ImmSrc;
    input wire MemEnable;
    input wire MemWrite;
    input wire memRead;
    input wire ALU_jump;
    input wire InvA;
    input wire InvB;
    input wire Cin;
    input wire Beq;
    input wire Bne;
    input wire Blt;
    input wire Bgt;
    input wire Halt;

    input wire [1:0] MemToReg;
    input wire [1:0] ALUSrc1;
    input wire [1:0] ALUSrc2;
    input wire [3:0] ALU_op;
    input wire [15:0]imm5_ext_rst;
    input wire [15:0]imm8_ext_rst;
    input wire [15:0]imm11_sign_ext;
    input wire [2:0] Write_Register;
    input wire RegWrite, StallDMem;
    input wire [2:0] Rs, Rt;

    output wire [15:0] id_ex_read_Data1;
    output wire [15:0] id_ex_read_Data2;
    output wire id_ex_ImmSrc;
    output wire id_ex_MemEnable;
    output wire id_ex_MemWrite;
    output wire id_ex_memRead;
    output wire id_ex_ALU_jump;
    output wire id_ex_InvA;
    output wire id_ex_InvB;
    output wire id_ex_Cin;
    output wire id_ex_Beq;
    output wire id_ex_Bne;
    output wire id_ex_Blt;
    output wire id_ex_Bgt;
    output wire id_ex_Halt;
   
    output wire [1:0] id_ex_MemToReg;
    output wire [1:0] id_ex_ALUSrc1;
    output wire [1:0] id_ex_ALUSrc2;
    output wire [3:0] id_ex_ALU_op;
    output wire [15:0] id_ex_imm5_ext_rst;
    output wire [15:0] id_ex_imm8_ext_rst;
    output wire [15:0] id_ex_imm11_sign_ext;
    output wire [2:0] id_ex_Write_Register;
    output wire id_ex_RegWrite;
    output wire [2:0] id_ex_Rs, id_ex_Rt;

    input wire [15:0] if_id_PC_Updated;
    output wire [15:0] id_ex_PC_Updated;

    //module register(out, in, wr_en, clk, rst);
    register #(.WIDTH(16)) register0 (.out(id_ex_read_Data1), .in(read_Data1), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush|Halt) & ~StallDMem)));
    register #(.WIDTH(16)) register1 (.out(id_ex_read_Data2), .in(read_Data2), .wr_en(~StallDMem), .clk(clk), .rst(rst|Flush));
   
    register #(.WIDTH(1)) register2 (.out(id_ex_ImmSrc), .in(ImmSrc), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush|Halt) & ~StallDMem)));
    register #(.WIDTH(1)) register3 (.out(id_ex_MemEnable), .in(MemEnable), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush|Halt) & ~StallDMem)));
    register #(.WIDTH(1)) register4 (.out(id_ex_MemWrite), .in(MemWrite), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush|Halt) & ~StallDMem)));
    register #(.WIDTH(1)) register5 (.out(id_ex_memRead), .in(memRead), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush|Halt) & ~StallDMem)));
    register #(.WIDTH(1)) register6 (.out(id_ex_ALU_jump), .in(ALU_jump), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush|Halt) & ~StallDMem)));
    register #(.WIDTH(1)) register7 (.out(id_ex_InvA), .in(InvA), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush|Halt) & ~StallDMem)));
    register #(.WIDTH(1)) register8 (.out(id_ex_InvB), .in(InvB), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush|Halt) & ~StallDMem)));
    register #(.WIDTH(1)) register9 (.out(id_ex_Cin), .in(Cin), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush|Halt) & ~StallDMem)));
    register #(.WIDTH(1)) register10 (.out(id_ex_Beq), .in(Beq), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush|Halt) & ~StallDMem)));
    register #(.WIDTH(1)) register11 (.out(id_ex_Bne), .in(Bne), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush|Halt) & ~StallDMem)));
    register #(.WIDTH(1)) register12 (.out(id_ex_Blt), .in(Blt), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush|Halt) & ~StallDMem)));
    register #(.WIDTH(1)) register13 (.out(id_ex_Bgt), .in(Bgt), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush|Halt) & ~StallDMem)));
    register #(.WIDTH(1)) register14 (.out(id_ex_Halt), .in(Halt), .wr_en(~StallDMem), .clk(clk), .rst(rst|(Flush&~StallDMem));
   
    register #(.WIDTH(2)) register16 (.out(id_ex_MemToReg), .in(MemToReg), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush|Halt) & ~StallDMem)));
    register #(.WIDTH(2)) register17 (.out(id_ex_ALUSrc1), .in(ALUSrc1), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush|Halt) & ~StallDMem)));
    register #(.WIDTH(2)) register18 (.out(id_ex_ALUSrc2), .in(ALUSrc2), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush|Halt) & ~StallDMem)));
    register #(.WIDTH(4)) register19 (.out(id_ex_ALU_op), .in(ALU_op), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush|Halt) & ~StallDMem)));
    register #(.WIDTH(16)) register20 (.out(id_ex_imm5_ext_rst), .in(imm5_ext_rst), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush|Halt) & ~StallDMem)));
    register #(.WIDTH(16)) register21 (.out(id_ex_imm8_ext_rst), .in(imm8_ext_rst), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush|Halt) & ~StallDMem)));
    register #(.WIDTH(16)) register22 (.out(id_ex_imm11_sign_ext), .in(imm11_sign_ext), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush|Halt) & ~StallDMem)));
 
    register #(.WIDTH(3)) register23 (.out(id_ex_Write_Register), .in(Write_Register), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush|Halt) & ~StallDMem)));
    register #(.WIDTH(1)) register24 (.out(id_ex_RegWrite), .in(RegWrite), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush|Halt) & ~StallDMem)));
    register #(.WIDTH(16)) register25 (.out(id_ex_PC_Updated), .in(if_id_PC_Updated), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush|Halt) & ~StallDMem)));

    register #(.WIDTH(3)) register26 (.out(id_ex_Rs), .in(Rs), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush|Halt) & ~StallDMem)));
    register #(.WIDTH(3)) register27 (.out(id_ex_Rt), .in(Rt), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush|Halt) & ~StallDMem)));

endmodule