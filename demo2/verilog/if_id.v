`default_nettype none

module if_id (instruction, PC_updated, clk, rst, stall, flush, if_id_instruction, if_id_PC_updated);

    parameter INSTRUCTION_SIZE = 16;

    input wire clk, rst, Stall, Flush;
    input wire [INSTRUCTION_SIZE-1:0] instruction, PC_updated;
    output wire [INSTRUCTION_SIZE-1:0] if_id_instruction, if_id_PC_updated;

    wire [INSTRUCTION_SIZE-1:0] inter_instr;

    assign inter_instr = flush ? 16'b0000_1000_0000_0000 : instruction;

    register instr_register (.out(if_id_instruction), .in(inter_instr), .wr_en(~stall), .clk(clk), .rst(rst | flush));
    register pc_update_register (.out(if_id_PC_updated), .in(PC_updated), .wr_en(~stall), .clk(clk), .rst(rst | flush));

endmodule

`default_nettype wire