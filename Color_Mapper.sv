//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input        [9:0] BirdX, BirdY, DrawX, DrawY, Bird_size,
                       output logic [7:0]  Red, Green, Blue );
    
    logic bird_on;
	 
 /*
     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 12 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
	  
    int DistX, DistY, Size;
	 int a, b;
	 assign DistX = DrawX - BirdX;
    assign DistY = DrawY - BirdY;
    assign Size = Bird_size;
	 assign a = Size + 4;  //may need to change 
	 assign b = Size + 2; //may need to change
	  
    always_comb
    begin:Ball_on_proc
        if ( ( ((DistX*DistX)/a) + ((DistY*DistY)/b)) <= 1 ) //( DistX*DistX + DistY*DistY) <= (Size * Size)
            bird_on = 1'b1;
        else 
            bird_on = 1'b0;
     end 
       
    always_comb
    begin:RGB_Display
        if ((bird_on == 1'b1)) 
        begin 
            Red = 8'hff;
            Green = 8'hff;
            Blue = 8'h11;
        end       
        else if(DrawY <= 200)
        begin 
            Red = 8'hff; 
            Green = 8'hff;
            Blue = 8'hff;
        end 
		  else if(DrawY <= 400)
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
