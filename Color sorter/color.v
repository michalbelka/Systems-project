/*********************************************************
 *
 *  This design is responsible for taking signal from MBED
 * and moving proper servo to proper position when recieve this signal.
 *
 *
 * -----
 *
 * Creation date:		23/10/2012
 * Last edit:			20/11/2012
 * Author:				DispTech
 *
**********************************************************/


module color (clk, go, pwm, pwm_Pos, posRed, posGreen, posBlue, pwm_check, left_check, right_check, posRed_check, posBlue_check, posGreen_check, go_check);
 
 /* INPUTS */
 
 // clk:			50 MHz clock from FPGA
 // go:				when recieved, dispense token
 input clk, go;
 
 // pos*:	when recieved, change color position to red, green, blue
 input posRed;
 input posGreen;
 input posBlue;
 

 /* OUTPUTS */
 

 // pwm:			pwm output signal for dispensing servo
 // pwm_Pos:		pwm output signal for changing color
 output pwm;
 output pwm_Pos;
 reg pwm;
 reg pwm_Pos; 

 // *_check:	feedback signals, helping with debugging.
 output pwm_check, left_check, right_check, posRed_check, posBlue_check, posGreen_check, go_check;
 reg left_check, right_check, pwm_check, posRed_check, posBlue_check, posGreen_check, go_check;

 /*****************************
  *
  * Clock is 50 MHz, therefore clock period = 20 ns
  * 
  * By simple calculation, 20 ms (pulse interval) is 1'000'000 clock ticks
  * Servo is taking 1 ms pulse for goring left, 2 ms for going right (90 deg move)
  * while 1.5 ms is 45 deg move
  *
  * e.g.
  * 1 ms is 50'000 ticks (0 deg)
  * 1.5 ms is 65'000 ticks (45 deg)
  * 2 ms is 100'000 ticks (90 deg)
  *
  * Values are saved as parameters below
  *
 ******************************/ 

 // Values for dispensing servo
 parameter [16:0] PWM_length_left = 50000;
 parameter [16:0] PWM_length_right = 100000;
 
 // Values for color changing servo
 parameter [16:0] PWM_length_red = 73000;
 parameter [16:0] PWM_length_green = 95000;
 parameter [16:0] PWM_length_blue = 50000;

 // Counter is counting clock ticks. One full cycle is 1'000'000 ticks
 reg [20:0] counter = 0;
 
 // Certain amount of PWM pulses must be sent to servo for full movement and this is counting those pulses
 // TODO: Check what is the lowest number we need and use it
 reg [9:0] cycleCounter = 0;
 parameter [7:0] cycleAmount = 50;
 
 // Direction saves what is current position of dispensing servo and therefore indicating what direction it should move to dispense
 reg [1:0] direction = 0;
 
 // If active is one, dispense token. By default 0, change when recieve go signal
 reg active = 0;
 
 // newPosition is indicating what color should be chosen. Therefore, no dispensing can happen
 // 0 is no change
 // 1 is red
 // 2 is green
 // 3 is blue
 reg [1:0] newPosition = 0;
 
 // This indicates if positioning should occur. No dispensing can happen during that time
 reg positioning = 0;

	always @(posedge clk) begin
		go_check <= go;
		
		
		// Turn on color positioning
		/******************
		 * newPosition:
		 * 0 - none
		 * 1 - red
		 * 2 - green
		 * 3 - blue
		 ******************/
		if(posRed == 1) begin
			newPosition = 1;
			posRed_check = 1;
		end
		else if (posGreen == 1) begin
			newPosition = 2;
			posGreen_check = 1;
		end
		else if (posBlue == 1) begin
			newPosition = 3;
			posBlue_check = 1;
		end
		
		// Turn on positioning blockade; no dispensing can happen when colors are changed
		// NOTE: It was tested; go signal was send along with color changing signal and system was not dispensing tokens.
		// NOTE2: This is just for security reasons. In normal use, without any errors there is no chance than both signals are 1 at the same time
		if(newPosition != 0) positioning = 1;
		
		// Change position
		if(positioning == 1) begin
			active = 0; // Make sure it is not trying to dispense anything.
			counter = counter + 1; // Ticks counter
			
			if(cycleCounter <= cycleAmount) begin
				case(newPosition)
					1: begin // RED
						if (counter <= PWM_length_red) pwm_Pos = 1;
						else pwm_Pos = 0;
					end
					2: begin // GREEN
						if (counter <= PWM_length_green) pwm_Pos = 1;
						else pwm_Pos = 0;
					end
					3: begin // BLUE
						if (counter <= PWM_length_blue) pwm_Pos = 1;
						else pwm_Pos = 0;
					end
					default: begin
						pwm_Pos = 0;
					end
				endcase
			end
			
			if (counter > 999999) begin // 1 000 000 ticks = 20 ms = one full pulse cycle
				counter = 0; // Reset ticks counter
				cycleCounter = cycleCounter+1; // And increase cycle counter
				
				if(cycleCounter >= cycleAmount) begin // Reset everything if enough pulses were sent
					cycleCounter = 0;
					newPosition = 0;
					posRed_check = 0;
					posGreen_check = 0;
					posBlue_check = 0;
					positioning = 0; // Turn off positioning so dispensing can occur
				end
			end
			
			pwm_check <= pwm_Pos; // Feedback
		end
		
		// If go signal from MBED is 1 and position is not changed, dispense coin (= change active to 1)
		if(go == 1 && positioning == 0)
			active = 1;
		
		// If active = 1, dispense coin
		if(active == 1) begin

			counter = counter+1; // Increase ticks counter

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
	end

endmodule