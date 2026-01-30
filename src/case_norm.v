module case_norm (
    input  [7:0] in_ch,
    output reg [7:0] up_ch,
    output reg       was_lower
);
  always @(*) begin
    if (in_ch >= "a" && in_ch <= "z") begin
      up_ch = in_ch - 8'd32;
      was_lower = 1'b1;
    end else begin
      up_ch = in_ch;
      was_lower = 1'b0;
    end
  end
endmodule
