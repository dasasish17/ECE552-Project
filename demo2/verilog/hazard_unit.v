`default_nettype none

module hazard_unit(instruction, id_ex_reg_write, ex_mem_reg_write, id_ex_reg_dst, ex_mem_reg_dst, potRAW, stall, potRAW);

parameter OPERAND_WIDTH = 16;

input wire [OPERAND_WIDTH-1:0] instruction;
input wire [2:0] id_ex_reg_dst;
input wire [2:0] ex_mem_reg_dst;
input wire id_ex_reg_write, ex_mem_reg_write;
output wire stall;
input wire potRAW;

assign stall = ((instruction[10:8] == id_ex_reg_dst) & id_ex_reg_write & potRAW) |
        ((instruction[7:5] == id_ex_reg_dst) & id_ex_reg_write & potRAW) |
        ((instruction[10:8] == ex_mem_reg_dst) & ex_mem_reg_write & potRAW) |
        ((instruction[7:5] == ex_mem_reg_dst) & ex_mem_reg_write & potRAW);

endmodule
`default_nettype wire