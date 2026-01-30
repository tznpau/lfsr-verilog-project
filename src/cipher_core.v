module cipher_core (
    input        clk,
    input        rst_n,
    input        start,
    input  [7:0] seed_in,
    input  [7:0] ch_in,
    output [7:0] ch_out,
    output       valid_out,
    output       in_table
);

  wire [7:0] up_ch;
  wire was_lower;

  case_norm u_norm(
    .in_ch(ch_in),
    .up_ch(up_ch),
    .was_lower(was_lower)
  );

  wire [7:0] lfsr_state;

  lfsr8 u_lfsr(
    .clk(clk),
    .rst_n(rst_n),
    .load_seed(start),
    .seed(seed_in),
    .state(lfsr_state)
  );

  wire [4:0] P;
  wire found_p;

  wire [4:0] idx_in_tbl;
  wire [7:0] ch_out_tbl;

  assign idx_in_tbl = (found_p) ? (P ^ lfsr_state[4:0]) : 5'd0;

  table32 u_tbl(
    .ch_in(up_ch),
    .idx_out(P),
    .found(found_p),
    .idx_in(idx_in_tbl),
    .ch_out(ch_out_tbl)
  );

  wire [7:0] restored;

  case_restore u_restore(
    .in_ch(ch_out_tbl),
    .to_lower(was_lower),
    .out_ch(restored)
  );

  assign ch_out    = restored;
  assign valid_out = found_p;
  assign in_table  = found_p;

endmodule
