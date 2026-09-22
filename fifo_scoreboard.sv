
class fifo_scoreboard extends uvm_scoreboard;

`uvm_component_utils(fifo_scoreboard)

uvm_analysis_imp #(fifo_seq_item, fifo_scoreboard) analysis_export;

	bit[7:0] reference_fifo[$];

	int pass_count;
	int fail_count;

function new(string name = "fifo_scoreboard", uvm_component parent = null);
	super.new(name, parent);
	analysis_export = new("analysis_export", this);
endfunction

function void write(fifo_seq_item seq);
	bit[7:0] expected_data;
	
	//Write
	if(seq.wr_en && !seq.full) begin
	    reference_fifo.push_back(seq.din);
	    `uvm_info("SCOREBAORD", $sformatf("WRITE accepted: DATA = %0h", 
					       seq.din), UVM_MEDIUM)
	end

	//Read
	if(seq.rd_en && !seq.empty) begin
	    if(reference_fifo.size()==0) begin
		`uvm_error("SCOREBOARD", "Reference FIFO is empty during valid READ")
	    end
	    else begin	
		expected_data = reference_fifo.pop_front();
		if(seq.dout === expected_data)begin
		    pass_count++;
		    `uvm_info("SCOREBOARD", $sformatf("READ PASS: Expected = %0h, Actual = %0h",
						   	expected_data, seq.dout), UVM_MEDIUM)
		end
		else begin	
	    	    fail_count++;
		    `uvm_error("SCOREBOARD", $sformatf("READ FAIL: Expected = %0h, Actual = %0h",
							expected_data, seq.dout))
		end
	    end
	end

	

endfunction

function void report_phase(uvm_phase phase);
	`uvm_info("SCOREBOARD", $sformatf("PASS = %0d, FAIL = %0d, Remaining FIFO = %0d", pass_count, fail_count, 
					   reference_fifo.size()), UVM_NONE)
endfunction
endclass