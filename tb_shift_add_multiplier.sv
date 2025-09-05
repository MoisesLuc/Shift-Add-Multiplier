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

initial begin
    rst = 1'b1;
    #10;
    rst = 1'b0;
end

// Tarefa para rodar o teste
task run_test(input [7:0] multiplicador, input [7:0] multiplicando, input [15:0] esperado);
    begin
        q = multiplicador;
        b = multiplicando;
        rst = 1;
        @(posedge clk);
        rst = 0;
        @(posedge clk);

        wait(d_end == 1);  // espera a flag done

        if (result == esperado)
            $display("TESTE: %0d x %0d = %0d CORRETO", b, q, result);
        else
            $display("TESTE: %0d x %0d = %0d ERRO! Esperado: %0d", b, q, result, esperado);

        @(posedge clk);
    end
endtask

initial begin
    $dumpfile("shift_add_multiplier.vcd");
    $dumpvars(0, tb_shift_add_multiplier);

    // Testes
    run_test(8'd0,    8'd0,    16'd0);       // 0 x 0 = 0
    run_test(8'd1,    8'd2,  16'd2);     // 1 x 255 = 255
    run_test(8'd1,  8'd3,    16'd3);     // 255 x 1 = 255
    run_test(8'd1,   8'd4,   16'd4);     // 10 x 30 = 300
    run_test(8'd1,   8'd5,   16'd5);    // 50 x 50 = 2500
    run_test(8'd127,  8'd201,  16'd25527);   // 127 x 201 = 25527 (test já existente)
    run_test(8'd255,  8'd255,  16'd65025);   // 255 x 255 = 65025 (máximo produto 8x8 bits)
    run_test(8'd128,  8'd2,    16'd256);     // 128 x 2 = 256
    run_test(8'd128,   8'd128,    16'd16384);     // 128 x 128 = 16384
    run_test(8'd170,   8'd170,   16'd28900);     // 15 x 15 = 28900
    run_test(8'd255,   8'd255,    16'd65025);     // 255 x 255 = 65025


    $finish;
end

endmodule;