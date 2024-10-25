/*
    CS/ECE 552 FALL '22
    Homework #2, Problem 2
    
    A barrel shifter module.  It is designed to shift a number via rotate
    left, shift left, shift right arithmetic, or shift right logical based
    on the 'Oper' value that is passed in.  It uses these
    shifts to shift the value any number of bits.
 */
module shifter (In, ShAmt, Oper, Out);

    // declare constant for size of inputs, outputs, and # bits to shift
    parameter OPERAND_WIDTH = 16;
    parameter SHAMT_WIDTH   =  4;
    parameter NUM_OPERATIONS = 2;

    input  [OPERAND_WIDTH -1:0] In   ; // Input operand
    input  [SHAMT_WIDTH   -1:0] ShAmt; // Amount to shift/rotate
    input  [NUM_OPERATIONS-1:0] Oper ; // Operation type
    output [OPERAND_WIDTH -1:0] Out  ; // Result of shift/rotate

   /* YOUR CODE HERE */
   reg [OPERAND_WIDTH -1:0] stage1, stage2, stage3, stage4;
    reg [OPERAND_WIDTH -1:0] result;
    
    // Stage 1: Shift or rotate by 1 bit
    always @(*) begin
        case (Oper)
            2'b00: stage1 = (ShAmt[0] ? {In[14:0], In[15]} : In);   // Rotate left by 1
            2'b01: stage1 = (ShAmt[0] ? {In[14:0], 1'b0} : In);     // Shift left by 1
            2'b10: stage1 = (ShAmt[0] ? {In[0], In[15:1]} : In);
            //2'b10: stage1 = (ShAmt[0] ? {In[15], In[15:1]} : In);   // Arithmetic shift right by 1
            2'b11: stage1 = (ShAmt[0] ? {1'b0, In[15:1]} : In);     // Logical shift right by 1
            default: stage1 = In;
        endcase
    end

    // Stage 2: Shift or rotate by 2 bits
    always @(*) begin
        case (Oper)
            2'b00: stage2 = (ShAmt[1] ? {stage1[13:0], stage1[15:14]} : stage1); // Rotate left by 2
            2'b01: stage2 = (ShAmt[1] ? {stage1[13:0], 2'b00} : stage1);         // Shift left by 2
            //2'b10: stage2 = (ShAmt[1] ? {{2{stage1[15]}}, stage1[15:2]} : stage1); // Arithmetic shift right by 2
            2'b10: stage2 = (ShAmt[1] ? {stage1[1:0], stage1[15:2]} : stage1);
            2'b11: stage2 = (ShAmt[1] ? {2'b00, stage1[15:2]} : stage1);         // Logical shift right by 2
            default: stage2 = stage1;
        endcase
    end

    // Stage 3: Shift or rotate by 4 bits
    always @(*) begin
        case (Oper)
            2'b00: stage3 = (ShAmt[2] ? {stage2[11:0], stage2[15:12]} : stage2); // Rotate left by 4
            2'b01: stage3 = (ShAmt[2] ? {stage2[11:0], 4'b0000} : stage2);       // Shift left by 4
            2'b10: stage3 = (ShAmt[2] ? {stage2[3:0], stage2[15:4]} : stage2);
            //2'b10: stage3 = (ShAmt[2] ? {{4{stage2[15]}}, stage2[15:4]} : stage2); // Arithmetic shift right by 4
            2'b11: stage3 = (ShAmt[2] ? {4'b0000, stage2[15:4]} : stage2);       // Logical shift right by 4
            default: stage3 = stage2;
        endcase
    end

    // Stage 4: Shift or rotate by 8 bits
    always @(*) begin
        case (Oper)
            2'b00: stage4 = (ShAmt[3] ? {stage3[7:0], stage3[15:8]} : stage3);  // Rotate left by 8
            2'b01: stage4 = (ShAmt[3] ? {stage3[7:0], 8'b00000000} : stage3);   // Shift left by 8
            2'b10: stage4 = (ShAmt[3] ? {stage3[7:0], stage3[15:8]} : stage3);   // ror
            //2'b10: stage4 = (ShAmt[3] ? {{8{stage3[15]}}, stage3[15:8]} : stage3); // Arithmetic shift right by 8
            2'b11: stage4 = (ShAmt[3] ? {8'b00000000, stage3[15:8]} : stage3);  // Logical shift right by 8
            default: stage4 = stage3;
        endcase
    end

    assign Out = stage4;
   
endmodule