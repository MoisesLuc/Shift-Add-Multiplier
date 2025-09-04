module shift_add_multiplier #(parameter N=8) (
    input logic clk, rst,
    input logic[7:0] a,
    input logic[7:0] b,

    output logic[15:0] result,
    output logic d_end
);

logic load, en, c_end, data_out, up_down, cycle;

logic [1:0] a_ctrl, b_ctrl, q_ctrl;
logic [7:0] a_out, b_out, q_out;
logic a_ser_in, a_ser_out, b_ser_in, b_ser_out, q_ser_in, q_ser_out;

logic [7:0] f;
assign s = 1;
assign m = 4'b1011;
logic c_in, a_eq_b, c_out, c_ripple;

shift_register A (
    .clk(clk),
    .rst(rst),
    .ctrl(a_ctrl),
    .parallel_in(a),
    .ser_in(a_ser_in),
    .parallel_out(a_prll_out),
    .ser_out(a_ser_out),
);

shift_register B (
    .clk(clk),
    .rst(rst),
    .ctrl(b_ctrl),
    .parallel_in(b),
    .ser_in(b_ser_in),
    .parallel_out(b_prll_out),
    .ser_out(b_ser_out),
);

shift_register Q (
    .clk(clk),
    .rst(rst),
    .ctrl(q_ctrl),
    .parallel_in(q),
    .ser_in(q_ser_in),
    .parallel_out(q_prll_out),
    .ser_out(q_ser_out),
);

counter count (
    .clk(clk),
    .rst(rst),
    .load(load),
    .en(en),
    .up_down(up_down),
    .data_in(cycle),
    .data_out(data_out),
    .c_end(d_end),
);

ula op (
    .a(a),
    .b(b),

);

endmodule