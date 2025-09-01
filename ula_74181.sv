module ula_74181(
    input logic[3:0] b, a,
    input logic[3:0] s,
    input logic m,
    input logic c_in,

    output logic[3:0] f,
    output logic a_eq_b,
    output logic c_out
);

assign a_eq_b = (a == b) ? 1'b1 : 1'b0; // Verificando se A é igual a B
logic [4:0] result;                     // Variável temporária de 5 bits para capturar o carry out

always_comb begin
    case(m)
        1: begin // Operações lógicas
            case(s)
                4'b0000: f = ~a;
                4'b0001: f = ~(a | b);
                4'b0010: f = ~a & b;
                4'b0011: f = 4'b0000;
                4'b0100: f = ~(a & b);
                4'b0101: f = ~b;
                4'b0110: f = a ^ b;
                4'b0111: f = a & ~b;
                4'b1000: f = ~a | b;
                4'b1001: f = ~(a ^ b);
                4'b1010: f = b;
                4'b1011: f = a & b;
                4'b1100: f = 4'b0001;
                4'b1101: f = a | ~b;
                4'b1110: f = a | b;
                4'b1111: f = a;     
            endcase
        end
        0: begin // Operações aritméticas
            case(s) 
                4'b0000: result = a;
                4'b0001: result = a + b;
                4'b0010: result = a + ~b;
                4'b0011: result = -4'b0001;
                4'b0100: result = a + (a & ~b);
                4'b0101: result = (a | b) + (a & ~b);
                4'b0110: result = a - b - 1;
                4'b0111: result = (a & ~b) - 1;
                4'b1000: result = a + (a & b);
                4'b1001: result = a + b;
                4'b1010: result = (a | ~b) + (a & b);
                4'b1011: result = (a & b) - 1;
                4'b1100: result = a + (a << 1);
                4'b1101: result = (a | b) + a;
                4'b1110: result = (a | ~b) + a;
                4'b1111: result = a - 1;
            endcase

            case(~c_in) // Soma o carry-in ao resultado
                1'b0: result = result + 1;
                default: result = result;
            endcase
            
            f = result[3:0];
            c_out = result[4];
        end
    endcase
end

endmodule