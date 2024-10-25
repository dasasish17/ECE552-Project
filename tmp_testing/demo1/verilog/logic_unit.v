module logic_unit (input [15:0] InA, input [15:0] InB, input [2:0] Oper, output [15:0] Out);
    reg [15:0] result;
    always @(*) begin
        case (Oper)
            3'b101: result = InA & InB; // AND
            3'b110: result = InA | InB; // OR
            3'b111: result = InA ^ InB; // XOR
            default: result = 16'b0;
        endcase
    end
    assign Out = result;
endmodule
