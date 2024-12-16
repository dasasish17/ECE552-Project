/*
    CS/ECE 552 FALL '22
    Homework #2, Problem 1
    
    a 16-bit CLA module
*/
module cla_16b(sum, c_out, a, b, c_in);

    // declare constant for size of inputs, outputs (N)
    parameter   N = 16;

    output [N-1:0] sum;
    output         c_out;
    input [N-1: 0] a, b;
    input          c_in;

    // YOUR CODE HERE

    wire [15:0] p, g;      // Propagate and generate signals for all 16 bits
    wire [15:1] c;         // Carry signals for internal bits

    // Step 1: Generate and propagate signals for all bits
    assign p = a ^ b;      // Propagate: Pi = Ai ^ Bi
    assign g = a & b;      // Generate: Gi = Ai & Bi

    // Step 2: Carry Lookahead Logic
    assign c[1]  = g[0]  | (p[0]  & c_in);
    assign c[2]  = g[1]  | (p[1]  & c[1]);
    assign c[3]  = g[2]  | (p[2]  & c[2]);
    assign c[4]  = g[3]  | (p[3]  & c[3]);
    assign c[5]  = g[4]  | (p[4]  & c[4]);
    assign c[6]  = g[5]  | (p[5]  & c[5]);
    assign c[7]  = g[6]  | (p[6]  & c[6]);
    assign c[8]  = g[7]  | (p[7]  & c[7]);
    assign c[9]  = g[8]  | (p[8]  & c[8]);
    assign c[10] = g[9]  | (p[9]  & c[9]);
    assign c[11] = g[10] | (p[10] & c[10]);
    assign c[12] = g[11] | (p[11] & c[11]);
    assign c[13] = g[12] | (p[12] & c[12]);
    assign c[14] = g[13] | (p[13] & c[13]);
    assign c[15] = g[14] | (p[14] & c[14]);
    assign c_out = g[15] | (p[15] & c[15]);

    // Step 3: Use the 4-bit CLA modules for sum computation
    
    cla_4b cla0 (
        .a(a[3:0]),        // Lower 4 bits of a
        .b(b[3:0]),        // Lower 4 bits of b
        .c_in(c_in),       // Carry-in from input
        .sum(sum[3:0]),    // Lower 4 bits of sum
        .c_out()           // Carry-out is ignored here (handled in carry logic)
    );

    cla_4b cla1 (
        .a(a[7:4]),        // Bits 4-7 of a
        .b(b[7:4]),        // Bits 4-7 of b
        .c_in(c[4]),       // Carry-in from CLA0
        .sum(sum[7:4]),    // Bits 4-7 of sum
        .c_out()           // Carry-out is ignored here (handled in carry logic)
    );

    cla_4b cla2 (
        .a(a[11:8]),       // Bits 8-11 of a
        .b(b[11:8]),       // Bits 8-11 of b
        .c_in(c[8]),       // Carry-in from CLA1
        .sum(sum[11:8]),   // Bits 8-11 of sum
        .c_out()           // Carry-out is ignored here (handled in carry logic)
    );

    cla_4b cla3 (
        .a(a[15:12]),      // Bits 12-15 of a
        .b(b[15:12]),      // Bits 12-15 of b
        .c_in(c[12]),      // Carry-in from CLA2
        .sum(sum[15:12]),  // Bits 12-15 of sum
        .c_out()           // Carry-out is ignored here (handled in carry logic)
    );

endmodule
