`default_nettype none


module mem_wb (
    Read_Data,
    ex_mem_ALU_Result,
    ex_mem_MemToReg,
    ex_mem_PC_address,
    ex_mem_halt,
    clk,
    rst,
    mem_wb_Read_Data,
    mem_wb_ALU_Result,
    mem_wb_MemToReg,
    mem_wb_PC_address,
    mem_wb_halt,
);

    input wire [15:0] ex_mem_PC_Updated;
    input wire [15:0] Read_Data;
    input wire [15:0] ex_mem_ALU_Result;
    input wire [1:0] ex_mem_MemToReg;
    input wire ex_mem_halt;
    input wire [2:0]  ex_mem_Write_Register;
    input wire        ex_mem_RegWrite;
    input clk;
    input rst;
    output wire [15:0] mem_wb_PC_Updated;
    output wire [15:0] mem_wb_ Read_Data;
    output wire [15:0] mem_wb_ALU_Result;
    output wire [1:0] mem_wb_MemToReg;
    output wire mem_wb_halt;
    output wire [2:0]  mem_wb_Write_Register;
    output wire        mem_wb_RegWrite;

   //module register(out, in, wr_en, clk, rst);
    register register0 (.out(mem_wb_PC_Updated), .in(ex_mem_PC_Updated), .wr_en(1'b1), .clk(clk), .rst(rst));
    register register1 (.out(mem_wb_Read_Data), .in(Read_Data), .wr_en(1'b1), .clk(clk), .rst(rst));
    register register2 (.out(mem_wb_ALU_Result), .in(ex_mem_ALU_Result), .wr_en(1'b1), .clk(clk), .rst(rst));
    register register3 (.out(mem_wb_MemToReg), .in(ex_mem_MemToReg), .wr_en(1'b1), .clk(clk), .rst(rst));
    register register4 (.out(mem_wb_halt), .in(ex_mem_halt), .wr_en(1'b1), .clk(clk), .rst(rst));
    register register5 (.out(mem_wb_Write_Register), .in(ex_mem_Write_Register), .wr_en(1'b1), .clk(clk), .rst(rst));
    register register6 (.out(mem_wb_RegWrite), .in(ex_mem_RegWrite), .wr_en(1'b1), .clk(clk), .rst(rst));
   
endmodule

