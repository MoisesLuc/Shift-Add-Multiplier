module tb_shift_add_multiplier;
    logic clk, rst;
    logic [7:0] b, q;
    logic [15:0] result;
    logic d_end;

shift_add_multiplier uut (
    .clk(clk),
    .rst(rst),
    .b(b),
    .q(q),
    .result(result),
    .d_end(d_end)
);

always begin
    clk = 1'b0;
    #10;
    clk = 1'b1;
    #10;
end

task test(input[7:0] multiplicador, input[7:0] multiplicando, input[15:0] resultado_esperado);
    begin
        q = multiplicador;
        b = multiplicando;

        rst = 1;
        #10;
        rst = 0;
        #10;

        wait(d_end == 1);

        if (result == resultado_esperado)
            $display("Multiplicacao de: %b x %b = %b CORRETO", b, q, result);
        else
            $display("Multiplicacao de: %b x %b = %b ERRADO // Esperava-se: %b", q, b, result, resultado_esperado);
        #20;
    end
endtask

initial begin
    $dumpfile("shift_add_multiplier.vcd");
    $dumpvars(0, tb_shift_add_multiplier);

    // Exibição do cabeçalho da tabela
    $display("|    B   |    Q     |      RESULT      | D_END |");
    $display("------------------------------------------------------------------");

    test(8'd0,    8'd0,    16'd0);       // 0 x 0 = 0
    test(8'd1,    8'd255,  16'd255);     // 1 x 255 = 255
    test(8'd170,  8'd201,  16'd34170);
    test(8'd255,  8'd1,    16'd255);     // 255 x 1 = 255
    test(8'd10,   8'd30,   16'd300);     // 10 x 30 = 300
    test(8'd50,   8'd50,   16'd2500);    // 50 x 50 = 2500
    test(8'd127,  8'd201,  16'd25527);   // 127 x 201 = 25527 (test já existente)
    test(8'd255,  8'd255,  16'd65025);   // 255 x 255 = 65025 (máximo produto 8x8 bits)
    test(8'd128,  8'd2,    16'd256);     // 128 x 2 = 256
    test(8'd128,   8'd128,    16'd16384);     // 128 x 128 = 16384
    test(8'd170,   8'd170,   16'd28900);     // 15 x 15 = 28900

    $finish;
end

endmodule;