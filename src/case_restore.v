module case_restore (
    input  [7:0] in_ch,
    input        to_lower,
    output reg [7:0] out_ch
);
  always @(*) begin
    if (to_lower && (in_ch >= "A" && in_ch <= "Z")) begin
      out_ch = in_ch + 8'd32;
    end else begin
      out_ch = in_ch;
    end
  end
endmodule
