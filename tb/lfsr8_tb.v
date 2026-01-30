`timescale 1ns/1ps

module lfsr8_tb;

  reg clk = 0;
  reg rst_n = 0;
  reg load_seed = 0;
  reg [7:0] seed;
  wire [7:0] state;

  always #5 clk = ~clk;

  lfsr8 dut(
    .clk(clk),
    .rst_n(rst_n),
    .load_seed(load_seed),
    .seed(seed),
    .state(state)
  );

  function automatic [7:0] xor_ascii_seed(input [8*32-1:0] s);
    integer i;
    reg [7:0] acc;
    reg [7:0] ch;
    begin
      acc = 8'h00;
      for (i = 0; i < 32; i = i + 1) begin
        ch = s[8*(31-i) +: 8];
        if (ch != 8'h00) acc = acc ^ ch;
      end
      xor_ascii_seed = (acc == 8'h00) ? 8'h01 : acc;
    end
  endfunction

  integer k;

  initial begin
    seed = xor_ascii_seed("Tintareanu");
    $display("seed=0x%0h", seed);

    rst_n = 0;
    #12 rst_n = 1;

    @(negedge clk);
    load_seed = 1;
    @(negedge clk);
    load_seed = 0;

    $display("First 15 states:");
    for (k = 0; k < 15; k = k + 1) begin
      @(posedge clk);
      $display("%0d: %0h", k+1, state);
    end

    $finish;
  end

endmodule
