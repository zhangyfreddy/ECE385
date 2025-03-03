module KarateChamp( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1,   //,HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK      //SDRAM Clock
                    );
    
    logic Reset_h, Clk;
    logic [31:0] keycode;
	 logic [9:0] DrawX, DrawY;
	 logic [1:0] char2, char1;
	 logic [2:0] back;
	 logic title, is_title;
    
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
    end
    
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
	 logic a_on, d_on, g_on, h_on, l_on, r_on, one_on, two_on;
    
    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );
     
     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     nios_system nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_export(keycode),  
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset)
    );
    
    // Use PLL to generate the 25MHZ VGA_CLK.
    // You will have to generate it on your own in simulation.
    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));
    
    // TODO: Fill in the connections for the rest of the modules 
    VGA_controller vga_controller_instance(.Clk,
														 .Reset(Reset_h),
														 .VGA_HS,
														 .VGA_VS,
														 .VGA_CLK,
														 .VGA_BLANK_N,
														 .VGA_SYNC_N,
														 .DrawX,
														 .DrawY
	 );
    
	 title_screen opener(.Clk,
							  .Reset(Reset_h),
							  .keypress(enter_on),
							  .DrawX,
							  .DrawY,
							  .is_char(title),
							  .is_title
							  );
    // Which signal should be frame_clk?
    character_two char_two(.Clk,
							  .Reset(Reset_h),
							  .frame_clk(VGA_VS),
							  .DrawX,
							  .DrawY,
							  .enter(enter_on),
							  .left(l_on), .right(r_on), .punch(one_on), .kick(two_on), .hurt(hit2),
							  .is_char(char2),
							  .is_title,
							  .position(x2),
							  .punching(punch2), .kicking(kick2)
							  );
							
	 character_one char_one(.Clk,
							  .Reset(Reset_h),
							  .frame_clk(VGA_VS),
							  .DrawX,
							  .DrawY,
							  .enter(enter_on),
							  .left(a_on), .right(d_on), .punch(g_on), .kick(h_on), .hurt(hit1),
							  .is_char(char1),
							  .is_title,
							  .position(x1),
							  .punching(punch1), .kicking(kick1),
							  );
							  
	 background background_color(.Clk,
						  .Reset(Reset_h),
						  .frame_clk(VGA_VS),
						  .DrawX,
						  .DrawY,
						  .is_back(back)
						  );
    
    color_mapper color_instance( .is_char2(char2),
											.is_char1(char1),
											.is_title(title),
											.is_back(back),
											.is_win(is_end),
											.DrawX,
											.DrawY,
											.VGA_R,
											.VGA_B,
											.VGA_G);
	
	 win_con winner(.Clk,
						 .Reset(Reset_h),
						 .score1, .score2,
						 .DrawX, .DrawY,
						 .is_end);
    
	 logic [9:0] x1, x2;
	 logic punch1, punch2, kick1, kick2, hit1, hit2;
	 logic [3:0] score1, score2;
	 logic one_win, two_win, win;
	 logic is_end;
	 
	 hit_calculator hitman( .x1, .x2,
									.punch1, .punch2, .kick1, .kick2,
									.hit1, .hit2);
								
	 keycode_reader keycodes(.keycode,
									 .a_on, .d_on, .g_on, .h_on,
									 .l_on, .r_on, .one_on, .two_on,
									 .enter_on);
									 
	 logic complete;
	 score_counter(.Clk, .inscore1(score1), .inscore2(score2), .Reset(Reset_h),
						.hit1, .hit2, .enter(enter_on),
						.outscore1(score1), .outscore2(score2), .complete
						);
						
	 HexDriver hex_inst_0(score1, HEX0);
	 HexDriver hex_inst_1(score2, HEX1);
						

    
endmodule