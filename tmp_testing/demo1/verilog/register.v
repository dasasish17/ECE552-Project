module register(out, in, wr_en, clk, rst);
    parameter WIDTH = 16;
    output [WIDTH-1:0] out;
    input [WIDTH-1:0] in;
    input wr_en;
    input clk;
    input rst;

    // Input holder
    wire [15:0] in_holder;

    assign in_holder = wr_en ? in : out; // if wr_en is high, pass in in, else retain out


    dff bits[WIDTH-1:0] (
        .q(out),
        .d(in_holder), // putting in or retaining out based on wr_en
        .clk(clk),
        .rst(rst)
    );//dff_en should instantiate the provided dff.v module


endmodule