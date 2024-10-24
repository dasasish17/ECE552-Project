/*
   CS/ECE 552 Spring '22
  
   Filename        : decode.v
   Description     : This is the module for the overall decode stage of the processor.
*/
`default_nettype none
module decode (
    clk,           // Clock signal
    rst,           // Reset signal
    instruction,   // Instruction input
    Write_Data,    // Data to write
    ImmSrc,        // Immediate source control signal
    MemEnable,       // Memory read control signal
    MemWrite,      // Memory write control signal
    ALU_jump,      // ALU jump control signal
    InvA,          // Invert A control signal
    InvB,          // Invert B control signal
    Cin,           // Carry input control signal
    Beq,           // Branch if equal control signal
    Bne,           // Branch if not equal control signal
    Blt,           // Branch if less than control signal
    Bgt,           // Branch if greater than control signal
    Halt,          // Halt control signal
    MemToReg,      // Memory to register control signal
    ALUSrc1,       // ALU source 1 control signal
    ALUSrc2,       // ALU source 2 control signal
    ALU_op,        // ALU operation control signal
    err,           // Error signal
    read_Data1,    // Read data output 1
    read_Data2,    // Read data output 2
    imm5_ext_rst,  // 5-bit immediate extended output
    imm8_ext_rst,  // 8-bit immediate extended output
    imm11_sign_ext  // 11-bit immediate signed extended output
);

   input wire clk;
   input wire rst;
   input wire [15:0] instruction;
   input wire [15:0] Write_Data;

   output wire [15:0] read_Data1;
   output wire [15:0] read_Data2;

   output reg ImmSrc;

   output reg MemEnable;
   output reg MemWrite;

   output reg ALU_jump;

   output reg InvA;
   output reg InvB;
   output reg Cin;

   output reg Beq;
   output reg Bne;
   output reg Blt;
   output reg Bgt;

   output reg Halt;
   output wire err;

   output reg [1:0] MemToReg;
   output reg [1:0] ALUSrc1;
   output reg [1:0] ALUSrc2;
   output reg [3:0] ALU_op;

   output wire [15:0]imm5_ext_rst;
   output wire [15:0]imm8_ext_rst;
   output wire [15:0]imm11_sign_ext;

   wire [15:0] imm5_sign_ext;
   wire [15:0] imm5_zero_ext;
   wire [15:0] imm8_sign_ext;
   wire [15:0] imm8_zero_ext;
   // wire [10:0] imm11_sign_ext;

   // signals out of control
   wire zeroExt;
   wire [2:0] Write_Register;
   wire [1:0] RegDst;
   wire RegWrite;
   wire reg_err;
   wire ctrl_err;

  wire [15:0] imm5;
  wire [15:0] imm8;
  wire [15:0] imm11;

   control ctrl_inst (
        .Opcode(instruction[15:11]),
        .Func(instruction[1:0]),
        .err(ctrl_err),
        .zeroExt(zeroExt),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .MemEnable(MemEnable),
        .MemWrite(MemWrite),
        .ALU_jump(ALU_jump),
        .InvA(InvA),
        .InvB(InvB),
        .Cin(Cin),
        .Beq(Beq),
        .Bne(Bne),
        .Blt(Blt), // Fixed variable name
        .Bgt(Bgt),
        .Halt(Halt),
        .RegDst(RegDst),
        .MemtoReg(MemToReg), // Fixed variable name
        .ALUSrc1(ALUSrc1),
        .ALUSrc2(ALUSrc2),
        .ALU_op(ALU_op)
    );

   assign imm5 = instruction[4:0];
   assign imm8 = instruction[7:0];
   assign imm11 = instruction[10:0];

   // The immediate extend part 
   assign imm5_sign_ext = {{11{imm5[4]}}, imm5};
   assign imm5_zero_ext = {11'b0, imm5};

   assign imm8_sign_ext = {{8{imm8[7]}}, imm8};
   assign imm8_zero_ext = {8'b0, imm8};

   assign imm11_sign_ext = {{5{imm11[10]}}, imm11};

   // Zero extension mux 
   assign imm5_ext_rst = zeroExt ? imm5_zero_ext : imm5_sign_ext;
   assign imm8_ext_rst = zeroExt ? imm8_zero_ext : imm8_sign_ext;

   // Corrected Write_Register assignment
   assign Write_Register = (RegDst == 2'b00) ? instruction[7:5] :
                           (RegDst == 2'b01) ? instruction[10:8] :
                           (RegDst == 2'b10) ? instruction[4:2] : 
                           3'b111; // Default case

   // Register file instantiation
   regFile regFile0 (
       .read1Data(read_Data1),
       .read2Data(read_Data2),
       .err(reg_err),
       .clk(clk),
       .rst(rst),
       .read1RegSel(instruction[10:8]),
       .read2RegSel(instruction[7:5]),
       .writeRegSel(Write_Register),
       .writeData(Write_Data),
       .writeEn(RegWrite)
   );

   assign err = reg_err | ctrl_err; // assigning err

endmodule
`default_nettype wire
