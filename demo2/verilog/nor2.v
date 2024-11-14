/*
    CS/ECE 552 FALL '22
    Homework #2, Problem 1

    2 input NOR
*/
module nor2 (out,in1,in2);
    output wire out;
    input wire in1,in2;
    assign out = ~(in1 | in2);
endmodule
