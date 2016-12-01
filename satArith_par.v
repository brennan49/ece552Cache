module satArith_par #(parameter WIDTH = 8)(input signed [WIDTH-1:0] a,b,input addSub,output reg signed [WIDTH-1:0] s , output v);


	wire [WIDTH-1:0] inS , inb;
	assign inb = (addSub)? -b:b;
	assign inS = a+inb;
	assign v = 	((a[WIDTH-1])&(inb[WIDTH-1])&(~inS[WIDTH-1])) | 
			((~a[WIDTH-1])&(~inb[WIDTH-1])&(inS[WIDTH-1]));

	always@(*) begin
		if(v)
			s = (a[WIDTH-1]) ? -(1<<(WIDTH-1)) : (1<<(WIDTH-1))-1 ;
		else
			s = inS;

	end

endmodule
