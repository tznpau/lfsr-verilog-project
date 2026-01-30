`timescale 1ns/1ps

module case_tb;
  reg  [7:0] in_ch;
  wire [7:0] up_ch;
  wire       was_lower;

  reg  [7:0] mid_ch;
  wire [7:0] out_ch;

  case_norm u1(.in_ch(in_ch), .up_ch(up_ch), .was_lower(was_lower));
  case_restore u2(.in_ch(mid_ch), .to_lower(was_lower), .out_ch(out_ch));

  initial begin
    in_ch = "a"; mid_ch = "P"; #1;
    $display("in=%s up=%s was_lower=%0d mid=%s out=%s", in_ch, up_ch, was_lower, mid_ch, out_ch);

    in_ch = "Z"; mid_ch = "A"; #1;
    $display("in=%s up=%s was_lower=%0d mid=%s out=%s", in_ch, up_ch, was_lower, mid_ch, out_ch);

    in_ch = "#"; mid_ch = "#"; #1;
    $display("in=%s up=%s was_lower=%0d mid=%s out=%s", in_ch, up_ch, was_lower, mid_ch, out_ch);

    $finish;
  end
endmodule

