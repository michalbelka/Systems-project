/*********************************************************
 *
 *  This design is responsible for taking signal from MBED
 * and running proper code when recieve this signal.
 *
 *  At the moment, this code is only waiting for go signal
 * and when this signal is recieved, it is dispensing one
 * token (= move servo 90 deg).
 *
 * TODO
 *
 *  This code should also wait for change color and lift
 * signals from MBED. When first signal is recieved, FPGA
 * should send signal to second servo to move to proper
 * position in order to change color of tokens dispensed.
 *
 *  Second signal should cause lift servo move 90 degree
 * to lift up tokens. After another signal is recieved
 * (when head is closed) servo go back = lift is going down.
 *
 *  Also, check all sizes if they need to be so big, if not,
 * don't waste resource
 *
 * -----
 *
 * Creation date:		23/10/2012
 * Last edit:			28/10/2012
 * Author:				DispTech
 *
**********************************************************/


module lab2 (clk, go, pwm, posRed, pwm_check, left_check, right_check, active_check, go_check);
 
 /* INPUTS */
 
 // clk:			50 MHz clock from FPGA
 // go:			when recieved, start dispensing tokens
 input clk;
 input go;
 
 // posRed:		when recieved, change color position to red (should be 2 more like this, or look at the comment down)
 input posRed;

 /* OUTPUTS */
 
 // pwm:			pwm output signal for servos
 output pwm;
 reg pwm;
 
 // *_check:	feedback signals, helping with debugging.
 output pwm_check, left_check, right_check, active_check, go_check;
 reg left_check, right_check, pwm_check, active_check, go_check;

 /*****************************
  *
  * Clock is 50 MHz, therefore clock period = 20 ns
  * 
  * By simple calculation, 20 ms (pulse interval) is 1'000'000 clock ticks
  * Servo is taking 1 ms pulse for goring left, 2 ms for going right (90 deg move)
  * while 1.5 ms is 45 deg move
  *
  * 1 ms is 50'000 ticks
  * 1.5 ms is 65'000 ticks
  * 2 ms is 100'000 ticks
  *
  * Those values are saved as parameters below
  *
 ******************************/ 

 parameter [16:0] PWM_length_left = 50000;
 parameter [16:0] PMW_length_mid = 65000;
 parameter [16:0] PWM_length_right = 100000;

 // Counter is counting clock ticks. One full cycle is 1'000'000 ticks
 reg [20:0] counter = 0;
 
 // Certain about of PWM pulses must be sent to servo and this is counting
 // TODO: Check what is the lowest number we need and use it
 reg [9:0] cycleCounter = 0;
 parameter [7:0] cycleAmount = 50; // This was addaed now, no checking, should work, but check, if not just change to 50 in code 
 
 // Direction saves what is current position of dispensing servo and therefore indicating what direction it should move to dispense
 reg [1:0] direction = 0;
 
 // No idea why we need this
 reg [4:0] go_count = 0;
 
 // If active is one, dispense token. By default 0, change when recieve go signal
 reg [1:0] active = 0;

	always @(posedge clk) begin

		// If go signal from MBED is 1, dispense coin (= change active to 1)
		if(go) begin
			active = 1;
			go_count = go_count +1; // No idea what this one is for
		end
		
		// If active = 1, dispense coin
		if(active == 1) begin

			counter = counter+1; // Increase steps counter

			if(cycleCounter <= cycleAmount) begin
				case (direction) // Direction of movement based on curent position
					0: begin
						// Feedback signals
						left_check = 1;
						right_check = 0;
						
						// If number of ticks is below or equal to amount needed, send 1, otherwise 0
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
			end
			// When full cycle complete, go from beginning, increse cycle counter
			if (counter > 999999) begin
				counter = 0;
				cycleCounter = cycleCounter+1;
				
				// If enough pulses were sent, zero all counters and set active to 0
				if (cycleCounter >= 100) begin // I think it should be just cycleAmount, not 100, but check it! As far as I remember it is only to make gap between movements
					// Change direction
					if (direction == 1) direction = 0;
					else direction = direction+1;
					cycleCounter = 0;
					active = 0;
				end
			end
			
			// Feedback signal
			pwm_check <= pwm;
		end
		
		active_check <= active;
		go_check <= go;
	end

endmodule