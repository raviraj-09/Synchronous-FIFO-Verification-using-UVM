
`timescale 1ns/1ps

import uvm_pkg::*;

`include "uvm_macros.svh"
`include "interface.sv"
`include "fifo_seq_item.sv"
`include "fifo_sequence.sv"
`include "fifo_sequencer.sv"
`include "fifo_driver.sv"
`include "fifo_monitor.sv"
`include "fifo_agent.sv"
`include "fifo_scoreboard.sv"
`include "fifo_env.sv"
`include "fifo_test.sv"


module tb_top;

logic clk;

//clock
initial begin 
clk = 0;
forever #5 clk = ~clk;
end

//interface
fifo_if vif(clk);

//DUT
sync_fifo #(.DATA_WIDTH(8), .DEPTH(16)) dut(
	.clk(clk), .rst_n(vif.rst_n), .wr_en(vif.wr_en),
	.rd_en(vif.rd_en), .din(vif.din), .dout(vif.dout),
	.full(vif.full), .empty(vif.empty));

//Reset
initial begin
vif.rst_n = 0; 

vif.wr_en = 0;
vif.rd_en = 0;
vif.din = 0;

#20;

vif.rst_n = 1;

end 

initial begin
uvm_config_db #(virtual fifo_if)::set(null,"*","vif",vif);
end

initial begin

//start UVM
run_test("fifo_test");
end



endmodule




