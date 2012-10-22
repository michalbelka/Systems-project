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

module lab2 (clk, go);

// Inputs
	input clk, go;
	
// Outputs

// Asuming clock  c = 50 MHz therefore clock period = 20 ns
// and 256 steps
// t0 = 20ms, p = t0/c = 1'000'000 - number of clock ticks for one whole cycle
// t1 = 1 ms, P = t1/c = 50'000 - numbder of clock ticks for one 1ms
// lenght = t1 + p/256 * (ASCII value)

	reg pwm;
	wire active;
	
	parameter [16:0] PWM_length_left = 50000; //should be 1 ms
	parameter [16:0] PWM_length_right = 100000; //should be 2 ms
	
	shoot_coin	sc0(.clk(clk),
						 .active_in(active),
						 .active_out(active));
	
	always @(posedge go) begin
		active = a;
	end
	
	
	
endmodule