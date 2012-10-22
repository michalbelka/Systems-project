module mbed(go, show);

	input go;
	output show;
	reg show;
	
	always@(go) begin
		if (go==0) show = 1;
		else show = 0;
	end

endmodule