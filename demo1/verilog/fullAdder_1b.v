/*
    CS/ECE 552 FALL '22
    Homework #2, Problem 1
    
    a 1-bit full adder
*/
module fullAdder_1b(s, c_out, a, b, c_in);
    output s;
    output c_out;
	input  a, b;
    input  c_in;

    // YOUR CODE HERE

    wire S_temp, A_B_out, A_B, B_Cin_out, B_Cin,Cin_A_out,Cin_A; //varible for the ands
    // variables for the oring
    wire out1, out2, first_two;


    // S = A xor B xor Cin

    xor2 ixor (.in1(a), .in2(b), .out(S_temp));
    xor2 ixor2 (.in1(S_temp), .in2(c_in), .out(s));

    //Cout = (A & B) | (B & Cin) | (Cin & A)

    //A & B
    nand2 inand1 (.in1(a), .in2(b), .out(A_B_out));
    not1 inot1 (.in1(A_B_out), .out(A_B));

    //B & Cin
    nand2 inand2 (.in1(b), .in2(c_in), .out(B_Cin_out));
    not1 inot2 (.in1(B_Cin_out), .out(B_Cin));

    //Cin & A
    nand2 inand3 (.in1(c_in), .in2(a), .out(Cin_A_out));
    not1 inot3 (.in1(Cin_A_out), .out(Cin_A));

    //
    nor2 inor1(.in1(A_B), .in2(B_Cin), .out(out1));
    not1 inot4(.in1(out1), .out(first_two));


    nor2 inor2(.in1(first_two), .in2(Cin_A), .out(out2));
    not1 inot5(.in1(out2), .out(c_out));


endmodule
