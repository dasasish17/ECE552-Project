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
   input wire [OPERAND_WIDTH-1:0] read1Data, read2Data, PC_incr, signExtendedIns10, signExtendedImm, zeroExtendedImm;
   input wire [1:0] AluSrc1, AluSrc2;
   input wire [3:0] Oper;
   input wire Cin, InvA, InvB, Beq, Bne, Blt, Bgt, Zero, Neg, Ofl, Cout;
   output wire [OPERAND_WIDTH-1:0] nextPC, Out;
   output wire err;


   // Instantiate the ALU module
       alu #(
           .OPERAND_WIDTH(OPERAND_WIDTH),
           .NUM_OPERATIONS(NUM_OPERATIONS)
       ) alu_inst (
           .InA(read1Data),
           .InB(read2Data),
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


   
endmodule
`default_nettype wire
