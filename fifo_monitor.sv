
class fifo_monitor extends uvm_monitor;
	
`uvm_component_utils(fifo_monitor)

virtual fifo_if vif;

uvm_analysis_port #(fifo_seq_item) analysis_port;

function new(string name = "fifo_monitor",
	     uvm_component parent = null);
	super.new(name,parent);
	analysis_port = new("analysis_port", this);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(virtual fifo_if)::get(
		this, "", "vif", vif))
	`uvm_fatal("MONITOR", "Virtaul Interface not found.")
endfunction

task run_phase(uvm_phase phase);
	fifo_seq_item seq;
	
	forever begin
	    @(posedge vif.clk);
	    #1;

	    seq = fifo_seq_item::type_id::create("seq",this);
	    seq.wr_en = vif.wr_en;
	    seq.rd_en = vif.rd_en;
	    
    	    seq.din = vif.din;
	    
	    seq.dout = vif.dout;

	    seq.full = vif.full;
	    seq.empty =  vif.empty;

	    analysis_port.write(seq);
	end
endtask
endclass







 
