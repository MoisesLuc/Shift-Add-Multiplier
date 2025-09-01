module ula_8_bits(
    input logic [7:0] b, a,
    input logic [3:0] s,
    input logic m,
    input logic c_in,

    output logic [7:0] f,
    output logic a_eq_b,
    output logic c_out,
    output logic c_ripple
);

logic [3:0] lsb_f, msb_f;     // Variável temporária para captar os resultados das duas ULAs de 4 bits instanciadas
logic lsb_a_eq_b, msb_a_eq_b; // Variável temporária para verificar se A é igual a B nas duas ULAs de 4 bits

assign f = {msb_f, lsb_f};

ula_74181 lsb ( // Instância para captar os 4 bits menos significativos
    .a(a[3:0]),
    .b(b[3:0]),
    .s(s),
    .m(m),
    .c_in(c_in),
    .f(lsb_f),
    .a_eq_b(lsb_a_eq_b),
    .c_out(c_ripple)
);

ula_74181 msb ( // Instância para captar os 4 bits mais significativos
    .a(a[7:4]),
    .b(b[7:4]),
    .s(s),
    .m(m),
    .c_in(c_ripple),
    .f(msb_f),
    .a_eq_b(msb_a_eq_b),
    .c_out(c_out)
);

endmodule