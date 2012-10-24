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

module lab2 (clk, pwm, newRed, newBlue, newGreen, block);

// Inputs
	input clk, newBlue, newRed, newGreen;
	
// Outputs
	output pwm;
	output [6:0]block;

// Asuming clock  c = 50 MHz therefore clock period = 20 ns
// and 256 steps
// t0 = 20ms, p = t0/c = 1'000'000 - number of clock ticks for one whole cycle
// t1 = 1 ms, P = t1/c = 50'000 - numbder of clock ticks for one 1ms
	
	parameter [17:0] PWM_length_acw = 300000;  //	go cw (?)
	parameter [17:0] PWM_length_cw = 100000; // 	go acw (?)
	
	reg [21:0] counter = 0;
	reg [9:0] cycleCounterIncreaser = 0;
	reg pwm;
	reg [1:0]curPosition = 0;
	reg [2:0]newPosition;
	reg [2:0] direction;
	reg done;
	
	always @(posedge clk) begin
		// New position
		/* TODO
		 *
		 * This could be done in a different way, and better
		 * insted of taking 3 inputs, take only one from MBED
		 * and count how long it is one. Depengin on this choose
		 * new direction. SHould be quite easy since we know
		 * clk period
		 *
		 */
		if (newRed == 1) newPosition = 0;
		else if (newGreen == 1) newPosition = 1;
		else if (newBlue == 1) newPosition = 2;
	
		// Movements
		case (curPosition)
			0: begin // red
				case (newPosition)
					0: direction = 0;
					1: direction = 1;
					2: direction = 3;
				endcase
			end
			
			1: begin // green
				case (newPosition)
					0: direction = 2;
					1: direction = 0;
					2: direction = 1;
				endcase
			end
			
			2: begin // blue
				case (newPosition)
					0: direction = 4;
					1: direction = 2;
					2: direction = 0;
				endcase
			end
		endcase
	
		
		counter = counter+1; // Increase steps counter
		
		case (direction)
			0: begin // Do nothing
				done = 1;
			end
			
			1: begin // Do nothing
				if(cycleCounterIncreaser <= 13) begin
					if (counter <= PWM_length_acw) pwm = 1;
					else pwm = 0;
				end
				
				if(cycleCounterIncreaser == 14) begin
					done = 1;
					curPosition = newPosition;
				end
			end
			
			2: begin // Do nothing
				if(cycleCounterIncreaser <= 13) begin
					if (counter <= PWM_length_cw) pwm = 1;
					else pwm = 0;
				end
				
				if(cycleCounterIncreaser == 14) begin
					done = 1;
					curPosition = newPosition;
				end
			end
			
			3: begin // Do nothing
				if(cycleCounterIncreaser <= 33) begin
					if (counter <= PWM_length_acw) pwm = 1;
					else pwm = 0;
				end
				
				if(cycleCounterIncreaser == 34) begin
					done = 1;
					curPosition = newPosition;
				end
			end
			
			4: begin
				if(cycleCounterIncreaser <= 33) begin
					if (counter <= PWM_length_cw) pwm = 1;
					else pwm = 0;
				end
				
				if(cycleCounterIncreaser == 34) begin
					done = 1;
					curPosition = newPosition;
				end
			end
			
		endcase
		// When full cycle complete, go from beginning, increse cycle counter
		if (counter > 999999) begin
			counter = 0;
			cycleCounterIncreaser = cycleCounterIncreaser+1;
			if (cycleCounterIncreaser >= 100) begin
				cycleCounterIncreaser = 0;
			end
		end
	end

endmodule