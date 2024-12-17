`default_nettype none

// module hazard_unit(instruction, id_ex_reg_write, ex_mem_reg_write, id_ex_reg_dst, ex_mem_reg_dst, potRAW_R, potRAW_I, stall);

module hazard_unit(instruction, id_ex_reg_dst, ex_mem_reg_dst, mem_wb_reg_dst, id_ex_Rs, id_ex_Rt, 
                   id_ex_regWrite, ex_mem_regWrite, mem_wb_regWrite, id_ex_memRead, ex_mem_memRead, 
                   stall, ex_ex_Rs_fwd, ex_ex_Rt_fwd, mem_ex_Rs_fwd, mem_ex_Rt_fwd);

parameter OPERAND_WIDTH = 16;

input wire [OPERAND_WIDTH-1:0] instruction;

input wire [2:0] id_ex_reg_dst, ex_mem_reg_dst, mem_wb_reg_dst; // write register
input wire [2:0] id_ex_Rs, id_ex_Rt;
// input wire id_ex_reg_write, ex_mem_reg_write;
// input wire potRAW_I, potRAW_R;
input wire id_ex_regWrite, ex_mem_regWrite, mem_wb_regWrite;
input wire id_ex_memRead, ex_mem_memRead;

output wire stall;
output wire ex_ex_Rs_fwd, ex_ex_Rt_fwd, mem_ex_Rs_fwd, mem_ex_Rt_fwd;

// stall logic 
assign stall = ((instruction[10:8] == id_ex_reg_dst) & id_ex_regWrite & id_ex_memRead) |
               ((instruction[7:5] == id_ex_reg_dst) & id_ex_regWrite & id_ex_memRead);

// forwarding logic
// ex_mem_Rs
assign ex_ex_Rs_fwd = (ex_mem_regWrite & (ex_mem_reg_dst == id_ex_Rs) & !(ex_mem_memRead));
// ex_mem_Rt
assign ex_ex_Rt_fwd = (ex_mem_regWrite & (ex_mem_reg_dst == id_ex_Rt) & !(ex_mem_memRead));
// mem_wb_Rs
assign mem_ex_Rs_fwd = (mem_wb_regWrite & (mem_wb_reg_dst == id_ex_Rs));
// mem_wb_Rt
assign mem_ex_Rt_fwd = (mem_wb_regWrite & (mem_wb_reg_dst == id_ex_Rt));



endmodule
`default_nettype wire