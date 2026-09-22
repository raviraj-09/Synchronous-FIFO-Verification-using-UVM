
class fifo_test extends uvm_test;
`uvm_component_utils(fifo_test)
fifo_env env;

function new(string name = "fifo_test", uvm_component parent = null);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	env = fifo_env::type_id::create("env", this);
endfunction

task run_phase(uvm_phase phase);
	fifo_sequence seq;
	phase.raise_objection(this);
	seq = fifo_sequence::type_id::create("seq");
	seq.start(env.agent.sequencer);
	#100;
	phase.drop_objection(this);
endtask
endclass