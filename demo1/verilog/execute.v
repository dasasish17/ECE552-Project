/*
   CS/ECE 552 Spring '22
  
   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
`default_nettype none
module execute (read1Data, read2Data, imm5_ext_rst, imm8_ext_rst, imm11_sign_ext,
                AluSrc1, AluSrc2, Oper, AluCin, InvA, InvB, Beq, Bne, Blt, Bgt,
                AluRes, err, BrnchCnd);


   // TODO: Your code here
   parameter OPERAND_WIDTH = 16;
   input wire [OPERAND_WIDTH-1:0] read1Data, read2Data, imm5_ext_rst, imm8_ext_rst, imm11_sign_ext;
   input wire [1:0]AluSrc1, AluSrc2;
   input wire [3:0] Oper;
   input wire AluCin, InvA, InvB, Beq, Bne, Blt, Bgt;
   output wire BrnchCnd,
   output wire [15:0] AluRes;
   output wire err;

   wire Zero, Neg, Ofl, Cout;

   // HALT not implemented in ALU yet

   wire [OPERAND_WIDTH-1:0] InA, InB;

   // Mux for InA
   assign InA = (AluSrc1 == 2'b00) ? read1Data :
                (AluSrc1 == 2'b01) ? 16'b0 :
                (read1Data << 3); // else (AluSrc1 == 2'b10) ?


   // Mux for InB
     assign InB = (AluSrc2 == 2'b00) ? read2Data :
                     (AluSrc2 == 2'b01) ? imm5_ext_rst :
                     (AluSrc2 == 2'b10) ? imm8_ext_rst : 16'b0;


   // Instantiate the ALU module
   alu alu_inst (
       .InA(InA),
       .InB(InB),
       .Cin(AluCin),
       .Oper(Oper),
       .invA(InvA),
       .invB(InvB),
       .sign(1'b1),
       .Out(AluRes),
       .Ofl(Ofl),
       .Zero(Zero),
       .Cout(Cout),
       .Neg(Neg),
       .err(err));

    // j, jal, branch
    assign BrnchCnd = (Oper == 4'b1101) ? 1'b1 :
                      (Oper == 4'b0100) ? ((Beq && Zero) | (Bne && ~Zero) | (Blt && Neg) | (Bgt && ~Neg)) : 1'b0;

   
endmodule
`default_nettype wire
