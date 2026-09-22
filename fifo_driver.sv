
class fifo_driver extends uvm_driver #(fifo_seq_item);

`uvm_component_utils(fifo_driver)

virtual fifo_if vif;

function new (string name = "fifo_driver",
	      uvm_component parent = null);
	super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(virtual fifo_if)::get(
		this, "", "vif", vif))begin
	`uvm_fatal("DRIVER", "Virtual Interface not found")
	end
endfunction	

task run_phase(uvm_phase phase);
	fifo_seq_item seq;
	
	forever begin
	    seq_item_port.get_next_item(seq);
	    @(posedge vif.clk);
	    vif.wr_en <= seq.wr_en;
	    vif.rd_en <= seq.rd_en;
	    vif.din <= seq.din;
	    seq_item_port.item_done();
	end
endtask
endclass
