module  color_mapper ( input        [9:0] BirdX, BirdY, DrawX, DrawY, Bird_size, 
Pipe1X, Pipe1Y, Pipe1Size, 
Pipe2X, Pipe2Y, Pipe2Size, 
Pipe3X, Pipe3Y, Pipe3Size,
Pipe4X, Pipe4Y, Pipe4Size,

input[7:0] Pipe1R, Pipe1G, Pipe1B,
Pipe2R, Pipe2G, Pipe2B,
Pipe3R, Pipe3G, Pipe3B,
Pipe4R, Pipe4G, Pipe4B,
output logic [7:0]  Red, Green, Blue );
    
    logic bird_on;
	 logic pipe1_on;
	 logic pipe2_on;
	 logic pipe3_on;
	 logic pipe4_on;
	  //logic [9:0] DrawPX, DrawPY;

    int DistX, DistY, Size;
	 assign DistX = DrawX - BirdX;
    assign DistY = DrawY - BirdY;
    assign Size1 = Bird_size;
	 
	 
	 int Dist1X, Dist1Y, Size1;
	 assign Dist1X = DrawX - Pipe1X;
    assign Dist1Y = DrawY - Pipe1Y;
    assign Size2 = Pipe1Size;
	 
	 
	 assign P1L = DrawX - Pipe1X;
	 assign P1R = DrawX + Pipe1X;
	 assign Size_Pipe = Pipe1Size;
	 assign P1T = Pipe1Y + (Size * 3);
	 assign P1B = Pipe1Y - (Size * 3);
	 
	 assign P2L = DrawX - Pipe1X;
	 assign P2R = DrawX + Pipe1X;
	 assign Size_Pipe2 = Pipe2Size;
	 assign P2T = Pipe1Y + (Size * 3);
	 assign P2B = Pipe1Y - (Size * 3);
	 
	 always_comb
    begin:Bird_on_proc
        if ( ( DistX*DistX + DistY*DistY) <= (Size1 * Size1) || (((DrawX == (BirdX + 7) && (DrawY >= BirdY - 5 && DrawY <= BirdY + 5))) || ((DrawX == (BirdX + 8) && (DrawY >= BirdY - 5 && DrawY <= BirdY + 5))) || ((DrawX == (BirdX + 9) && (DrawY >= BirdY - 4 && DrawY <= BirdY + 4))) || ((DrawX == (BirdX + 10) && (DrawY >= BirdY - 4 && DrawY <= BirdY + 4))) || ((DrawX == (BirdX + 11) && (DrawY >= BirdY - 3 && DrawY <= BirdY + 3)))  || ((DrawX == (BirdX + 12) && (DrawY >= BirdY - 2 && DrawY <= BirdY + 2))) |
                 ((DrawX == (BirdX + 13) && (DrawY >= BirdY - 1 && DrawY <= BirdY + 1))))) //( DistX*DistX + DistY*DistY) <= (Size * Size)
            bird_on = 1'b1;
        else 
            bird_on = 1'b0;
     end 
	  //Dist1X <= (Size2 * Size2)
	   always_comb
	 begin:Pipe1_on_proc
    if ( (DrawX <= Pipe1X + 25 && DrawX >= Pipe1X - 25)  && (DrawY >= Pipe1Y + 75 || DrawY <= Pipe1Y - 75)) //P1L <= DrawX && P1R >= DrawX... (DrawX >= Pipe1X - Size_Pipe) && (DrawX <= Pipe1X + Size_Pipe) && (DrawY >= Pipe1Y - Size_Pipe) &&
      // (DrawY <= Pipe1Y + Size_Pipe)
			pipe1_on = 1'b1;
		else
				pipe1_on = 1'b0;
	end
		always_comb
		begin:Pipe2_on_proc
    if ( (DrawX <= Pipe2X + 25 && DrawX >= Pipe2X - 25)  && (DrawY >= Pipe2Y + 75 || DrawY <= Pipe2Y - 75)) //P1L <= DrawX && P1R >= DrawX... (DrawX >= Pipe1X - Size_Pipe) && (DrawX <= Pipe1X + Size_Pipe) && (DrawY >= Pipe1Y - Size_Pipe) &&
      // (DrawY <= Pipe1Y + Size_Pipe)
			pipe2_on = 1'b1;
		else
				pipe2_on = 1'b0;
	end
		always_comb
		begin:Pipe3_on_proc
    if ( (DrawX <= Pipe3X + 25 && DrawX >= Pipe3X - 25)  && (DrawY >= Pipe3Y + 75 || DrawY <= Pipe3Y - 75)) //P1L <= DrawX && P1R >= DrawX... (DrawX >= Pipe1X - Size_Pipe) && (DrawX <= Pipe1X + Size_Pipe) && (DrawY >= Pipe1Y - Size_Pipe) &&
      // (DrawY <= Pipe1Y + Size_Pipe)
			pipe3_on = 1'b1;
		else
				pipe3_on = 1'b0;
	end
		always_comb
		begin:Pipe4_on_proc
    if ( (DrawX <= Pipe4X + 25 && DrawX >= Pipe4X - 25)  && (DrawY >= Pipe4Y + 75 || DrawY <= Pipe4Y - 75)) //P1L <= DrawX && P1R >= DrawX... (DrawX >= Pipe1X - Size_Pipe) && (DrawX <= Pipe1X + Size_Pipe) && (DrawY >= Pipe1Y - Size_Pipe) &&
      // (DrawY <= Pipe1Y + Size_Pipe)
			pipe4_on = 1'b1;
		else
				pipe4_on = 1'b0;
	end
	  
    always_comb
    begin:RGB_Display
        if ((bird_on == 1'b1)) 
         begin 
                if (((DrawX == (BirdX + 8) && (DrawY >= BirdY - 5 && DrawY <= BirdY + 5))) || ((DrawX == (BirdX + 9) && (DrawY >= BirdY - 4 && DrawY <= BirdY + 4))) || ((DrawX == (BirdX + 10) && (DrawY >= BirdY - 4 && DrawY <= BirdY + 4))) || ((DrawX == (BirdX + 11) && (DrawY >= BirdY - 3 && DrawY <= BirdY + 3)))  || ((DrawX == (BirdX + 12) && (DrawY >= BirdY - 2 && DrawY <= BirdY + 2))) ||
                 ((DrawX == (BirdX + 13) && (DrawY >= BirdY - 1 && DrawY <= BirdY + 1)))) begin
                    Red = 8'hff;
                    Green = 8'hff;
                    Blue = 8'h00;
                end 
                else if (DrawX >= BirdX - 2 && DrawX <= BirdX + 2 && DrawY >= BirdY - 2 && DrawY <= BirdY + 2)begin
                    Red = 8'h00;
                    Green = 8'h00;
                    Blue = 8'h00;
                end 
                else
                 begin
            Red = 8'hff;
            Green = 8'h55;
            Blue = 8'h00;
                end
        end 
		 else if((pipe1_on == 1'b1))
		  begin
				Red = Pipe1R;
				Green = Pipe1G;
				Blue = Pipe1B;
				end
		else if((pipe2_on == 1'b1))
		  begin
				Red = Pipe2R;
				Green = Pipe2G;
				Blue = Pipe2B;
				end
		else if((pipe3_on == 1'b1))
		  begin
				Red = Pipe3R;
				Green = Pipe3G;
				Blue = Pipe3B;
				end
		else if((pipe4_on == 1'b1))
		  begin
				Red = Pipe4R;
				Green = Pipe4G;
				Blue = Pipe4B;
				end

          else if(DrawY < 400)
        begin 
            Red = 8'h00; 
            Green = 8'h00;
            Blue = 8'hff;
        end 
          else
          begin 
                Red = 8'h00; 
                Green = 8'hff;
                Blue = 8'h00;
          end
		  end
       

endmodule
