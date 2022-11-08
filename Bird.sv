module Bird (
input Reset, frame_clk,
input [7:0] keycode,
output [9:0]  BirdX, BirdY, BirdS
);

    logic [9:0] Bird_X_Pos, Bird_X_Motion, Bird_Y_Pos, Bird_Y_Motion, Bird_Size, Bird_Dy_Motion, Gravity;
	 
    parameter [9:0] Bird_X_Center= 160;  // Left-Center position on the X axis
    parameter [9:0] Bird_Y_Center= 240;  // Center position on the Y axis
    parameter [9:0] Bird_X_Min= 0;       // Leftmost point on the X axis
    parameter [9:0] Bird_X_Max= 639;     // Rightmost point on the X axis
    parameter [9:0] Bird_Y_Min= 0;       // Topmost point on the Y axis
    parameter [9:0] Bird_Y_Max= 479;     // Bottommost point on the Y axis
    parameter [9:0] Bird_X_Step= 1;      // Step size on the X axis
    parameter [9:0] Bird_Y_Step= 1;      // Step size on the Y axis

	 assign Ball_Size = 4;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 //assign Bird_Dy_Motion = 0; // set motion of y direction of bird to be non-constant
	 assign Gravity = 1; //assign gravity like constant to make the bird feel like it has weight
	 
	 always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Bird
        if (Reset)  // Asynchronous Reset
        begin 
            Bird_Y_Motion <= 10'd0; //Ball_Y_Step;
				Bird_X_Motion <= 10'd0; //Ball_X_Step;
				Bird_Y_Pos <= Bird_Y_Center;
				Bird_X_Pos <= Bird_X_Center;
        end
		  
        else 
        begin 
				 if ( (Bird_Y_Pos + Bird_Size) >= Bird_Y_Max )  ;// Bird is at the bottom edge, end game
					  //End game condition here 
					  
				 else if ( (Bird_Y_Pos - Bird_Size) <= Bird_Y_Min )  ;// Bird is at the top edge, end game
					  //End game condition here
					  
				  // Bird should never reach right or left edge of the screen, no checks needed
					  
				 else
				 begin
					  Bird_Dy_Motion <= Bird_Dy_Motion + Gravity; // add gravity to bird to make it move down eventually
					  Bird_Y_Motion <= Bird_Y_Motion - Bird_Dy_Motion;  // Bird is somewhere in the middle, don't bounce, just keep moving
				 case (keycode)
					8'h44 : begin //Spacebar hit 

								Bird_X_Motion <= 0; 
								Bird_Y_Motion<= 2;
							  end
					        
					/* 8'h07 : begin
								
					        Ball_X_Motion <= 1;//D
							  Ball_Y_Motion <= 0;
							  end

							  
					8'h16 : begin

					        Ball_Y_Motion <= 1;//S
							  Ball_X_Motion <= 0;
							 end
							  
					8'h1A : begin
					        Ball_Y_Motion <= -1;//W
							  Ball_X_Motion <= 0;
							 end	  
					default: ; */ //Can incorporate keycodes to reset/start/move screens
			   endcase
				
				end
				
				
				 
				 Bird_Y_Pos <= (Bird_Y_Pos + Bird_Y_Motion);  // Update ball position
				 Bird_X_Pos <= (Bird_X_Pos + Bird_X_Motion);
			
			
			
		end  
    end
       
    assign BirdX = Bird_X_Pos;
   
    assign BirdY = Bird_Y_Pos;
   
    assign BirdS = Bird_Size;
    

endmodule
