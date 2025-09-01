module shift_register #(parameter N=4) (
    input logic clk, rst,
    input logic[1:0] ctrl,
    input logic[N-1:0] parallel_in,
    input logic ser_in,

    output logic[N-1:0] parallel_out,
    output logic ser_out
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
      case(ctrl)
        2'b11: r_next = parallel_in;
        2'b10: 
          begin
            ser_out = r_reg[3];    // Capta MSB
            r_next = {r_reg[N-2:0], ser_in};
          end
        2'b01:
          begin
            ser_out = r_reg[0];    // Capta LSB
            r_next = {ser_in, r_reg[N-1:1]};
          end
        2'b00: r_next = r_reg;
        default: r_next = r_reg;
      endcase
    end

assign parallel_out = r_reg;

endmodule
    
