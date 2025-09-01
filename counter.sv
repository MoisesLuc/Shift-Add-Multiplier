module counter #(parameter N=4) (
    input logic clk, rst,
    input logic load, en,         //Sinal de carregamento e habilita contagem
    input logic up_down,          // (1: ++) ; (0: --)
    input logic[N-1:0] data_in,   // Entrada paralela

    output logic[N-1:0] data_out, // Conteúdo atual
    output logic c_end            // Fim da contagem (1 if r_reg = 0)
);
logic[N-1:0] r_reg, r_next;

always_ff @(posedge clk, posedge rst)
    begin
      if(rst)
        r_reg <= 0;
      else
        r_reg <= r_next;
    end

always_comb
    begin
      r_next = r_reg;

      if(load)
        r_next = data_in;
      else if(en) begin
        if(c_end) begin
          r_next = r_reg; 
        end
        else begin
          if(up_down)
            r_next = r_reg + 1;
          else
            r_next = r_reg - 1;
        end
      end
    end

assign c_end = (r_reg == 0); // c_end = 1 if r_reg == 0
assign data_out = r_reg;
endmodule