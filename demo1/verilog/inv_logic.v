module inv_logic (input [15:0] InA, input [15:0] InB, input invA, input invB, output [15:0] Aout, output [15:0] Bout);
    assign Aout = invA ? ~InA : InA;
    assign Bout = invB ? ~InB : InB;
endmodule
