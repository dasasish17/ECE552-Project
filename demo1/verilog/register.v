module register #(parameter WIDTH = 16) (clk, rst, data_in, data_out, write_en, err);
    input wire clk, rst, write_en;
    input wire [WIDTH-1:0]data_in;
    output wire [WIDTH-1:0]data_out;
    output wire err;

    wire [WIDTH-1:0] d;

    assign d = (write_en) ? data_in : data_out;

    dff DFF[WIDTH-1:0](.clk(clk), .rst(rst), .d(d), .q(data_out));

    assign err = 1'b0;
    //assign err = (^write_en === 1'bx) | (^data_in === 1'bx) | (^clk === 1'bx) | (^rst === 1'bx) |
    //             (^write_en === 1'bz) | (^data_in === 1'bz) | (^clk === 1'bz) | (^rst === 1'bz);

endmodule