module lfsr8 (
    input        clk,
    input        rst_n,
    input        load_seed,
    input  [7:0] seed,
    output reg [7:0] state
);

  wire fb;
  assign fb = state[7] ^ state[5] ^ state[4] ^ state[3];

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= 8'h01;
    end else if (load_seed) begin
      state <= (seed == 8'h00) ? 8'h01 : seed;
    end else begin
      state <= {state[6:0], fb};
    end
  end

endmodule
