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
module alu (InA, InB, Cin, Oper, invA, invB, sign, Out, Zero, Ofl);

    parameter OPERAND_WIDTH = 16;    
    parameter NUM_OPERATIONS = 3;
       
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

    /* YOUR CODE HERE */

    wire [15:0] Aout, Bout;        // After inversion
    wire [15:0] alu_out, shift_out, logic_out;
    wire alu_ofl, zero_flag;

    // 1. Inversion Logic
    inv_logic invert(.InA(InA), .InB(InB), .invA(invA), .invB(invB), .Aout(Aout), .Bout(Bout));

    // 2. Arithmetic Unit (for ADD and subtraction)
    cla_adder_subtractor arithmetic(.InA(Aout), .InB(Bout), .Cin(Cin), .sign(sign), .Out(alu_out), .Ofl(alu_ofl));

    // 3. Barrel Shifter
    shifter shift(.In(Aout), .ShAmt(Bout[3:0]), .Oper(Oper[1:0]), .Out(shift_out));

    // 4. Logic Unit
    logic_unit logic(.InA(Aout), .InB(Bout), .Oper(Oper), .Out(logic_out));

    // 5. Zero Detection
    zero_flag zf(.Out(Out), .Zero(zero_flag));

    // Output MUX based on Oper
    always @(*) begin
        case (Oper)
            3'b000, 3'b001, 3'b010, 3'b011: Out = shift_out;  // Shift or rotate
            3'b100: Out = alu_out;  // ADD
            3'b101, 3'b110, 3'b111: Out = logic_out;  // AND, OR, XOR
            default: Out = 16'b0;
        endcase
    end

    // Overflow is only relevant for ADD operations
    assign Ofl = (Oper == 3'b100) ? alu_ofl : 1'b0;
    assign Zero = zero_flag;
    
endmodule
