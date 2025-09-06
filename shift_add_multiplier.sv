module shift_add_multiplier (
    input logic clk, rst,
    input logic[7:0] b,
    input logic[7:0] q,

    output logic[15:0] result,
    output logic d_end
);

// Acumulador A
logic [7:0] a;

// Variáveis para controle do Counter
logic [3:0] cycle, data_out;
logic load_counter, en_counter, c_end, up_down;

// Variáveis para controle dos shift registers A, B e Q
logic [1:0] a_ctrl, b_ctrl, q_ctrl;
logic [7:0] a_out, b_out, q_out;
logic a_ser_in, a_ser_out, b_ser_in, b_ser_out, q_ser_out;

// Variáveis de controle para a ULA de 8 BITs
logic [7:0] f;
logic m, s, c_in, a_eq_b, c_out, c_ripple;

typedef enum {idle, ready, verify, add, shift, done} state_type;
state_type state_reg, state_next;

shift_register A (
    .clk(clk),
    .rst(rst),
    .ctrl(a_ctrl),
    .parallel_in(a),
    .ser_in(1'b0),
    .parallel_out(a_out),
    .ser_out(a_ser_out)
);

shift_register B (
    .clk(clk),
    .rst(rst),
    .ctrl(b_ctrl),
    .parallel_in(b),
    .ser_in(b_ser_in),
    .parallel_out(b_out),
    .ser_out(b_ser_out)
);

shift_register Q (
    .clk(clk),
    .rst(rst),
    .ctrl(q_ctrl),
    .parallel_in(q),
    .ser_in(a_out[0]),
    .parallel_out(q_out),
    .ser_out(q_ser_out)
);

counter count (
    .clk(clk),
    .rst(rst),
    .load(load_counter),
    .en(en_counter),
    .up_down(1'b0),
    .data_in(4'b0111),
    .data_out(data_out),
    .c_end(c_end)
);

ula_8_bits operation (
    .a(a_out),
    .b(b_out),
    .s(4'b0001),
    .m(1'b0),
    .f(f),
    .c_in(1'b0),
    .a_eq_b(a_eq_b),
    .c_out(c_out),
    .c_ripple(c_ripple)
);

always_ff @(posedge clk, posedge rst) begin
    if(rst)
        state_reg <= idle;
    else
        state_reg <= state_next;
end

always_comb begin
    a_ctrl = 2'b00;
    b_ctrl = 2'b00;
    q_ctrl = 2'b00;

    a = 8'b00000000;

    load_counter = 0;
    en_counter = 0;

    state_next = state_reg;

    d_end = 0;

    case(state_reg)
        idle: begin
            a_ctrl = 2'b11;
            b_ctrl = 2'b11;
            q_ctrl = 2'b11;
            load_counter = 1;
            state_next = verify;
        end
        verify: begin
            if(q_out[0] == 1)
                state_next = add;
            else
                state_next = shift; 
        end
        add: begin
            a_ctrl = 2'b11;
            a = f;
            state_next = shift;
        end
        shift: begin
            a_ctrl = 2'b01;
            q_ctrl = 2'b01;
            en_counter = 1;

            if(c_end == 0)
                state_next = verify;
            else
                state_next = done;
        end
        done: begin
            d_end = 1;
            state_next = idle;
        end
        default: state_next = idle;
    endcase
end

assign result = {a_out, q_out};
endmodule