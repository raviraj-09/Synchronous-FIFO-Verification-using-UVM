
class fifo_sequence extends uvm_sequence #(fifo_seq_item);

`uvm_object_utils(fifo_sequence)

function new(string name = "fifo_sequence");
	super.new(name);
endfunction

virtual task body();

	fifo_seq_item seq;
	// Generating 100 random transaction
	repeat(100) begin
	    seq = fifo_seq_item :: type_id :: create("seq");
	    start_item(seq);
	    assert(seq.randomize() with {
		wr_en dist{
		    1 := 60,
		    0 := 40 };
		rd_en dist{
		    1 := 60,
		    0 := 40 };
	    });

	    finish_item(seq);
	end

endtask
endclass

