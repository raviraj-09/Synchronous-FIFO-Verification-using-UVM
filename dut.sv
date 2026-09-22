module sync_fifo #( parameter DATA_WIDTH = 8,
		    parameter DEPTH = 16)(

	input logic clk,
	input logic rst_n,
	input logic wr_en,
	input logic rd_en,
	input logic [DATA_WIDTH - 1:0] din,
	output logic [DATA_WIDTH - 1:0] dout,
	output logic full,
	output logic empty);

localparam PTR_WIDTH = $clog2(DEPTH);
logic [DATA_WIDTH - 1:0] mem [0:DEPTH-1];
logic [PTR_WIDTH - 1:0] wr_ptr;
logic [PTR_WIDTH - 1:0] rd_ptr;
logic [PTR_WIDTH : 0] count;

always_ff @(posedge clk) begin
	if(!rst_n) begin
		wr_ptr <= 0;
		rd_ptr <= 0;
		count <= 0;
		dout <= 0;
	end

	else begin
	// Write logic
	if (wr_en && !full) begin
		mem[wr_ptr] <= din;
		wr_ptr <= wr_ptr + 1'b1;
	end
	// Read Logic
	if(rd_en && !empty) begin
		dout <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1'b1;
	end

	//count
	case ({wr_en && !full, rd_en && !empty})
	   2'b10 : count <= count + 1'b1;
	   2'b01 : count <= count - 1'b1;
	   default: count <= count;
	endcase
	end
end

assign full = (count == DEPTH);
assign empty = (count == 0);
	

endmodule
