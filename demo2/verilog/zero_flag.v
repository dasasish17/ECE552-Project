module zero_flag (input [15:0] Out, output Zero);
    assign Zero = (Out == 16'b0);
endmodule
