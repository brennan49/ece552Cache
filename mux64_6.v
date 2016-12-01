module mux64_6(input [15:0] in0 , [15:0]in1 , [15:0]in2 , [15:0]in3 , input [5:0] s , output out);

	/*
		MUX ----- MUX 
		MUX --^
		MUX --^ 
		MUX --^
	*/


	wire [3:0] internal;

	mux16_4 ins0( .in(in0) , .s(s[3:0]) , .out(internal[0]) );
	mux16_4 ins1( .in(in1) , .s(s[3:0]) , .out(internal[1]) );
	mux16_4 ins2( .in(in2) , .s(s[3:0]) , .out(internal[2]) );
	mux16_4 ins3( .in(in3) , .s(s[3:0]) , .out(internal[3]) );

	mux16_4 ins4( .in({12'd0,internal}) , .s({2'd0,s[5:4]}) , .out(out) );

endmodule
