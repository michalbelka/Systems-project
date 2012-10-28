/*********************************
 *
 *  Helpful materials:
 *
 *   http://www.ehow.com/how_5742129_create-module-run-motor-servo.html
 *   Code from project page
 *
 *  ASCII values
 *
 *   M = 77, B = 66
 *   m = 109, b = 98
 *
 *********************************/

module lab2 (clk, go, pwm, pwm_check, left_check, right_check, mid_check);

// Inputs
	input clk, go;
	
// Outputs
	output pwm, pwm_check, left_check, right_check, mid_check;

// Asuming clock  c = 50 MHz therefore clock period = 20 ns
// and 256 steps
// t0 = 20ms, p = t0/c = 1'000'000 - number of clock ticks for one whole cycle
// t1 = 1 ms, P = t1/c = 50'000 - numbder of clock ticks for one 1ms
// lenght = t1 + p/256 * (ASCII value)

// EG of module instantiation
/*
shoot_coin	sc0(.clk(clk),
				.active_in(active),
				.active_out(active));
*/
	
	parameter [16:0] PWM_length_left = 50000; //should be 1 ms
	parameter [16:0] PWM_length_mid = 75000; //should be 1.5 ms
	parameter [16:0] PWM_length_right = 100000; //should be 2 ms
	
	reg [20:0] counter = 0;
	reg [9:0] cycleCounterIncreaser = 0;
	reg [1:0] cycleCounter = 0;
	reg pwm;
	reg mid_check, left_check, right_check, pwm_check;
	

	
	always @(posedge clk) begin
		counter = counter+1; // Increase steps counter
		left_check = 0;
		
		if(cycleCounterIncreaser <= 30) begin
			case (cycleCounter)
				0: begin
					left_check = 1;
					mid_check = 0;
					right_check = 0;
					if (counter <= PWM_length_left) pwm = 1;
					else pwm = 0;
				end
				
				1: begin
					left_check = 0;
					mid_check = 0;
					right_check = 1;
					if (counter <= PWM_length_right) pwm = 1;
					else pwm = 0;
				end
			endcase
		end
		// When full cycle complete, go from beginning, increse cycle counter
		if (counter > 999999) begin
			counter = 0;
			cycleCounterIncreaser = cycleCounterIncreaser+1;
			if (cycleCounterIncreaser >= 100) begin
				if (cycleCounter == 1) cycleCounter = 0;
				else cycleCounter = cycleCounter+1;
				cycleCounterIncreaser = 0;
			end
		end
		pwm_check <= pwm;
	end

endmodule