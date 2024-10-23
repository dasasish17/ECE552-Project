/*
    CS/ECE 552 FALL'22
    Homework #2, Problem 1
    
    a 4-bit CLA module
*/
module cla_4b(sum, c_out, a, b, c_in); // hi

    // declare constant for size of inputs, outputs (N)
    parameter   N = 4;

    output [N-1:0] sum;
    output         c_out;
    input [N-1: 0] a, b;
    input          c_in;

    // YOUR CODE HERE

    wire [3:0] g, p;   
    wire [3:1] c;      

    assign g = a & b;  // Generate: Gi = Ai & Bi
    assign p = a ^ b;  // Propagate: Pi = Ai ^ Bi

    // Carry lookahead logic
    assign c[1] = g[0] | (p[0] & c_in);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c_out = g[3] | (p[3] & c[3]);

    fullAdder_1b fa0 (.s(sum[0]), .c_out(), .a(a[0]), .b(b[0]), .c_in(c_in));
    fullAdder_1b fa1 (.s(sum[1]), .c_out(), .a(a[1]), .b(b[1]), .c_in(c[1]));
    fullAdder_1b fa2 (.s(sum[2]), .c_out(), .a(a[2]), .b(b[2]), .c_in(c[2]));
    fullAdder_1b fa3 (.s(sum[3]), .c_out(), .a(a[3]), .b(b[3]), .c_in(c[3]));

endmodule
