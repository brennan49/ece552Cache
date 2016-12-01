module mux16_4 (input [15:0] in , input [3:0] s , output out);

	//assign out = in[s];
	
	
	/* 
		MUX----	MUX----	MUX----	MUX ----
		MUX--^	     ^	     ^
		MUX----	MUX--^	     ^
		MUX--^		     ^
		MUX----	MUX----	MUX--^
		MUX--^	     ^
		MUX----	MUX--^
		MUX--^
	*/

	wire internal_0[0:7];
	assign internal_0[0] = (s[0])? in[ 1]:in[ 0];
	assign internal_0[1] = (s[0])? in[ 3]:in[ 2];
	assign internal_0[2] = (s[0])? in[ 5]:in[ 4];
	assign internal_0[3] = (s[0])? in[ 7]:in[ 6];
	assign internal_0[4] = (s[0])? in[ 9]:in[ 8];
	assign internal_0[5] = (s[0])? in[11]:in[10];
	assign internal_0[6] = (s[0])? in[13]:in[12];
	assign internal_0[7] = (s[0])? in[15]:in[14];
	

	wire internal_1[0:3];
	assign internal_1[0] = (s[1]) ? internal_0[1] : internal_0[0];
	assign internal_1[1] = (s[1]) ? internal_0[3] : internal_0[2];
	assign internal_1[2] = (s[1]) ? internal_0[5] : internal_0[4];
	assign internal_1[3] = (s[1]) ? internal_0[7] : internal_0[6]; 
	
	wire internal_2[0:1];
	assign internal_2[0] = (s[2]) ? internal_1[1] : internal_1[0];
	assign internal_2[1] = (s[2]) ? internal_1[3] : internal_1[2];
	

	assign out = (s[3]) ? internal_2[1]:internal_2[0];

endmodule 
