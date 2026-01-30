module table32 (
    input  [7:0] ch_in,      
    output reg [4:0] idx_out, 
    output reg       found,   

    input  [4:0] idx_in,     
    output reg [7:0] ch_out   
);

  always @(*) begin
    case (idx_in)
      5'd0:  ch_out = "P";
      5'd1:  ch_out = "A";
      5'd2:  ch_out = "U";
      5'd3:  ch_out = "L";
      5'd4:  ch_out = "B";
      5'd5:  ch_out = "C";
      5'd6:  ch_out = "D";
      5'd7:  ch_out = "E";
      5'd8:  ch_out = "F";
      5'd9:  ch_out = "G";
      5'd10: ch_out = "H";
      5'd11: ch_out = "I";
      5'd12: ch_out = "J";
      5'd13: ch_out = "K";
      5'd14: ch_out = "M";
      5'd15: ch_out = "N";
      5'd16: ch_out = "O";
      5'd17: ch_out = "Q";
      5'd18: ch_out = "R";
      5'd19: ch_out = "S";
      5'd20: ch_out = "T";
      5'd21: ch_out = "V";
      5'd22: ch_out = "W";
      5'd23: ch_out = "X";
      5'd24: ch_out = "Y";
      5'd25: ch_out = "Z";
      5'd26: ch_out = "#";
      5'd27: ch_out = "&";
      5'd28: ch_out = "0";
      5'd29: ch_out = "1";
      5'd30: ch_out = "2";
      5'd31: ch_out = "3";
      default: ch_out = "?";
    endcase
  end

  always @(*) begin
    found = 1'b1;
    case (ch_in)
      "P": begin idx_out = 5'd0;  end
      "A": begin idx_out = 5'd1;  end
      "U": begin idx_out = 5'd2;  end
      "L": begin idx_out = 5'd3;  end
      "B": begin idx_out = 5'd4;  end
      "C": begin idx_out = 5'd5;  end
      "D": begin idx_out = 5'd6;  end
      "E": begin idx_out = 5'd7;  end
      "F": begin idx_out = 5'd8;  end
      "G": begin idx_out = 5'd9;  end
      "H": begin idx_out = 5'd10; end
      "I": begin idx_out = 5'd11; end
      "J": begin idx_out = 5'd12; end
      "K": begin idx_out = 5'd13; end
      "M": begin idx_out = 5'd14; end
      "N": begin idx_out = 5'd15; end
      "O": begin idx_out = 5'd16; end
      "Q": begin idx_out = 5'd17; end
      "R": begin idx_out = 5'd18; end
      "S": begin idx_out = 5'd19; end
      "T": begin idx_out = 5'd20; end
      "V": begin idx_out = 5'd21; end
      "W": begin idx_out = 5'd22; end
      "X": begin idx_out = 5'd23; end
      "Y": begin idx_out = 5'd24; end
      "Z": begin idx_out = 5'd25; end
      "#": begin idx_out = 5'd26; end
      "&": begin idx_out = 5'd27; end
      "0": begin idx_out = 5'd28; end
      "1": begin idx_out = 5'd29; end
      "2": begin idx_out = 5'd30; end
      "3": begin idx_out = 5'd31; end
      default: begin
        found = 1'b0;
        idx_out = 5'd0;
      end
    endcase
  end

endmodule
