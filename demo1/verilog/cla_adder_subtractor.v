module cla_adder_subtractor (
    input [15:0] InA, 
    input [15:0] InB, 
    input Cin, 
    input sign, 
    output [15:0] Out, 
    output Ofl,
    output c_out
);
    // Perform addition/subtraction with signed or unsigned behavior
    wire [15:0] sum;
    wire carry_out;
    wire signed_overflow;
    
    // Perform the addition or subtraction based on the Cin
    // Use the CLA from Problem 1 here
    cla_16b adder(.a(InA), .b(InB), .c_in(Cin), .sum(sum), .c_out(carry_out));
    
    // Overflow detection logic for signed/unsigned numbers
    assign signed_overflow = (InA[15] == InB[15]) & (InA[15] != sum[15]);
    assign Ofl = sign ? signed_overflow : carry_out;
    
    assign Out = sum;
    assign c_out = carry_out;
endmodule
