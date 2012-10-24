module BCD_to_7seg_decoder(clk, number, code);

	input clk;
	input[3:0] number;
	output[6:0] code;
	
	always @ (posedge clk)
	begin
	
		case (number)
			4'b0000: code = 8'b1111110; // 0
			4'b0001: code = 8'b0110000; // 1
			4'b0010: code = 8'b1101101; // 2
			4'b0011: code = 8'b1111001; // 3
			4'b0100: code = 8'b0110011; // 4
			4'b0101: code = 8'b1011011; // 5
			4'b0110: code = 8'b1011111; // 6
			4'b0111: code = 8'b1110000; // 7
			4'b1000: code = 8'b1111111; // 8
			4'b1001: code = 8'b1111011; // 9

			default: code = 8'b1000111; // F - overflow
		endcase
	
	end
endmodule