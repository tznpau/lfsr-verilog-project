`timescale 1ns/1ps

module cipher_core_tb;

  reg clk = 0;
  reg rst_n = 0;
  reg start = 0;

  reg  [7:0] ch_in;
  wire [7:0] ch_out;
  wire valid_out;
  wire in_table;

  cipher_core dut(
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .ch_in(ch_in),
    .ch_out(ch_out),
    .valid_out(valid_out),
    .in_table(in_table)
  );

  always #5 clk = ~clk;

  reg [7:0] msg [0:15];
  integer i;

  initial begin
    msg[0]  = "P";
    msg[1]  = "a";
    msg[2]  = "u";
    msg[3]  = "l";
    msg[4]  = "a";
    msg[5]  = "#";
    msg[6]  = "&";
    msg[7]  = "0";
    msg[8]  = "1";
    msg[9]  = "2";
    msg[10] = "3";
    msg[11] = "T";
    msg[12] = "e";
    msg[13] = "s";
    msg[14] = "t";
    msg[15] = "X";
  end

  initial begin
    $display("=== CIPHER CORE STREAM TEST ===");

    ch_in = "P";
    rst_n = 0;
    #12 rst_n = 1;

    @(negedge clk);
    start = 1;
    @(negedge clk);
    start = 0;

    for (i = 0; i < 16; i = i + 1) begin
      @(negedge clk);
      ch_in = msg[i];

      @(posedge clk);
      if (valid_out) begin
        $display("in=%s  out=%s", ch_in, ch_out);
      end else begin
        $display("in=%s  out=?  (not in table)", ch_in);
      end
    end

    $finish;
  end

endmodule
