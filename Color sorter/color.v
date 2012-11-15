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


module color (clk, go, pwm, pwm_Pos, posRed, posGreen, posBlue, pwm_check, left_check, right_check, posRed_check, posBlue_check, posGreen_check, go_check);
 
 /* INPUTS */
 
 // clk:			50 MHz clock from FPGA
 // go:			when recieved, start dispensing tokens
 input clk, go;
 
 // posRed:		when recieved, change color position to red (should be 2 more like this, or look at the comment down)
 input posRed;
 input posGreen;
 input posBlue;
 

 /* OUTPUTS */
 

 // pwm:			pwm output signal for servos
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
  * 1 ms is 50'000 ticks
  * 1.5 ms is 65'000 ticks
  * 2 ms is 100'000 ticks
  *
  * Those values are saved as parameters below
  *
 ******************************/ 

 parameter [16:0] PWM_length_left = 50000;
 parameter [16:0] PWM_length_right = 100000;
 
 parameter [16:0] PWM_length_red = 73000;
 parameter [16:0] PWM_length_green = 95000;
 parameter [16:0] PWM_length_blue = 50000;

 // Counter is counting clock ticks. One full cycle is 1'000'000 ticks
 reg [20:0] counter = 0;
 reg [20:0] counter_PosR = 0;
 reg [20:0] counter_PosG = 0;
 reg [20:0] counter_PosB = 0;
 
 // Certain about of PWM pulses must be sent to servo and this is counting
 // TODO: Check what is the lowest number we need and use it
 reg [9:0] cycleCounter = 0;
 reg [9:0] cycleCounter_PosR = 0;
 reg [9:0] cycleCounter_PosG = 0;
 reg [9:0] cycleCounter_PosB = 0;
 parameter [7:0] cycleAmount = 50; // This was addaed now, no checking, should work, but check, if not just change to 50 in code 
 
 // Direction saves what is current position of dispensing servo and therefore indicating what direction it should move to dispense
 reg [1:0] direction = 0;
 
 // If active is one, dispense token. By default 0, change when recieve go signal
 reg active = 0;
 reg [1:0] newPosition = 0;
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
		
		// Turn on positioning blockade
		if(newPosition != 0) positioning = 1;
		
		// Change position
		if(positioning == 1) begin
			active = 0;
			counter = counter + 1;
			
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
			
			if (counter > 999999) begin
				counter = 0;
				cycleCounter = cycleCounter+1;
				
				if(cycleCounter >= 100) begin // Reset everything
					cycleCounter = 0;
					newPosition = 0;
					posRed_check = 0;
					posGreen_check = 0;
					posBlue_check = 0;
					positioning = 0;
				end
			end
			
			pwm_check <= pwm_Pos;
		end
		
		// If go signal from MBED is 1, dispense coin (= change active to 1)
		if(go == 1 && positioning == 0)
			active = 1;
		
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
	end

endmodule