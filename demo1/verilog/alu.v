/*
    CS/ECE 552 FALL '22
    Homework #2, Problem 3

    A multi-bit ALU module (defaults to 16-bit). It is designed to choose
    the correct operation to perform on 2 multi-bit numbers from rotate
    left, shift left, shift right arithmetic, shift right logical, add,
    or, xor, & and.  Upon doing this, it should output the multi-bit result
    of the operation, as well as drive the output signals Zero and Overflow
    (OFL).
*/
//`default_nettype none
module alu (InA, InB, Cin, Oper, invA, invB, sign, Out, Zero, Ofl, Cout, Neg, err);

    parameter OPERAND_WIDTH = 16;    
    parameter NUM_OPERATIONS = 4;
       
    input  [OPERAND_WIDTH -1:0] InA ; // Input operand A
    input  [OPERAND_WIDTH -1:0] InB ; // Input operand B
    input                       Cin ; // Carry in
    input  [NUM_OPERATIONS-1:0] Oper; // Operation type
    input                       invA; // Signal to invert A
    input                       invB; // Signal to invert B
    input                       sign; // Signal for signed operation
    output reg [OPERAND_WIDTH -1:0] Out ; // Result of computation
    output                      Ofl ; // Signal if overflow occured
    output                      Zero; // Signal if Out is 0
    output wire                     Cout; // Carry out
    output wire                     Neg; // Sign flag
    output wire                      err;

    /* YOUR CODE HERE */

    wire [15:0] Aout, Bout;        // After inversion
    wire [15:0] add_out, shift_out, logic_out;
    wire alu_ofl, zero_flag, carryout, sco_out;
    reg setOut;
    wire [OPERAND_WIDTH-1:0] bitReverse, slbiOut;

    // 1. Inversion Logic
    inv_logic invert(.InA(InA), .InB(InB), .invA(invA), .invB(invB), .Aout(Aout), .Bout(Bout));

    // 2. Arithmetic Unit (for ADD and subtraction)
    cla_adder_subtractor arithmetic(.InA(Aout), .InB(Bout), .Cin(Cin), .sign(sign), .Out(add_out), .Ofl(alu_ofl), .c_out(carryout));

    // 3. Barrel Shifter
    shifter shift(.In(Aout), .ShAmt(Bout[3:0]), .Oper(Oper[1:0]), .Out(shift_out));

    // 4. Logic Unit
    logic_unit logic(.InA(Aout), .InB(Bout), .Oper(Oper[2:0]), .Out(logic_out));

    // 5. Zero Detection
    zero_flag zf(.Out(add_out), .Zero(zero_flag));
    assign Zero = zero_flag;

    assign Neg = add_out[OPERAND_WIDTH-1];

    //Other functions
    // Bit reversal operation
    assign bitReverse = {InA[0], InA[1], InA[2], InA[3], InA[4], InA[5], InA[6], InA[7],
                         InA[8], InA[9], InA[10], InA[11], InA[12], InA[13], InA[14], InA[15]};

    assign slbiOut = Aout | Bout;

    assign sco_out = carryout? 1'b1: 1'b0;

    // Comparison logic for SEQ, SLT, SLE based on Oper
        always @(*) begin
            case (Oper)
                4'b1001: setOut = Zero;       // SEQ: Rs == Rt
                4'b1010: setOut = Neg;        // SLT: Rs < Rt
                4'b1100: setOut = Zero | Neg; // SLE: Rs <= Rt
                default: setOut = 1'b0;       // Default case
            endcase
        end

    assign err = 1'b0;

    // Overflow is only relevant for ADD operations
    assign Ofl = (Oper == 3'b100) ? alu_ofl : 1'b0;
    assign Cout = carryout;
     always @(*) begin
        //err = 1'b0;
            case (Oper[3:0])
                4'b0000, 4'b0001, 4'b0010, 4'b0011: Out = shift_out;  // Shift or rotate
                4'b0100: Out = add_out;  // ADD
                4'b1001, 4'b1010, 4'b1100: Out = {15'b0, setOut};  // SEQ, SLT, SLE
                4'b1111: Out = bitReverse;  // Bit reversal (1111)
                4'b1011: Out = {15'b0, sco_out};
                4'b0101, 4'b1110, 4'b0111: Out = logic_out;  // AND, OR, XOR
                default: begin
                Out = 16'b0;
                //err = 1'b1;
                end  // Default output
            endcase
        end
    
endmodule
