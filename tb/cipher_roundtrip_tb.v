`timescale 1ns/1ps

module cipher_roundtrip_tb;

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
    .clk(clk),
    .rst_n(rst_n),
    .start(start_enc),
    .seed_in(seed),
    .ch_in(ch_in_enc),
    .ch_out(ch_out_enc),
    .valid_out(valid_enc),
    .in_table()
  );

  cipher_core dec(
    .clk(clk),
    .rst_n(rst_n),
    .start(start_dec),
    .seed_in(seed),
    .ch_in(ch_in_dec),
    .ch_out(ch_out_dec),
    .valid_out(valid_dec),
    .in_table()
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

  reg [7:0] pt [0:15];
  reg [7:0] ct [0:15];
  integer i;

  initial begin
    pt[0]  = "P";
    pt[1]  = "a";
    pt[2]  = "u";
    pt[3]  = "l";
    pt[4]  = "a";
    pt[5]  = "#";
    pt[6]  = "&";
    pt[7]  = "0";
    pt[8]  = "1";
    pt[9]  = "2";
    pt[10] = "3";
    pt[11] = "T";
    pt[12] = "e";
    pt[13] = "s";
    pt[14] = "t";
    pt[15] = "X";
  end

  initial begin
    seed = xor_ascii_seed("Tintareanu");
    $display("seed=0x%0h", seed);

    $display("=== ROUNDTRIP TEST ===");

    ch_in_enc = "P";
    ch_in_dec = "P";

    rst_n = 0;
    #12 rst_n = 1;

    @(negedge clk);
    start_enc = 1;
    @(negedge clk);
    start_enc = 0;

    for (i = 0; i < 16; i = i + 1) begin
      @(negedge clk);
      ch_in_enc = pt[i];
      @(posedge clk);
      if (valid_enc) ct[i] = ch_out_enc;
      $display("ENC  in=%s  out=%s", ch_in_enc, ch_out_enc);
    end

    @(negedge clk);
    start_dec = 1;
    @(negedge clk);
    start_dec = 0;

    for (i = 0; i < 16; i = i + 1) begin
      @(negedge clk);
      ch_in_dec = ct[i];
      @(posedge clk);
      $display("DEC  in=%s  out=%s", ch_in_dec, ch_out_dec);
    end

    $finish;
  end

endmodule
