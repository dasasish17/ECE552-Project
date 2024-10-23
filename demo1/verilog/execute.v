/*
   CS/ECE 552 Spring '22
  
   Filename        : execute.v
   Description     : This is the overall module for the execute stage of the processor.
*/
`default_nettype none
module execute (read1Data, read2Data, PC_incr, signExtendedIns10, signExtendedImm, zeroExtendedImm,
                                 AluSrc1, AluSrc2,
                                 Oper,
                                 AluCin, InvA, InvB, Beq, Bne, Blt, Bgt, ALUJump, Zero, Neg,
                                 nextPC, AluRes, err);


   // TODO: Your code here
   parameter OPERAND_WIDTH = 16;
   input wire [OPERAND_WIDTH-1:0] read1Data, read2Data, PC_incr, imm5_ext_rst, imm8_ext_rst, imm11_sign_ext;
   input wire [1:0]AluSrc1, AluSrc2;
   input wire [3:0] Oper;
   input wire Cin, InvA, InvB, Beq, Bne, Blt, Bgt, Zero, Neg, Ofl, Cout;
   output wire BrnchCnd, Out;
   output wire err;

   // HALT not implemented in ALU yet

   wire [OPERAND_WIDTH-1:0] InA, InB;

   // Mux for InA
   assign InA = (AluSrc1 == 2'b00) ? read1Data :
                  (AluSrc1 == 2'b01) ? 16'b0 :
                  (read1Data << 3); // else (AluSrc1 == 2'b10) ?


   // Mux for InB
     assign InA = (AluSrc2 == 2'b00) ? read2Data :
                     (AluSrc2 == 2'b01) ? imm5_ext_rst :
                     (AluSrc2 == 2'b10) ? imm8_ext_rst : 16'b0;


   // Instantiate the ALU module
   alu #(
       .OPERAND_WIDTH(OPERAND_WIDTH),
       .NUM_OPERATIONS(NUM_OPERATIONS)
   ) alu_inst (
       .InA(InA),
       .InB(InB),
       .Cin(Cin),
       .Oper(Oper),
       .invA(InvA),
       .invB(InvB),
       .sign(1'b1),
       .Out(Out),
       .Ofl(Ofl),
       .Zero(Zero),
       .Cout(Cout),
       .Neg(Neg));

//    assign BrnchCnd = (Oper == 1101)? 1'b1: 1'b0;
//    assign BrnchCnd = (Beq && Zero) | (Bne && ~Zero) | (Blt && Neg) | (Bgt && ~Neg);

    assign BrnchCnd = (Oper == 1101)? 1'b1:
                      (Oper == 0100)? ((Beq && Zero) | (Bne && ~Zero) | (Blt && Neg) | (Bgt && ~Neg)): 1'b0;

   
endmodule
`default_nettype wire
