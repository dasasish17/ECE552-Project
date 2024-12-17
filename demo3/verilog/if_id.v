`default_nettype none

module if_id (instruction, PC_updated, clk, rst, if_id_instruction, if_id_PC_Updated, flush, stall, StallDMem);

    parameter INSTRUCTION_SIZE = 16;

    input wire clk, rst, stall, flush, StallDMem;
    input wire [INSTRUCTION_SIZE-1:0] instruction, PC_updated;
    output wire [INSTRUCTION_SIZE-1:0] if_id_instruction, if_id_PC_Updated;

    wire [INSTRUCTION_SIZE-1:0] inter_instr;

    assign inter_instr = flush ? 16'b0000_1000_0000_0000 : instruction;

    register instr_register (.out(if_id_instruction), .in(inter_instr), .wr_en(~stall & ~StallDMem), .clk(clk), .rst(1'b0));
    register pc_update_register (.out(if_id_PC_Updated), .in(PC_updated), .wr_en(~stall & ~StallDMem), .clk(clk), .rst(rst | (flush & ~StallDMem)));

endmodule

`default_nettype wire