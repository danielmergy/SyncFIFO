`timescale 1ns / 10 ps
module SyncFIFO_tb ();

// Burst = 20 of 8 bits 
// Clk_wr =  100 Mhz  -> Tw = 10 ns
// Clk_rd =   80 Mhz   -> Tr  = 12.5 ns

// TwrireBurst = N * Tw =  200
// TreadInBurst  = 200 / Tr = 16
// Depth = N - 16 = 4

 parameter CLK_RD = 10 ;
 parameter Clk_WR = 16 ;

 logic [7:0] din;
 logic [7:0] dout;
 logic wr_en;
 logic rd_en;
 logic clk_rd;
 logic clk_wr;
 logic rst;
 logic full;
 logic empty;

 SyncFIFO #(.N(9), .WIDTH(8)) FIFO_UT (.din(din), .dout(dout), .wr_en(wr_en), . rd_en(1'b1), 
						.clk_rd(clk_rd), .clk_wr(clk_wr), .full(full), .empty(empty), .rst(rst));
						
initial // clk_rd generator
  begin
	clk_rd = 0;
    forever
	#(CLK_RD/2) clk_rd = !clk_rd;
 end			
 
 initial // clk_wr generator
  begin
	clk_wr =0;
    forever
	#(Clk_WR/2) clk_wr = !clk_wr;
 end			

 initial	//  stimulus reset
  begin
	rst =1;
	#10ps
    rst = 0;
	#10ps
	rst = 1;
  end 
 
 initial	// Test stimulus 
  begin
	#4;
	wr_en = 1;
	for (int i=0 ; i<10 ; i=i+1) // write data	
		begin
		din = i;
		# Clk_WR;
		end
	end 

 endmodule						


