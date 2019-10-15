
// Binding SystemVerilog to VHDL Components Using Questa 
// https://www.mentor.com/products/fv/resources/overview/binding-systemverilog-to-vhdl-components-using-questa-f43cc1c4-6607-44e3-8dc0-515bf2c08abc
module hermes_prop (clock, reset, 
	clock_rx, rx, credit_o, data_in,
	clock_tx, tx, credit_i, data_out,
	S_EA, N_EA, E_EA, W_EA, L_EA );

input logic clock, reset; 
input logic [4:0] clock_rx, rx, credit_o;
input  [15:0] data_in[4:0];

input logic [4:0] clock_tx, tx, credit_i;
input logic [15:0] data_out[4:0];                                   // internal signal - state in int
input [2:0] S_EA,N_EA, E_EA, W_EA, L_EA; 


localparam EAST  = 0;
localparam WEST  = 1;
localparam NORTH = 2;
localparam SOUTH = 3;
localparam LOCAL = 4;


//localparam MAX_CREDIT     = 5'b11111;

//typedef enum {action, soma, Sb, Sa, Sg, nulo, devol} state_type; 

typedef enum {S_INIT, S_HEADER, S_SENDHEADER, S_PAYLOAD, S_END} fifo_fsm_type;

fifo_fsm_type S_fifo_fsm, N_fifo_fsm, E_fifo_fsm, W_fifo_fsm, L_fifo_fsm;

assign S_fifo_fsm = fifo_fsm_type'(S_EA); // converts int to enun
assign N_fifo_fsm = fifo_fsm_type'(N_EA); // converts int to enun
assign E_fifo_fsm = fifo_fsm_type'(E_EA); // converts int to enun
assign W_fifo_fsm = fifo_fsm_type'(W_EA); // converts int to enun
assign L_fifo_fsm = fifo_fsm_type'(L_EA); // converts int to enun

//state_type state;

//assign state = state_type'(state_int); // converts int to enun

// Properties for this module
default clocking @(posedge clock); endclocking
default disable iff reset;

//********************
// ASSUMPTIONS
//********************
// assumption: if the device is busy, there can be no input
//assume_busy: assume  property (busy |-> m100==0 && dev==0 && R_green==0 && R_atum ==0 &&  R_bacon == 0);

// it cannot deliver multiple sanduiches simultaneouslly. example of immediate assertion
//assume_mult_sand: assume property ($onehot0({green, atum, bacon}));

// only local port (4) can send data
//assume_single_rx_port0: assume property (rx[0] == 0 );
//assume_single_rx_port1: assume property (rx[1] == 0 );
//assume_single_rx_port2: assume property (rx[2] == 0 );
//assume_single_rx_port3: assume property (rx == 5'b10000 );


//assume_single_data_port: assume property (data_in[0] == 0 and data_in[1] == 0  and data_in[2] == 0  and data_in[3] == 0 );
// all output ports can receive data
assume_credit_i: assume property (credit_i == 5'b11111);
// credit - the port cannot send data if there is no credit
//assume_credit_o0: assume property (credit_o[0] == rx[0]);
/*
assume_credit_o0: assume property (credit_o[0] == 0 and rx[0]== 0);
assume_credit_o1: assume property (credit_o[1] == 0 and rx[1]== 0);
assume_credit_o2: assume property (credit_o[2] == 0 and rx[2]== 0);
assume_credit_o3: assume property (credit_o[3] == 0 and rx[3]== 0);
assume_credit_o4: assume property (credit_o[4] == 0 and rx[4]== 0);
*/

/*
sequence seq_rx_cred;
	rx[WEST]throughout credit_o[WEST] [->1]; 
endsequence

sequence seq_data_cred;
	$stable(data_in[WEST]) throughout credit_o[WEST] [->1]; 
endsequence


property credit_prop;
	//logic [15:0] d;
	//(rx[WEST], d =  data_in[WEST]) |-> credit_o[WEST] or ((rx[WEST] and d == data_in[WEST]) throughout credit_o[WEST]); 
	//($fell(credit_o[WEST]) and rx[WEST], d =  data_in[WEST]) 
	$fell(credit_o[WEST]) and rx[WEST] 
	|-> 
	//((rx[WEST] and d == data_in[WEST]) throughout credit_o[WEST][->1]) 
	seq_rx_cred intersect seq_data_cred;
	//##1 rx[WEST] and credit_o[WEST] and d == data_in[WEST]; 
	//##1 rx[WEST] and credit_o[WEST] ; 
endproperty
*/
//assume_credit_o4: assume property (
//	credit_prop
//	);

/*
// check all states can be reached
genvar i;

generate for (i=0; i<=4; i++) begin :g1
    assume_stable_datain: assume property (
	credit_o[i] == 0 |-> $stable(data_in[i])
	);
    assume_rx: assume property (
	credit_o[i] == 0 |-> rx[i]
	);
end
endgenerate
*/

assume_credit_o0: assume property (rx[EAST] == 0 );
assume_credit_o1: assume property (rx[WEST] == 0 );
assume_credit_o2: assume property (rx[NORTH] == 0 );
assume_credit_o3: assume property (rx[SOUTH] == 0 );
//assume_credit_o4: assume property (rx[LOCAL] == 0 );




//assume_credit_o4: assume property (
//	credit_o[WEST] == 0 |-> $stable(data_in[WEST])
//	);

/*
cover_prot: cover property (
	##0 credit_o[LOCAL] [->1]
	##1 rx[LOCAL] && data_in[LOCAL] == 16'h0012 ##0 credit_o[LOCAL] [->1] // header
	##1 rx[LOCAL] && data_in[LOCAL] == 16'h0001 ##0 credit_o[LOCAL] [->1] // size
	##1 rx[LOCAL] && data_in[LOCAL] == 16'h0002  // data

);

assert_prot: assert property (
	W_fifo_fsm == S_INIT and E_fifo_fsm == S_INIT and N_fifo_fsm == S_INIT and S_fifo_fsm == S_INIT and L_fifo_fsm == S_INIT 
	##1 rx[LOCAL] && data_in[LOCAL] == 16'h0012 ##0 credit_o[LOCAL] [->1] // header
	##1 rx[LOCAL] && data_in[LOCAL] == 16'h0001 ##0 credit_o[LOCAL] [->1] // size
	##1 rx[LOCAL] && data_in[LOCAL] == 16'h0002  // data
	|=> ## 6  // arbitration time
	tx[NORTH] && data_in[NORTH] == 16'h0012 // header
	##1 tx[NORTH] && data_in[NORTH] == 16'h0001 // size
	##1 tx[NORTH] && data_in[NORTH] == 16'h0002 // data
	);
*/

//cover_rx: assume property (rx[4] == 1);
/*
cover_din0: assume property (data_in[0][15:8] == 0);
cover_din1: assume property (data_in[1][15:8] == 0);
cover_din2: assume property (data_in[2][15:8] == 0);
cover_din3: assume property (data_in[3][15:8] == 0);
cover_din4: assume property (data_in[4][15:8] == 0);
*/

cover_tx: cover property (tx!=0);
cover_tx0: cover property (tx[0]==1);
cover_tx1: cover property (tx[1]==1);
cover_tx2: cover property (tx[2]==1);
cover_tx3: cover property (tx[3]==1);
cover_tx4: cover property (tx[4]==1);
cover_rx4: cover property ((rx[LOCAL] &&  credit_o[LOCAL])[=2]);


//assert_S_END: cover property (S_EA != S_INIT);


cover_single_output_port: cover property (!$onehot0(tx));
cover_single_output_port2: cover property (tx[0]+tx[1]+tx[2]+tx[3]+tx[4] > 1);
assert_single_output_port: assert property ($onehot0(tx));

/*
assert_S_2_single_output_port: assert property (S_EA == S_END |-> $onehot(tx));
assert_N_2_single_output_port: assert property (N_EA == S_END |-> $onehot(tx));
assert_E_2_single_output_port: assert property (E_EA == S_END |-> $onehot(tx));
assert_W_2_single_output_port: assert property (W_EA == S_END |-> $onehot(tx));
assert_L_2_single_output_port: assert property (L_EA == S_END |-> $onehot(tx));
*/

//********************
// FSM COVER
//********************
// check all states can be reached
/*
genvar i;

generate for (i=action; i<=devol; i++) begin :g1
    cover_state:  cover property (state == i);
end
endgenerate
*/
//********************
// OTHER COVERs
//********************
/*
generate for (i=-0; i<=MAX_CREDIT; i++) begin :g2
    cover_grana:  cover property (grana == i);
end
endgenerate

// deliver sanduiche with max credit
cover_max_green1:  cover property (grana == MAX_CREDIT && R_green & !m100 ##1 green && !d100);
cover_max_green2:  cover property (grana == MAX_CREDIT && R_green & m100 ##1 green && d100); -- un
*/

endmodule // hermes_prop



