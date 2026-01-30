`timescale 1ns/1ps

module table32_tb;

  reg  [7:0] ch_in;
  wire [4:0] idx_out;
  wire       found;

  reg  [4:0] idx_in;
  wire [7:0] ch_out;

  table32 dut (
    .ch_in(ch_in),
    .idx_out(idx_out),
    .found(found),
    .idx_in(idx_in),
    .ch_out(ch_out)
  );

  initial begin
    $display("=== TABLE TEST ===");

    idx_in = 0;  #1;  $display("idx_in=%0d -> ch_out=%s", idx_in, ch_out);
    idx_in = 1;  #1;  $display("idx_in=%0d -> ch_out=%s", idx_in, ch_out);
    idx_in = 26; #1;  $display("idx_in=%0d -> ch_out=%s", idx_in, ch_out);
    idx_in = 27; #1;  $display("idx_in=%0d -> ch_out=%s", idx_in, ch_out);
    idx_in = 31; #1;  $display("idx_in=%0d -> ch_out=%s", idx_in, ch_out);

    $display("---");

    ch_in = "P"; #1; $display("ch_in=%s -> found=%0d idx_out=%0d", ch_in, found, idx_out);
    ch_in = "A"; #1; $display("ch_in=%s -> found=%0d idx_out=%0d", ch_in, found, idx_out);
    ch_in = "U"; #1; $display("ch_in=%s -> found=%0d idx_out=%0d", ch_in, found, idx_out);
    ch_in = "L"; #1; $display("ch_in=%s -> found=%0d idx_out=%0d", ch_in, found, idx_out);
    ch_in = "#"; #1; $display("ch_in=%s -> found=%0d idx_out=%0d", ch_in, found, idx_out);
    ch_in = "&"; #1; $display("ch_in=%s -> found=%0d idx_out=%0d", ch_in, found, idx_out);
    ch_in = "3"; #1; $display("ch_in=%s -> found=%0d idx_out=%0d", ch_in, found, idx_out);

    // something not in the table 
    ch_in = "@"; #1; $display("ch_in=%s -> found=%0d idx_out=%0d", ch_in, found, idx_out);

    $display("=== END ===");
    $finish;
  end

endmodule
