module shoot_coin(clk, active_in, active_out, pwm, left_check, right_check, pwm_check);

	input clk, active_in;
	
	output pwm, active_out;
	output left_check, right_check, pwm_check;

	parameter [16:0] PWM_length_left = 50000; //should be 1 ms
	parameter [16:0] PWM_length_right = 100000; //should be 2 ms
	
	reg pwm, active_out, active;
	reg [20:0] counter = 0;
	reg [9:0] cycleCounter = 0;
	reg left_check, right_check, pwm_check;
	reg direction = 0;

	integer i;
	
	always @(posedge clk) begin
		if (active == 0) active = active_in;

		counter = counter+1; // Increase steps counter
		
		if(active == 1) begin
				case (direction)
					0: begin // First two cycles, first initial
						left_check = 1;
						right_check = 0;
						if (counter <= PWM_length_left) pwm = 1;
						else pwm = 0;
					end
					
					1: begin
						left_check = 0;
						right_check = 1;
						if (counter <= PWM_length_right) pwm = 1;
						else pwm = 0;
					end
				endcase
		end // END IF
		
		// When full cycle complete, go from beginning, increse cycle counter
		if (counter > 999999) begin
			counter = 0;
			cycleCounter = cycleCounter+1;
			if (cycleCounter > 30) begin
				cycleCounter = 0;
				active_out = 0;
				
				if (direction==0) direction = 1;
				else direction = 0;
			end
		end
		pwm_check <= pwm;
	end
	
endmodule