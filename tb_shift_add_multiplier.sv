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

        if(result == resultado_esperado)
            $display("Multiplicacao de: %b x %b = %b esta CORRETO", b, q, result);
        else
            $display("Multiplicacao de: %b x %b = %b esta ERRADO // Esperava-se: %b", q, b, result, resultado_esperado);
        #20;
    end
endtask

initial begin
    $dumpfile("shift_add_multiplier.vcd");
    $dumpvars(0, tb_shift_add_multiplier);

    // Exibição do cabeçalho da tabela
    $display("|    B   |    Q     |      RESULT      | D_END |");
    $display("------------------------------------------------------------------");

    // test(8'd0, 8'd0, 16'd0);           // 0 x 0 = 0
    // test(8'd3, 8'd4, 16'd15);          // 3 x 5 = 15
    // test(8'd10, 8'd12, 16'd120);       // 10 x 12 = 120
    test(8'd127, 8'd201, 16'd25527);   // 127 x 201 = 25527
    // test(8'd2, 8'd2, 16'd4);           // 2 x 2 = 4
    // test(8'd4, 8'd4, 16'd16);           // 4 x 4 = 16
    // test(8'd8, 8'd8, 16'd64);          // 8 x 8 = 64
    // test(8'd16, 8'd16, 16'd64);        // 16 x 16 = 256
    // test(8'd32, 8'd32, 16'd1024);      // 32 x 32 = 1024
    // test(8'd64, 8'd64, 16'd4096);      // 64 x 64 = 4096
    // test(8'd64, 8'd64, 16'd4096);      // 64 x 64 = 4096
    // test(8'd128, 8'd128, 16'd16384);   // 128 x 128 = 16384
    // test(8'd255, 8'd255, 16'd65025);   // 255 x 255 = 4096

    $finish;
end

endmodule;