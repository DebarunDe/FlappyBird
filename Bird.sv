module Bird (
input Reset, frame_clk,
input [7:0] keycode,
input [9:0] Pipe1X, Pipe1Y, Pipe2X,Pipe2Y, Pipe3X,Pipe3Y, Pipe4X,Pipe4Y,
output GAME_END,
output [7:0] Current_Score, High_Score,
output [9:0]  BirdX, BirdY, BirdS
);



logic [9:0] Bird_X_Pos, Bird_X_Motion, Bird_Y_Pos, Bird_Y_Motion, Bird_Size, Bird_DY_Motion, Gravity;
logic [7:0] Current_Score_ip, High_Score_ip;
logic [1:0] delay; 
logic Game_Start, Game_End, Scored_Once_Pipe1, Scored_Once_Pipe2, Scored_Once_Pipe3, Scored_Once_Pipe4, Stop;
	 
    parameter [9:0] Bird_X_Center=120;  // Center position on the X axis
    parameter [9:0] Bird_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Bird_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Bird_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Bird_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Bird_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Bird_X_Step=1;      // Step size on the X axis
    parameter [9:0] Bird_Y_Step=1;      // Step size on the Y axis

    assign Bird_Size = 7;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 //Game_Start <= 0;
	 
//	 assign Pipe1_X_Pos = Pipe1X;
//	 assign Pipe1_Y_Pos = Pipe1Y;
   
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Bird
        if (Reset)  // Asynchronous Reset
        begin 
            Bird_Y_Motion <= 10'd0; //Bird_Y_Step;
				Bird_X_Motion <= 10'd0; //Bird_X_Step;
				Bird_DY_Motion <= 10'd0;
				Bird_Y_Pos <= Bird_Y_Center;
				Bird_X_Pos <= Bird_X_Center;
				Current_Score_ip <= 0;
				Scored_Once_Pipe1 <= 0;
				Scored_Once_Pipe2 <= 0;
				Scored_Once_Pipe3 <= 0;
				Scored_Once_Pipe4 <= 0;
				Game_End <= 0;
        end
           
        else
        begin 
				  // Score calculation to see if High score should be changed
				 if (Game_End == 1) begin
						Bird_Y_Motion <= 0;
						if(Current_Score_ip > High_Score_ip) High_Score_ip <= Current_Score_ip;
					  
					  end
					  
				 else if ( (Bird_Y_Pos + Bird_Size) >= Bird_Y_Max )begin  // Bird is at the bottom edge, Gameover
					  Bird_Y_Motion <= 0;  
					  Game_Start <= 0;
					  Game_End <= 1;
					  end
					  
				 else if ( (Bird_Y_Pos + Bird_Size) <= Bird_Y_Min ) begin  // Bird is at the top edge, Gameover
					  Bird_Y_Motion <= 0;
					  Game_Start <= 0;
					  Game_End <= 1;
					  end
					  
					  
					  // Collision with pipes
					  
				else if ((((Bird_X_Pos + Bird_Size) - 5 <= Pipe1X + 25) && ((Bird_X_Pos + Bird_Size) + 5 >= Pipe1X - 25))  && ((Bird_Y_Pos - Bird_Size + 15) >= Pipe1Y + 75 || (Bird_Y_Pos + Bird_Size - 15) <= Pipe1Y - 75)) begin	//Bird hits pipe1 on x coord, Gameover
						Bird_Y_Motion <= 0;
					  Game_Start <= 0;
					  Game_End <= 1;
					  end
				else if ((((Bird_X_Pos + Bird_Size - 5) <= Pipe2X + 25) && ((Bird_X_Pos + Bird_Size + 5) >= Pipe2X - 25))  && ((Bird_Y_Pos - Bird_Size + 15) >= Pipe2Y + 75 || (Bird_Y_Pos + Bird_Size - 15) <= Pipe2Y - 75)) begin	//Bird hits pipe1 on y coord, Gameover
						Bird_Y_Motion <= 0;
					  Game_Start <= 0;
					  Game_End <= 1;
					  end
					  
			   else if ((((Bird_X_Pos + Bird_Size - 5) <= Pipe3X + 25) && ((Bird_X_Pos + Bird_Size + 5) >= Pipe3X - 25))  && ((Bird_Y_Pos - Bird_Size + 15) >= Pipe3Y + 75 || (Bird_Y_Pos + Bird_Size - 15) <= Pipe3Y - 75)) begin	//Bird hits pipe1 on y coord, Gameover
						Bird_Y_Motion <= 0;
					  Game_Start <= 0;
					  Game_End <= 1;
					  end
				
				else if ((((Bird_X_Pos + Bird_Size - 5) <= Pipe4X + 25) && ((Bird_X_Pos + Bird_Size + 5) >= Pipe4X - 25))  && ((Bird_Y_Pos - Bird_Size + 15) >= Pipe4Y + 75 || (Bird_Y_Pos + Bird_Size - 15) <= Pipe4Y - 75)) begin	//Bird hits pipe1 on y coord, Gameover
						Bird_Y_Motion <= 0;
					  Game_Start <= 0;
					  Game_End <= 1;
					  end

					  
				//Scoring through pipes, pipe 1
				else if (Game_End != 1 && 
				(((Bird_X_Pos + Bird_Size) <= Pipe1X + 25) && ((Bird_X_Pos + Bird_Size) >= Pipe1X - 25))  && 
				((Bird_Y_Pos + Bird_Size) <= Pipe1Y + 75 || (Bird_Y_Pos + Bird_Size) >= Pipe1Y - 75) &&
				Scored_Once_Pipe1 == 0) begin
							Current_Score_ip <= Current_Score_ip + 1;
							Scored_Once_Pipe1 <= 1;
							Scored_Once_Pipe2 <= 0;
					  end
				//Pipe 2
				else if (Game_End != 1 && 
				(((Bird_X_Pos + Bird_Size) <= Pipe2X + 25) && ((Bird_X_Pos + Bird_Size) >= Pipe2X - 25))  && 
				((Bird_Y_Pos + Bird_Size) <= Pipe2Y + 75 || (Bird_Y_Pos + Bird_Size) >= Pipe2Y - 75) &&
				Scored_Once_Pipe2 == 0) begin
							Current_Score_ip <= Current_Score_ip + 1;
							Scored_Once_Pipe2 <= 1;
							Scored_Once_Pipe3 <= 0;
					  end
				//Pipe 3
				else if (Game_End != 1 && 
				(((Bird_X_Pos + Bird_Size) <= Pipe3X + 25) && ((Bird_X_Pos + Bird_Size) >= Pipe3X - 25))  && 
				((Bird_Y_Pos + Bird_Size) <= Pipe3Y + 75 || (Bird_Y_Pos + Bird_Size) >= Pipe3Y - 75) &&
				Scored_Once_Pipe3 == 0) begin
							Current_Score_ip <= Current_Score_ip + 1;
							Scored_Once_Pipe3 <= 1;
							Scored_Once_Pipe4 <= 0;
					  end
				//Pipe 4
				else if (Game_End != 1 && 
				(((Bird_X_Pos + Bird_Size) <= Pipe4X + 25) && ((Bird_X_Pos + Bird_Size) >= Pipe4X - 25))  && 
				((Bird_Y_Pos + Bird_Size) <= Pipe4Y + 75 || (Bird_Y_Pos + Bird_Size) >= Pipe4Y - 75) &&
				Scored_Once_Pipe4 == 0) begin
							Current_Score_ip <= Current_Score_ip + 1;
							Scored_Once_Pipe4 <= 1;
							Scored_Once_Pipe1 <= 0;
					  end
					  
				 else
				 begin
					  Bird_Y_Motion <= Bird_Y_Motion;  
				 case (keycode)
					8'h2c : begin //spacebar hit
								Bird_DY_Motion <= 0 - 3;
								Bird_X_Motion <= 0; 
								Bird_Y_Motion <= Bird_DY_Motion;
								Gravity <= 1;
								Game_Start <= 1;
								Stop = 0;
							  end
					8'h16 : begin // hit S
				Bird_Y_Motion <= 10'd0; //Bird_Y_Step;
				Bird_X_Motion <= 10'd0; //Bird_X_Step;
				Bird_DY_Motion <= 10'd0;
				Bird_Y_Pos <= Bird_Y_Center;
				Bird_X_Pos <= Bird_X_Center;
				Game_Start <= 0;
							 end  
					8'h15: begin // hit R
						 Bird_Y_Motion <= 10'd0; //Bird_Y_Step;
				Bird_X_Motion <= 10'd0; //Bird_X_Step;
				Bird_DY_Motion <= 10'd0;
				Bird_Y_Pos <= Bird_Y_Center;
				Bird_X_Pos <= Bird_X_Center;
				Current_Score_ip <= 0;
				Scored_Once_Pipe1 <= 0;
				Scored_Once_Pipe2 <= 0;
				Scored_Once_Pipe3 <= 0;
				Scored_Once_Pipe4 <= 0;
				Gravity = 0;
				Stop = 1;
					end
					default: 
						begin
					if(Game_Start == 1 && Stop == 0) begin
						delay = delay + 1;
							//Gravity Test
						if(delay == 3)
						begin
							Gravity <= Gravity + 1;
							Bird_DY_Motion <= Bird_Y_Motion + (Gravity/8);
							Bird_X_Motion <= 0;
							Bird_Y_Motion <= Bird_DY_Motion;
							delay = 0;
						end
						else begin
							Bird_Y_Motion <= Bird_DY_Motion;
						end
						end
//							Bird_DY_Motion <= 4;
//							Bird_Y_Motion <= Bird_DY_Motion;
						end
			   endcase
				
				end
				
				
				 
				 Bird_Y_Pos <= (Bird_Y_Pos + Bird_Y_Motion);  // Update Bird position
				 Bird_X_Pos <= (Bird_X_Pos + Bird_X_Motion);
				 GAME_END <= Game_End; //game end condition to be sent to pipe
						
		end  
    end
       
    assign BirdX = Bird_X_Pos;
   
    assign BirdY = Bird_Y_Pos;
   
    assign BirdS = Bird_Size;
	 
	 assign Current_Score = Current_Score_ip;
	 
	 assign High_Score = High_Score_ip;
    
endmodule 