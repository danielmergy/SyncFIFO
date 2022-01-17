module SyncFIFO #(parameter N = 4, parameter M = 2) 
(
input logic [7:0] din,
output logic [7:0] dout,
input logic wr_en,
input logic rd_en,
input logic clk_rd,
input logic clk_wr,
input logic rst,
output logic full,
output logic empty
);
						
logic [7:0] mem [N-1:0];
logic [M-1:0] wr_adr;
logic [M-1:0] rd_adr;


always_ff @(posedge clk_wr or negedge rst)
	if (~rst)
		wr_adr <= {M{1'b0}};
	else if (wr_en & ~full)
				begin
				mem[wr_adr] <= din;	
				if (wr_adr == N)
					wr_adr <= {M{1'b0}};
				else
					wr_adr <= wr_adr + {{(M-1){1'b0}}, 1'b1};
				end
			
always_ff @(posedge clk_rd or negedge rst)
	if (~rst)
		rd_adr <= (N-1);
	else if (rd_en & ~empty)
				if (rd_adr == N)
					rd_adr <= {M{1'b0}};
				else
					rd_adr <= rd_adr + {{(M-1){1'b0}}, 1'b1};
			
assign dout = mem[rd_adr];

assign full = (wr_adr == rd_adr);
assign empty =   (wr_adr + (N-1) ) == rd_adr ;

endmodule

