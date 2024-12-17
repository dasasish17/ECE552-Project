`default_nettype none

module ex_mem (
    //flops all inputs to mem 
    id_ex_PC_Updated, 
    id_ex_ImmSrc,
    id_ex_Imm8_Ext,
    id_ex_Imm11_Ext,
    aluResult,
    id_ex_memReadorWrite,
    id_ex_memWrite,
    id_ex_memRead,
    id_ex_writeData,
    BrchCnd,
    id_ex_ALU_Jump,
    clk,
    rst,
    Flush,
    id_ex_halt,
    id_ex_MemToReg,
    ex_mem_MemToReg,
    ex_mem_PC_Updated,
    ex_mem_ImmSrc,
    ex_mem_Imm8_Ext,
    ex_mem_Imm11_Ext,
    ex_mem_aluResult,
    ex_mem_memReadorWrite,
    ex_mem_memWrite,
    ex_mem_memRead,
    ex_mem_writeData,
    ex_mem_BrchCnd,
    ex_mem_ALU_Jump,
    ex_mem_halt,
    id_ex_RegWrite,
    ex_mem_RegWrite,
    id_ex_Write_Register,
    ex_mem_Write_Register,
    StallDMem


);
    input wire Flush, StallDMem;
    input wire [15:0] id_ex_PC_Updated;   // PC + offset
    input wire        id_ex_ImmSrc;   // Immediate source control signal
    input wire [15:0] id_ex_Imm8_Ext; // 8-bit Immediate extension
    input wire [15:0] id_ex_Imm11_Ext; // 11-bit Immediate extension
    input wire [15:0] aluResult;        // ALU computation result
    input wire        id_ex_memReadorWrite;
    input wire [1:0] id_ex_MemToReg;
    input wire        id_ex_memRead;    // Memory read enable
    input wire        id_ex_memWrite;   // Memory write enable
    input wire [15:0] id_ex_writeData;
    input wire        BrchCnd;         // Branch condition flag
    input wire        id_ex_ALU_Jump;   // Jump control signal
    input wire        clk;              // Clock signal
    input wire        rst;              // Reset signal
    input wire        id_ex_halt;        // Halt signal
    input wire [2:0]  id_ex_Write_Register;
    input wire        id_ex_RegWrite;

    output wire [1:0] ex_mem_MemToReg;
    output wire [15:0] ex_mem_PC_Updated;   // PC + offset
    output wire        ex_mem_ImmSrc;   // Immediate source control signal
    output wire [15:0] ex_mem_Imm8_Ext; // 8-bit Immediate extension
    output wire [15:0] ex_mem_Imm11_Ext; // 11-bit Immediate extension
    output wire [15:0] ex_mem_aluResult; // ALU computation result
    output wire        ex_mem_memReadorWrite;
    output wire        ex_mem_memRead;    // Memory read enable
    output wire        ex_mem_memWrite;   // Memory write enable
    output wire [15:0] ex_mem_writeData;
    output wire        ex_mem_BrchCnd; // Branch condition flag
    output wire        ex_mem_ALU_Jump;   // Jump control signal
    output wire        ex_mem_halt;
    output wire [2:0]  ex_mem_Write_Register;
    output wire        ex_mem_RegWrite;

    //module register(out, in, wr_en, clk, rst);
    //rst|((Flush|Halt) & ~StallDMem)
    register #(.WIDTH(16)) register0 (.out(ex_mem_PC_Updated), .in(id_ex_PC_Updated), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush | id_ex_halt) & ~StallDMem)));
    register #(.WIDTH(1)) register1 (.out(ex_mem_ImmSrc), .in(id_ex_ImmSrc), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush | id_ex_halt) & ~StallDMem)));
    register #(.WIDTH(16)) register2 (.out(ex_mem_Imm8_Ext), .in(id_ex_Imm8_Ext), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush | id_ex_halt) & ~StallDMem)));
    register #(.WIDTH(16)) register3 (.out(ex_mem_Imm11_Ext), .in(id_ex_Imm11_Ext), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush | id_ex_halt) & ~StallDMem)));
    register #(.WIDTH(16)) register4 (.out(ex_mem_aluResult), .in(aluResult), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush | id_ex_halt) & ~StallDMem)));
    register #(.WIDTH(1)) register5 (.out(ex_mem_memReadorWrite), .in(id_ex_memReadorWrite), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush | id_ex_halt) & ~StallDMem)));
    register #(.WIDTH(1)) register6 (.out(ex_mem_memRead), .in(id_ex_memRead), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush | id_ex_halt) & ~StallDMem)));
    register #(.WIDTH(1)) register7 (.out(ex_mem_memWrite), .in(id_ex_memWrite), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush | id_ex_halt) & ~StallDMem)));
    register #(.WIDTH(1)) register8 (.out(ex_mem_BrchCnd), .in(BrchCnd), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush | id_ex_halt) & ~StallDMem)));
    register #(.WIDTH(1)) register9 (.out(ex_mem_ALU_Jump), .in(id_ex_ALU_Jump), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush | id_ex_halt) & ~StallDMem)));
    register #(.WIDTH(16)) register10 (.out(ex_mem_writeData), .in(id_ex_writeData), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush | id_ex_halt) & ~StallDMem))); //read2Data
    register #(.WIDTH(1)) register11 (.out(ex_mem_halt), .in(id_ex_halt), .wr_en(~StallDMem), .clk(clk), .rst(rst|(Flush & ~StallDMem)));
    register #(.WIDTH(3)) register12 (.out(ex_mem_Write_Register), .in(id_ex_Write_Register), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush | id_ex_halt) & ~StallDMem)));
    register #(.WIDTH(1)) register13 (.out(ex_mem_RegWrite), .in(id_ex_RegWrite), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush | id_ex_halt) & ~StallDMem))); //data to register
    register #(.WIDTH(2)) register14 (.out(ex_mem_MemToReg), .in(id_ex_MemToReg), .wr_en(~StallDMem), .clk(clk), .rst(rst|((Flush | id_ex_halt) & ~StallDMem))); //data to register


endmodule