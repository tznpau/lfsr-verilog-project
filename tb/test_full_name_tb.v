`timescale 1ns/1ps

module test_full_name_tb;

  reg clk = 0;
  reg rst_n = 0;

  reg start_enc = 0;
  reg start_dec = 0;

  reg  [7:0] ch_in_enc;
  wire [7:0] ch_out_enc;

  reg  [7:0] ch_in_dec;
  wire [7:0] ch_out_dec;

  reg [7:0] seed;

  cipher_core enc(
    .clk(clk), .rst_n(rst_n), .start(start_enc), .seed_in(seed),
    .ch_in(ch_in_enc), .ch_out(ch_out_enc), .valid_out(), .in_table()
  );

  cipher_core dec(
    .clk(clk), .rst_n(rst_n), .start(start_dec), .seed_in(seed),
    .ch_in(ch_in_dec), .ch_out(ch_out_dec), .valid_out(), .in_table()
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

  function automatic is_lower(input [7:0] c);
    begin
      is_lower = (c >= "a" && c <= "z");
    end
  endfunction

  function automatic [7:0] to_lower(input [7:0] c);
    begin
      if (c >= "A" && c <= "Z") to_lower = c + 8'd32;
      else to_lower = c;
    end
  endfunction

  localparam integer N = 15;
  reg [7:0] pt [0:N-1];
  reg [7:0] ct [0:N-1];
  reg [7:0] dt [0:N-1];
  reg       case_bits [0:N-1];
  integer i;

  initial begin
    pt[0]="P"; pt[1]="a"; pt[2]="u"; pt[3]="l"; pt[4]="a";
    pt[5]="T"; pt[6]="i"; pt[7]="n"; pt[8]="t"; pt[9]="a";
    pt[10]="r"; pt[11]="e"; pt[12]="a"; pt[13]="n"; pt[14]="u";
  end

  initial begin
    seed = xor_ascii_seed("Tintareanu");
    $display("=== TEST 2: full name: PaulaTintareanu ===");
    $display("seed=0x%0h", seed);

    for (i=0;i<N;i=i+1) case_bits[i] = is_lower(pt[i]);

    rst_n = 0; #12 rst_n = 1;

    @(negedge clk); start_enc = 1;
    @(negedge clk); start_enc = 0;

    $display("plaintext:");
    for (i=0;i<N;i=i+1) $write("%s", pt[i]);
    $display("");

    $display("ciphertext:");
    for (i=0;i<N;i=i+1) begin
      @(negedge clk); ch_in_enc = pt[i];
      @(posedge clk); ct[i] = ch_out_enc;
      $write("%s", ct[i]);
    end
    $display("");

    @(negedge clk); start_dec = 1;
    @(negedge clk); start_dec = 0;

    $display("decrypted:");
    for (i=0;i<N;i=i+1) begin
      @(negedge clk); ch_in_dec = ct[i];
      @(posedge clk); dt[i] = ch_out_dec;
      if (case_bits[i]) dt[i] = to_lower(dt[i]);
      $write("%s", dt[i]);
    end
    $display("");

    for (i=0;i<N;i=i+1) if (dt[i] !== pt[i]) $display("MISMATCH at %0d", i);

    $finish;
  end

endmodule
