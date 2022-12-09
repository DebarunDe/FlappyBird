module Pipe1 (
input Reset, frame_clk,
input [7:0] keycode,
input GAME_END,
input [7:0] PipeR, Score,
output [9:0]  PipeX, PipeY, PipeS,
output [7:0] Pipe1R, Pipe1G, Pipe1B
);



logic [9:0] Pipe_X_Pos, Pipe_X_Motion, Pipe_Y_Pos, Pipe_Y_Motion, Pipe_Size, delay_pipe_movement;
logic [3:0] Pipe_Randomization;
logic [1:0] color_meter;
logic Up_or_Down, Game_Start_init, Randomize, Color_Change;
	 
    parameter [9:0] Pipe_X_Center=300;  // Center position on the X axis
    parameter [9:0] Pipe_Y_Center=240; //240 // Center position on the Y axis
    parameter [9:0] Pipe_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Pipe_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Pipe_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Pipe_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Pipe_X_Step=1;      // Step size on the X axis
    parameter [9:0] Pipe_Y_Step=1;      // Step size on the Y axis
	// parameter [3:0] Pipe_Test = 20;

    assign Pipe_Size = 50;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 //Game_Start <= 0;
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Pipe
		  if (Reset)  // Asynchronous Reset
        begin 
            Pipe_Y_Motion <= 10'd0; //Pipe_Y_Step;
				Pipe_X_Motion <= 10'd0; //Pipe_X_Step;
				Pipe_Y_Pos <= Pipe_Y_Center;
				Pipe_X_Pos <= Pipe_X_Center;
				Up_or_Down = 1;
				Randomize = 0;
				Game_Start_init = 0;
				Color_Change = 0;
				Pipe1R = 8'hff;
				Pipe1G = 8'hff;
			   Pipe1B = 8'h00;
        end
           
        else
        begin 
			if(delay_pipe_movement % 2 == 0) begin
				if(Pipe_X_Pos == 350) begin
					Randomize = 1;
				end
				if (Randomize == 1) begin
					if(Up_or_Down == 1 && ((Pipe_Y_Pos - PipeR) > 80)) begin
					Pipe_Y_Pos = Pipe_Y_Pos - PipeR;
					Randomize = 0;
					Up_or_Down = 0;
					delay_pipe_movement = 0;
					end
			   else if ((Pipe_Y_Pos + PipeR < 574)) begin 
					Pipe_Y_Pos = Pipe_Y_Pos + PipeR; 
					Randomize = 0; 
					Up_or_Down = 1; 
					delay_pipe_movement = 0; 
					end
					end
					end
			if(delay_pipe_movement % 2 == 1) begin
				if(Pipe_X_Pos == 0) begin
					Randomize = 1;
					Color_Change = 1;
					color_meter = color_meter + 1;
				end
				if (Color_Change == 1) begin
					if(color_meter == 1) begin
						Pipe1R = 8'hff;
						Pipe1G = 8'h00;
					   Pipe1B = 8'h00;
						end
					else if(color_meter == 2) begin
						Pipe1R = 8'h00;
						Pipe1G = 8'hff;
					   Pipe1B = 8'h00;
					end
					else if(color_meter == 3) begin
						Pipe1R = 8'hff;
						Pipe1G = 8'hff;
					   Pipe1B = 8'h00;
					end
					else begin
						Pipe1R = 8'h00;
						Pipe1G = 8'hff;
					   Pipe1B = 8'hff;
					end
						Color_Change = 0;
						end
				if (Randomize == 1) begin
					if(Up_or_Down == 1 && ((Pipe_Y_Pos - PipeR) > 80)) begin
					Pipe_Y_Pos = Pipe_Y_Pos - PipeR;
					Randomize = 0;
					Up_or_Down = 0;
					delay_pipe_movement = 0;
					end
					else if ((Pipe_Y_Pos + PipeR) < 574) begin
					Pipe_Y_Pos = Pipe_Y_Pos + PipeR;
					Randomize = 0;
					Up_or_Down = 1;
					delay_pipe_movement = 0;
					end
					end
					end
					
					
				if(GAME_END == 1) begin //if game ending condition occurs, stop pipe movement
					Pipe_X_Motion <= 0;
				end
				 else
				 begin
					  Pipe_X_Motion <= Pipe_X_Motion;  
				 case (keycode)
					8'h2c : begin //spacebar hit
								delay_pipe_movement <= delay_pipe_movement + 1;
								if(Score < 10) begin Pipe_X_Motion <= 0 - 1; end
								else if(Score < 30 && Score > 10) begin Pipe_X_Motion <= 0 - 2; end
								else if(Score > 30) begin Pipe_X_Motion <= 0 - 3; end
							  end
					8'h15: begin // hit R
					Pipe_X_Motion <= 0;
					end
					default: ;
			   endcase
				
				end
				
				
				 
				 Pipe_Y_Pos <= (Pipe_Y_Pos);  // Update Pipe position
				 Pipe_X_Pos <= (Pipe_X_Pos + Pipe_X_Motion);
						
		end  
    end
       
    assign PipeX = Pipe_X_Pos;
   
    assign PipeY = Pipe_Y_Pos;
   
    assign PipeS = Pipe_Size;
    
endmodule


module Pipe2 (
input Reset, frame_clk,
input [7:0] keycode,
input GAME_END,
input [7:0] PipeR, Score,
output [9:0]  PipeX, PipeY, PipeS,
output [7:0] Pipe2R, Pipe2G, Pipe2B
);



logic [9:0] Pipe_X_Pos, Pipe_X_Motion, Pipe_Y_Pos, Pipe_Y_Motion, Pipe_Size, delay_pipe_movement;
logic [3:0] Pipe_Randomization;
logic [1:0] color_meter;
logic Up_or_Down, Game_Start_init, Randomize, Color_Change;
	 
    parameter [9:0] Pipe_X_Center=500;  // Center position on the X axis
    parameter [9:0] Pipe_Y_Center=240; //240 // Center position on the Y axis
    parameter [9:0] Pipe_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Pipe_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Pipe_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Pipe_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Pipe_X_Step=1;      // Step size on the X axis
    parameter [9:0] Pipe_Y_Step=1;      // Step size on the Y axis
	// parameter [3:0] Pipe_Test = 20;

    assign Pipe_Size = 50;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 //Game_Start <= 0;
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Pipe
		  if (Reset)  // Asynchronous Reset
        begin 
            Pipe_Y_Motion <= 10'd0; //Pipe_Y_Step;
				Pipe_X_Motion <= 10'd0; //Pipe_X_Step;
				Pipe_Y_Pos <= Pipe_Y_Center;
				Pipe_X_Pos <= Pipe_X_Center;
				Up_or_Down = 1;
				Randomize = 0;
				Game_Start_init = 0;
				Color_Change = 0;
				Pipe2R = 8'hff;
				Pipe2G = 8'hff;
			   Pipe2B = 8'h00;
        end
           
        else
        begin 
			if(delay_pipe_movement % 2 == 0) begin
				if(Pipe_X_Pos == 350) begin
					Randomize = 1;
				end
				if (Randomize == 1) begin
					if(Up_or_Down == 1 && ((Pipe_Y_Pos - PipeR) > 80)) begin
					Pipe_Y_Pos = Pipe_Y_Pos - PipeR;
					Randomize = 0;
					Up_or_Down = 0;
					delay_pipe_movement = 0;
					end
			   else if ((Pipe_Y_Pos + PipeR < 574)) begin 
					Pipe_Y_Pos = Pipe_Y_Pos + PipeR; 
					Randomize = 0; 
					Up_or_Down = 1; 
					delay_pipe_movement = 0; 
					end
					end
					end
			if(delay_pipe_movement % 2 == 1) begin
				if(Pipe_X_Pos == 0) begin
					Randomize = 1;
					Color_Change = 1;
					color_meter = color_meter + 1;
				end
				if (Color_Change == 1) begin
					if(color_meter == 1) begin
						Pipe2R = 8'hff;
						Pipe2G = 8'h00;
					   Pipe2B = 8'h00;
						end
					else if(color_meter == 2) begin
						Pipe2R = 8'h00;
						Pipe2G = 8'hff;
					   Pipe2B = 8'h00;
					end
					else if(color_meter == 3) begin
						Pipe2R = 8'hff;
						Pipe2G = 8'hff;
					   Pipe2B = 8'h00;
					end
					else begin
						Pipe2R = 8'h00;
						Pipe2G = 8'hff;
					   Pipe2B = 8'hff;
					end
						Color_Change = 0;
						end
				if (Randomize == 1) begin
					if(Up_or_Down == 1 && ((Pipe_Y_Pos - PipeR) > 80)) begin
					Pipe_Y_Pos = Pipe_Y_Pos - PipeR;
					Randomize = 0;
					Up_or_Down = 0;
					delay_pipe_movement = 0;
					end
					else if ((Pipe_Y_Pos + PipeR) < 574) begin
					Pipe_Y_Pos = Pipe_Y_Pos + PipeR;
					Randomize = 0;
					Up_or_Down = 1;
					delay_pipe_movement = 0;
					end
					end
					end
					
					
				if(GAME_END == 1) begin //if game ending condition occurs, stop pipe movement
					Pipe_X_Motion <= 0;
				end
				 else
				 begin
					  Pipe_X_Motion <= Pipe_X_Motion;  
				 case (keycode)
					8'h2c : begin //spacebar hit
								delay_pipe_movement <= delay_pipe_movement + 1;
								if(Score < 10) begin Pipe_X_Motion <= 0 - 1; end
								else if(Score < 30 && Score > 10) begin Pipe_X_Motion <= 0 - 2; end
								else if(Score > 30) begin Pipe_X_Motion <= 0 - 3; end
							  end
					8'h15: begin // hit R
					Pipe_X_Motion <= 0;
					end
					default: ;
			   endcase
				
				end
				
				
				 
				 Pipe_Y_Pos <= (Pipe_Y_Pos);  // Update Pipe position
				 Pipe_X_Pos <= (Pipe_X_Pos + Pipe_X_Motion);
						
		end  
    end
       
    assign PipeX = Pipe_X_Pos;
   
    assign PipeY = Pipe_Y_Pos;
   
    assign PipeS = Pipe_Size;
    
endmodule


module Pipe3 (
input Reset, frame_clk,
input [7:0] keycode,
input GAME_END,
input [7:0] PipeR, Score,
output [9:0]  PipeX, PipeY, PipeS,
output [7:0] Pipe3R, Pipe3G, Pipe3B
);



logic [9:0] Pipe_X_Pos, Pipe_X_Motion, Pipe_Y_Pos, Pipe_Y_Motion, Pipe_Size, delay_pipe_movement;
logic [3:0] Pipe_Randomization;
logic [1:0] color_meter;
logic Up_or_Down, Game_Start_init, Randomize, Color_Change;
	 
    parameter [9:0] Pipe_X_Center=700;  // Center position on the X axis
    parameter [9:0] Pipe_Y_Center=240; //240 // Center position on the Y axis
    parameter [9:0] Pipe_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Pipe_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Pipe_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Pipe_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Pipe_X_Step=1;      // Step size on the X axis
    parameter [9:0] Pipe_Y_Step=1;      // Step size on the Y axis
	// parameter [3:0] Pipe_Test = 20;

    assign Pipe_Size = 50;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 //Game_Start <= 0;
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Pipe
		  if (Reset)  // Asynchronous Reset
        begin 
            Pipe_Y_Motion <= 10'd0; //Pipe_Y_Step;
				Pipe_X_Motion <= 10'd0; //Pipe_X_Step;
				Pipe_Y_Pos <= Pipe_Y_Center;
				Pipe_X_Pos <= Pipe_X_Center;
				Up_or_Down = 1;
				Randomize = 0;
				Game_Start_init = 0;
				Color_Change = 0;
				Pipe3R = 8'hff;
				Pipe3G = 8'hff;
			   Pipe3B = 8'h00;
        end
           
        else
        begin 
			if(delay_pipe_movement % 2 == 0) begin
				if(Pipe_X_Pos == 350) begin
					Randomize = 1;
				end
				if (Randomize == 1) begin
					if(Up_or_Down == 1 && ((Pipe_Y_Pos - PipeR) > 80)) begin
					Pipe_Y_Pos = Pipe_Y_Pos - PipeR;
					Randomize = 0;
					Up_or_Down = 0;
					delay_pipe_movement = 0;
					end
			   else if ((Pipe_Y_Pos + PipeR < 574)) begin 
					Pipe_Y_Pos = Pipe_Y_Pos + PipeR; 
					Randomize = 0; 
					Up_or_Down = 1; 
					delay_pipe_movement = 0; 
					end
					end
					end
			if(delay_pipe_movement % 2 == 1) begin
				if(Pipe_X_Pos == 0) begin
					Randomize = 1;
					Color_Change = 1;
					color_meter = color_meter + 1;
				end
				if (Color_Change == 1) begin
					if(color_meter == 1) begin
						Pipe3R = 8'hff;
						Pipe3G = 8'h00;
					   Pipe3B = 8'h00;
						end
					else if(color_meter == 2) begin
						Pipe3R = 8'h00;
						Pipe3G = 8'hff;
					   Pipe3B = 8'h00;
					end
					else if(color_meter == 3) begin
						Pipe3R = 8'hff;
						Pipe3G = 8'hff;
					   Pipe3B = 8'h00;
					end
					else begin
						Pipe3R = 8'h00;
						Pipe3G = 8'hff;
					   Pipe3B = 8'hff;
					end
						Color_Change = 0;
						end
				if (Randomize == 1) begin
					if(Up_or_Down == 1 && ((Pipe_Y_Pos - PipeR) > 80)) begin
					Pipe_Y_Pos = Pipe_Y_Pos - PipeR;
					Randomize = 0;
					Up_or_Down = 0;
					delay_pipe_movement = 0;
					end
					else if((Pipe_Y_Pos + PipeR) < 574) begin
					Pipe_Y_Pos = Pipe_Y_Pos + PipeR;
					Randomize = 0;
					Up_or_Down = 1;
					delay_pipe_movement = 0;
					end
					end
					end
					
					
				if(GAME_END == 1) begin //if game ending condition occurs, stop pipe movement
					Pipe_X_Motion <= 0;
				end
				 else
				 begin
					  Pipe_X_Motion <= Pipe_X_Motion;  
				 case (keycode)
					8'h2c : begin //spacebar hit
								delay_pipe_movement <= delay_pipe_movement + 1;
								if(Score < 10) begin Pipe_X_Motion <= 0 - 1; end
								else if(Score < 30 && Score > 10) begin Pipe_X_Motion <= 0 - 2; end
								else if(Score > 30) begin Pipe_X_Motion <= 0 - 3; end
							  end
					8'h15: begin // hit R
					Pipe_X_Motion <= 0;
					end
					default: ;
			   endcase
				
				end
				
				
				 
				 Pipe_Y_Pos <= (Pipe_Y_Pos);  // Update Pipe position
				 Pipe_X_Pos <= (Pipe_X_Pos + Pipe_X_Motion);
						
		end  
    end
       
    assign PipeX = Pipe_X_Pos;
   
    assign PipeY = Pipe_Y_Pos;
   
    assign PipeS = Pipe_Size;
    
endmodule

module Pipe4 (
input Reset, frame_clk,
input [7:0] keycode,
input GAME_END,
input [7:0] PipeR, Score,
output [9:0]  PipeX, PipeY, PipeS,
output [7:0] Pipe4R, Pipe4G, Pipe4B
);



logic [9:0] Pipe_X_Pos, Pipe_X_Motion, Pipe_Y_Pos, Pipe_Y_Motion, Pipe_Size, delay_pipe_movement;
logic [3:0] Pipe_Randomization;
logic [1:0] color_meter;
logic Up_or_Down, Game_Start_init, Randomize, Color_Change;
	 
    parameter [9:0] Pipe_X_Center=900;  // Center position on the X axis
    parameter [9:0] Pipe_Y_Center=240; //240 // Center position on the Y axis
    parameter [9:0] Pipe_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Pipe_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Pipe_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Pipe_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Pipe_X_Step=1;      // Step size on the X axis
    parameter [9:0] Pipe_Y_Step=1;      // Step size on the Y axis
	// parameter [3:0] Pipe_Test = 20;

    assign Pipe_Size = 50;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 //Game_Start <= 0;
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Pipe
		  if (Reset)  // Asynchronous Reset
        begin 
            Pipe_Y_Motion <= 10'd0; //Pipe_Y_Step;
				Pipe_X_Motion <= 10'd0; //Pipe_X_Step;
				Pipe_Y_Pos <= Pipe_Y_Center;
				Pipe_X_Pos <= Pipe_X_Center;
				Up_or_Down = 1;
				Randomize = 0;
				Game_Start_init = 0;
				Color_Change = 0;
				Pipe4R = 8'hff;
				Pipe4G = 8'hff;
			   Pipe4B = 8'h00;
        end
           
        else
        begin 
			if(delay_pipe_movement % 2 == 0) begin
				if(Pipe_X_Pos == 350) begin
					Randomize = 1;
				end
				if (Randomize == 1) begin
					if(Up_or_Down == 1 && ((Pipe_Y_Pos - PipeR) > 80)) begin
					Pipe_Y_Pos = Pipe_Y_Pos - PipeR;
					Randomize = 0;
					Up_or_Down = 0;
					delay_pipe_movement = 0;
					end
			   else if ((Pipe_Y_Pos + PipeR < 574)) begin 
					Pipe_Y_Pos = Pipe_Y_Pos + PipeR; 
					Randomize = 0; 
					Up_or_Down = 1; 
					delay_pipe_movement = 0; 
					end
					end
					end
			if(delay_pipe_movement % 2 == 1) begin
				if(Pipe_X_Pos == 0) begin
					Randomize = 1;
					Color_Change = 1;
					color_meter = color_meter + 1;
				end
				if (Color_Change == 1) begin
					if(color_meter == 1) begin
						Pipe4R = 8'hff;
						Pipe4G = 8'h00;
					   Pipe4B = 8'h00;
						end
					else if(color_meter == 2) begin
						Pipe4R = 8'h00;
						Pipe4G = 8'hff;
					   Pipe4B = 8'h00;
					end
					else if(color_meter == 3) begin
						Pipe4R = 8'hff;
						Pipe4G = 8'hff;
					   Pipe4B = 8'h00;
					end
					else begin
						Pipe4R = 8'h00;
						Pipe4G = 8'hff;
					   Pipe4B = 8'hff;
					end
						Color_Change = 0;
						end
				if (Randomize == 1) begin
					if(Up_or_Down == 1 && ((Pipe_Y_Pos - PipeR) > 80)) begin
					Pipe_Y_Pos = Pipe_Y_Pos - PipeR;
					Randomize = 0;
					Up_or_Down = 0;
					delay_pipe_movement = 0;
					end
					else if ((Pipe_Y_Pos + PipeR) > 574)begin
					Pipe_Y_Pos = Pipe_Y_Pos + PipeR;
					Randomize = 0;
					Up_or_Down = 1;
					delay_pipe_movement = 0;
					end
					end
					end
					
					
				if(GAME_END == 1) begin //if game ending condition occurs, stop pipe movement
					Pipe_X_Motion <= 0;
				end
				 else
				 begin
					  Pipe_X_Motion <= Pipe_X_Motion;  
				 case (keycode)
					8'h2c : begin //spacebar hit
								delay_pipe_movement <= delay_pipe_movement + 1;
								if(Score < 10) begin Pipe_X_Motion <= 0 - 1; end
								else if(Score < 30 && Score > 10) begin Pipe_X_Motion <= 0 - 2; end
								else if(Score > 30) begin Pipe_X_Motion <= 0 - 3; end
							  end
					8'h15: begin // hit R
					Pipe_X_Motion <= 0;
					end
					default: ;
			   endcase
				
				end
				
				
				 
				 Pipe_Y_Pos <= (Pipe_Y_Pos);  // Update Pipe position
				 Pipe_X_Pos <= (Pipe_X_Pos + Pipe_X_Motion);
						
		end  
    end
       
    assign PipeX = Pipe_X_Pos;
   
    assign PipeY = Pipe_Y_Pos;
   
    assign PipeS = Pipe_Size;
    
endmodule



/*
	This design for the randomization of the pipe Y coordinate is based off of a Linear-feedback shift register,
	This design inspiration came from: https://en.wikipedia.org/wiki/Linear-feedback_shift_register
	This design is modified to utilize the 10 bits from the Pipe positions and hard codes the 2 Most
	Significant bits to ensure proper behavior
*/
module Randomize (

// hardcode MSB to 0
input Reset, frame_clk,
input[9:0] Pipe_Position,
input[2:0] beat1, beat2, beat3, beat4,
input[9:0] PipeX,
output[7:0] Rand_Pipe_Position
);

logic [9:0] Temp_Pipe_Position, Temp_Pipe_Position0;
 always_ff @ (posedge Reset or posedge frame_clk) begin
	if(Reset) begin
	
	end
	else begin
	if(PipeX == 0) begin
		Temp_Pipe_Position = ((Pipe_Position >> beat1) ^ (Pipe_Position >> beat2) ^ (Pipe_Position >> beat3) ^ (Pipe_Position >> beat4)) & 1'b1;
		Temp_Pipe_Position0 = (Pipe_Position >> 1) | (Temp_Pipe_Position << 6);
	end
		//Temp_Pipe_Position0[9:8] = 2'b00;
	end
	end

	assign Rand_Pipe_Position = Temp_Pipe_Position0;

endmodule

