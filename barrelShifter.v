module barrelShifter (input [15:0] a , input [3:0] shVal , input [1:0] type , output [15:0] out);

	// type : 0: right arithmatic, 1: left , 2: right logical 
	integer i=0;

	mux64_6 ins0 (.in0(a) , .in1({ 15'd0, a[0]}) , .in2(a) , .in3(a) ,.s({type,shVal}),.out(out[0]));
	mux64_6 ins1 (	.in0( { { 1{a[15]}},a[15: 1]} ) , .in1( { 14'd0, {a[0],a[1]}} ) , 
			.in2( { { 1{1'b0 }},a[15: 1]} ) , .in3(0) ,
			.s({type,shVal}),.out(out[1]));
	mux64_6 ins2 (	.in0( { { 2{a[15]}},a[15: 2]} ) , .in1( { 13'd0, {a[0],a[1],a[2]} } ) , 
			.in2( { { 2{1'b0 }},a[15: 2]} ) , .in3(0), 
			.s({type,shVal}),.out(out[ 2]));
	mux64_6 ins3 (	.in0( { { 3{a[15]}},a[15: 3]} ) , .in1( { 12'd0, {a[0],a[1],a[2],a[3]}} ) , 
			.in2( { { 3{1'b0 }},a[15: 3]} ) , .in3(0) ,
			.s({type,shVal}),.out(out[ 3]));
	mux64_6 ins4 (	.in0( { { 4{a[15]}},a[15: 4]} ) , .in1( { 11'd0, {a[0],a[1],a[2],a[3],a[4]}} ) ,
			.in2( { { 4{1'b0 }},a[15: 4]} ) , .in3(0) ,
			.s({type,shVal}),.out(out[ 4]));
	mux64_6 ins5 (	.in0( { { 5{a[15]}},a[15: 5]} ) , .in1( { 10'd0, {a[0],a[1],a[2],a[3],a[4],a[5]}} ) ,
			.in2( { { 5{1'b0 }},a[15: 5]} ) , .in3(0) ,
			.s({type,shVal}),.out(out[ 5]));
	mux64_6 ins6 (	.in0( { { 6{a[15]}},a[15: 6]} ) , .in1( {  9'd0, {a[0],a[1],a[2],a[3],a[4],a[5],a[6]}} ) ,
			.in2( { { 6{1'b0 }},a[15: 6]} ) , .in3(0) ,
			.s({type,shVal}),.out(out[ 6]));
	mux64_6 ins7 (	.in0( { { 7{a[15]}},a[15: 7]} ) , .in1( {  8'd0, {a[0],a[1],a[2],a[3],a[4],a[5],a[6],a[7]}} ) ,
			.in2( { { 7{1'b0 }},a[15: 7]} ) , .in3(0) , 
			.s({type,shVal}),.out(out[ 7]));
	mux64_6 ins8 (	.in0( { { 8{a[15]}},a[15: 8]} ) , .in1( {  7'd0, {a[0],a[1],a[2],a[3],a[4],a[5],a[6],a[7],a[8]}} ) ,
			.in2( { { 8{1'b0 }},a[15: 8]} ) , .in3(0) ,
			.s({type,shVal}),.out(out[ 8]));
	mux64_6 ins9 (	.in0( { { 9{a[15]}},a[15: 9]} ) , .in1( {  6'd0, {a[0],a[1],a[2],a[3],a[4],a[5],a[6],a[7],a[8],a[9]}} ) ,
			.in2( { { 9{1'b0 }},a[15: 9]} ) , .in3(0) ,
			.s({type,shVal}),.out(out[ 9]));
	mux64_6 ins10(	.in0( { {10{a[15]}},a[15:10]} ) , .in1( {  5'd0, {a[0],a[1],a[2],a[3],a[4],a[5],a[6],a[7],a[8],a[9],a[10]}} ) , 
			.in2( { {10{1'b0 }},a[15:10]} ) , .in3(0),
			.s({type,shVal}),.out(out[10]));
	mux64_6 ins11(	.in0( { {11{a[15]}},a[15:11]} ) , .in1( {  4'd0, {a[0],a[1],a[2],a[3],a[4],a[5],a[6],a[7],a[8],a[9],a[10],a[11]}} ) , 
			.in2( { {11{1'b0 }},a[15:11]} ) , .in3(0) ,
			.s({type,shVal}),.out(out[11]));
	mux64_6 ins12(	.in0( { {12{a[15]}},a[15:12]} ) , .in1( {  3'd0, {a[0],a[1],a[2],a[3],a[4],a[5],a[6],a[7],a[8],a[9],a[10],a[11],a[12]}} ) , 
			.in2( { {12{1'b0 }},a[15:12]} ) , .in3(0) ,
			.s({type,shVal}),.out(out[12]));
	mux64_6 ins13(	.in0( { {13{a[15]}},a[15:13]} ) , .in1( {  2'd0, {a[0],a[1],a[2],a[3],a[4],a[5],a[6],a[7],a[8],a[9],a[10],a[11],a[12],a[13]}} ) , 
			.in2( { {13{1'b0 }},a[15:13]} ) , .in3(0) ,
			.s({type,shVal}),.out(out[13]));
	mux64_6 ins14(	.in0( { {14{a[15]}},a[15:14]} ) , .in1( {  1'd0, {a[0],a[1],a[2],a[3],a[4],a[5],a[6],a[7],a[8],a[9],a[10],a[11],a[12],a[13],a[14]}} ) , 
			.in2( { {14{1'b0 }},a[15:14]} ) , .in3(0) ,
			.s({type,shVal}),.out(out[14]));
	mux64_6 ins15(	.in0( { {15{a[15]}},a[15:15]} ) , .in1( {a[0],a[1],a[2],a[3],a[4],a[5],a[6],a[7],a[8],a[9],a[10],a[11],a[12],a[13],a[14],a[15]} ) ,
			.in2( { {15{1'b0 }},a[15:15]} ) , .in3(0) ,
			.s({type,shVal}),.out(out[15]));
	

endmodule 
