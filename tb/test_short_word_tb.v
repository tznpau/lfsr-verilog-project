`timescale 1ns/1ps

module test_short_word_tb;

  reg clk = 0;
  reg rst_n = 0;

  reg start_enc = 0;
  reg start_dec = 0;

  reg  [7:0] ch_in_enc;
  wire [7:0] ch_out_enc;
  wire valid_enc;

  reg  [7:0] ch_in_dec;
  wire [7:0] ch_out_dec;
  wire valid_dec;

  reg [7:0] seed;

  cipher_core enc(
    .clk(clk), .rst_n(rst_n), .start(start_enc), .seed_in(seed),
    .ch_in(ch_in_enc), .ch_out(ch_out_enc), .valid_out(valid_enc), .in_table()
  );

  cipher_core dec(
    .clk(clk), .rst_n(rst_n), .start(start_dec), .seed_in(seed),
    .ch_in(ch_in_dec), .ch_out(ch_out_dec), .valid_out(valid_dec), .in_table()
  );

  always #5 clk = ~clk;

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

  localparam integer N = 7;
  reg [7:0] pt [0:N-1];
  reg [7:0] ct [0:N-1];
  reg [7:0] dt [0:N-1];
  integer i;

  initial begin
    pt[0]="c"; pt[1]="i"; pt[2]="r"; pt[3]="c"; pt[4]="u"; pt[5]="i"; pt[6]="t";
  end

  initial begin
    seed = xor_ascii_seed("Tintareanu");
    $display("=== TEST 1: short word: circuit ===");
    $display("seed=0x%0h", seed);

    rst_n = 0; #12 rst_n = 1;

    @(negedge clk); start_enc = 1;
    @(negedge clk); start_enc = 0;

    for (i=0;i<N;i=i+1) begin
      @(negedge clk); ch_in_enc = pt[i];
      @(posedge clk);
      ct[i] = ch_out_enc;
      $write("%s", pt[i]);
    end
    $display("");

    $display("ciphertext:");
    for (i=0;i<N;i=i+1) $write("%s", ct[i]);
    $display("");

    @(negedge clk); start_dec = 1;
    @(negedge clk); start_dec = 0;

    $display("decrypted:");
    for (i=0;i<N;i=i+1) begin
      @(negedge clk); ch_in_dec = ct[i];
      @(posedge clk);
      dt[i] = ch_out_dec;
      $write("%s", dt[i]);
    end
    $display("");

    for (i=0;i<N;i=i+1) if (dt[i] !== pt[i]) $display("MISMATCH at %0d", i);

    $finish;
  end

endmodule
