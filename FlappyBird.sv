module FlappyBird (

      input     MAX10_CLK1_50, 
      input    [ 1: 0]   KEY,
      output   [ 9: 0]   LEDR,
      output             DRAM_CLK,
      output             DRAM_CKE,
      output   [12: 0]   DRAM_ADDR,
      output   [ 1: 0]   DRAM_BA,
      inout    [15: 0]   DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_UDQM,
      output             DRAM_CS_N,
      output             DRAM_WE_N,
      output             DRAM_CAS_N,
      output             DRAM_RAS_N,
      output             VGA_HS,
      output             VGA_VS,
      output   [ 3: 0]   VGA_R,
      output   [ 3: 0]   VGA_G,
      output   [ 3: 0]   VGA_B,
      inout    [15: 0]   ARDUINO_IO,
      inout              ARDUINO_RESET_N,
		output   [ 7: 0]   HEX0,
      output   [ 7: 0]   HEX1,
      output   [ 7: 0]   HEX2,
      output   [ 7: 0]   HEX3,
      output   [ 7: 0]   HEX4,
      output   [ 7: 0]   HEX5



);

logic Reset_h, vssig, blank, sync, VGA_Clk;


//=======================================================
//  REG/WIRE declarations
//=======================================================
	logic SPI0_CS_N, SPI0_SCLK, SPI0_MISO, SPI0_MOSI, USB_GPX, USB_IRQ, USB_RST;
	logic [3:0] hex_num_4, hex_num_3, hex_num_1, hex_num_0; //4 bit input hex digits
	logic [7:0] randomizer_p1, randomizer_p2, randomizer_p3, randomizer_p4;
	logic [1:0] signs;
	logic [1:0] hundreds;
	logic [9:0] dx, dy, birdx, birdy, birdsize; //Bird initialization
	logic [9:0] p1x,p1y,p1size; //Pipe 1 init
	logic [9:0] p2x, p2y, p2size; // Pipe 2 init
	logic [9:0] p3x, p3y, p3size; // Pipe 3 init
	logic [9:0] p4x, p4y, p4size; // Pipe 4 init
	logic [7:0] Score_Current, Score_High;
	logic [7:0] Red, Blue, Green, p1r,p1g,p1b,p2r,p2g,p2b,p3r,p3g,p3b,p4r,p4g,p4b; // RGB (TO BE REPLACED)
	logic [7:0] keycode; //Keycode for keyboard
	logic end_condition; // Game end condition

//=======================================================
//  Structural coding
//=======================================================
	assign ARDUINO_IO[10] = SPI0_CS_N;
	assign ARDUINO_IO[13] = SPI0_SCLK;
	assign ARDUINO_IO[11] = SPI0_MOSI;
	assign ARDUINO_IO[12] = 1'bZ;
	assign SPI0_MISO = ARDUINO_IO[12];
	
	assign ARDUINO_IO[9] = 1'bZ; 
	assign USB_IRQ = ARDUINO_IO[9];
		
	//Assignments specific to Circuits At Home UHS_20
	assign ARDUINO_RESET_N = USB_RST;
	assign ARDUINO_IO[7] = USB_RST;//USB reset 
	assign ARDUINO_IO[8] = 1'bZ; //this is GPX (set to input)
	assign USB_GPX = 1'b0;//GPX is not needed for standard USB host - set to 0 to prevent interrupt
	
	//Assign uSD CS to '1' to prevent uSD card from interfering with USB Host (if uSD card is plugged in)
	assign ARDUINO_IO[6] = 1'b1;
	
	
	//HEX drivers to convert numbers to HEX output for scorekeeping
	HexDriver hex_driver0 (.In0(Score_Current[3:0]), .Out0(HEX0));
	HexDriver hex_driver1 (.In0(Score_Current[7:4]), .Out0(HEX1));
	HexDriver hex_driver2 (.In0(Score_High[3:0]), .Out0(HEX2));
	HexDriver hex_driver3 (.In0(Score_High[7:4]), .Out0(HEX3));
	HexDriver hex_driver4 (.In0(4'b1011), .Out0(HEX4));
	HexDriver hex_driver5 (.In0(4'b1111), .Out0(HEX5));
	
	//Assign one button to reset
	assign {Reset_h}=~ (KEY[0]);

	//Our A/D converter is only 12 bit
	assign VGA_R = Red[7:4];
	assign VGA_B = Blue[7:4];
	assign VGA_G = Green[7:4];



FlappyBird_soc u0 (
		.clk_clk                           (MAX10_CLK1_50),  //clk.clk
		.reset_reset_n                     (1'b1),           //reset.reset_n
		.altpll_0_locked_conduit_export    (),               //altpll_0_locked_conduit.export
		.altpll_0_phasedone_conduit_export (),               //altpll_0_phasedone_conduit.export
		.altpll_0_areset_conduit_export    (),               //altpll_0_areset_conduit.export
		.key_external_connection_export    (KEY),            //key_external_connection.export

		//SDRAM
		.sdram_clk_clk(DRAM_CLK),                            //clk_sdram.clk
		.sdram_wire_addr(DRAM_ADDR),                         //sdram_wire.addr
		.sdram_wire_ba(DRAM_BA),                             //.ba
		.sdram_wire_cas_n(DRAM_CAS_N),                       //.cas_n
		.sdram_wire_cke(DRAM_CKE),                           //.cke
		.sdram_wire_cs_n(DRAM_CS_N),                         //.cs_n
		.sdram_wire_dq(DRAM_DQ),                             //.dq
		.sdram_wire_dqm({DRAM_UDQM,DRAM_LDQM}),              //.dqm
		.sdram_wire_ras_n(DRAM_RAS_N),                       //.ras_n
		.sdram_wire_we_n(DRAM_WE_N),                         //.we_n

		//USB SPI	
		.spi0_SS_n(SPI0_CS_N),
		.spi0_MOSI(SPI0_MOSI),
		.spi0_MISO(SPI0_MISO),
		.spi0_SCLK(SPI0_SCLK),
		
		//USB GPIO
		.usb_rst_export(USB_RST),
		.usb_irq_export(USB_IRQ),
		.usb_gpx_export(USB_GPX),
		
		//LEDs and HEX
		.hex_digits_export({4'b0010,4'b0010, 4'b0010,4'b0010}),
		.leds_export({hundreds, signs, LEDR}),
		.keycode_export(keycode)
		
	 );

Bird u1 (
		.Reset(Reset_h),
		.frame_clk(VGA_VS), //VGA_Clk
		.keycode(keycode),
		.Pipe1X(p1x),
		.Pipe1Y(p1y),
		.Pipe2X(p2x),
		.Pipe2Y(p2y),
		.Pipe3X(p3x),
		.Pipe3Y(p3y),
		.Pipe4X(p4x),
		.Pipe4Y(p4y),
		.GAME_END(end_condition),
		.Current_Score(Score_Current),
		.High_Score(Score_High),
		.BirdX(birdx),
		.BirdY(birdy), 
		.BirdS(birdsize)
);

Pipe1 p1 (
		.Reset(Reset_h),
		.frame_clk(VGA_VS), //VGA_Clk
		.keycode(keycode),
		.GAME_END(end_condition),
		.PipeR(randomizer_p1),
		.PipeX(p1x),
		.PipeY(p1y), 
		.PipeS(p1size),
		.Pipe1R(p1r),
		.Pipe1G(p1g),
		.Pipe1B(p1b),
		.Score(Score_Current)
);

Pipe2 p2 (
		.Reset(Reset_h),
		.frame_clk(VGA_VS), //VGA_Clk
		.keycode(keycode),
		.GAME_END(end_condition),
		.PipeR(randomizer_p2),
		.PipeX(p2x),
		.PipeY(p2y), 
		.PipeS(p2size),
		.Pipe2R(p2r),
		.Pipe2G(p2g),
		.Pipe2B(p2b),
		.Score(Score_Current)
);

Pipe3 p3 (
		.Reset(Reset_h),
		.frame_clk(VGA_VS), //VGA_Clk
		.keycode(keycode),
		.GAME_END(end_condition),
		.PipeR(randomizer_p3),
		.PipeX(p3x),
		.PipeY(p3y), 
		.PipeS(p3size),
		.Pipe3R(p3r),
		.Pipe3G(p3g),
		.Pipe3B(p3b),
		.Score(Score_Current)
);

Pipe4 p4 (
		.Reset(Reset_h),
		.frame_clk(VGA_VS), //VGA_Clk
		.keycode(keycode),
		.GAME_END(end_condition),
		.PipeR(randomizer_p4),
		.PipeX(p4x),
		.PipeY(p4y), 
		.PipeS(p4size),
		.Pipe4R(p4r),
		.Pipe4G(p4g),
		.Pipe4B(p4b),
		.Score(Score_Current)
);


vga_controller vga_controller(
		.Clk(MAX10_CLK1_50),
		.Reset(Reset_h),
		.pixel_clk(VGA_CLK), 
		.vs(VGA_VS),
		.hs(VGA_HS),
		.blank(blank),
		.sync(sync),
		.DrawX(dx),
		.DrawY(dy),
		
);

color_mapper color_mapper(
		.BirdX(birdx), 
		.BirdY(birdy), 
		.DrawX(dx), 
		.DrawY(dy), 
		.Bird_size(birdsize),
		.Pipe1X(p1x), 
		.Pipe1Y(p1y), 
		.Pipe1Size(p1size),
		.Pipe2X(p2x), 
		.Pipe2Y(p2y), 
		.Pipe2Size(p2size),
		.Pipe3X(p3x), 
		.Pipe3Y(p3y), 
		.Pipe3Size(p3size),
		.Pipe4X(p4x), 
		.Pipe4Y(p4y), 
		.Pipe4Size(p4size),
		.Pipe1R(p1r),
		.Pipe1G(p1g),
		.Pipe1B(p1b),
		.Pipe2R(p2r),
		.Pipe2G(p2g),
		.Pipe2B(p2b),
		.Pipe3R(p3r),
		.Pipe3G(p3g),
		.Pipe3B(p3b),
		.Pipe4R(p4r),
		.Pipe4G(p4g),
		.Pipe4B(p4b),
		.Red(Red), //VGA_R
		.Green(Green), //VGA_G
		.Blue(Blue) //VGA_B
);

Randomize randomizer_pipe1(
	.Reset(Reset_h),
	.frame_clk(VGA_VS),
	.Pipe_Position(p1y),
	.beat1(3'b001),
	.beat2(3'b011),
	.beat3(3'b101),
	.beat4(3'b111),
	.PipeX(p1x),
	.Rand_Pipe_Position(randomizer_p1)
);

Randomize randomizer_pipe2(
	.Reset(Reset_h),
	.frame_clk(VGA_VS),
	.Pipe_Position(p2y),
	.beat1(3'b010),
	.beat2(3'b001),
	.beat3(3'b100),
	.beat4(3'b101),
	.PipeX(p2x),
	.Rand_Pipe_Position(randomizer_p2)
);
	
Randomize randomizer_pipe3(
	.Reset(Reset_h),
	.frame_clk(VGA_VS),
	.Pipe_Position(p3y),
	.beat1(3'b101),
	.beat2(3'b111),
	.beat3(3'b010),
	.beat4(3'b110),
	.PipeX(p3x),
	.Rand_Pipe_Position(randomizer_p3)
);

Randomize randomizer_pipe4(
	.Reset(Reset_h),
	.frame_clk(VGA_VS),
	.Pipe_Position(p4y),
	.beat1(3'b000),
	.beat2(3'b101),
	.beat3(3'b111),
	.beat4(3'b001),
	.PipeX(p4x),
	.Rand_Pipe_Position(randomizer_p4)
);
	
	
	


endmodule 