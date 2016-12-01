module hzdLUT(cntlHzd, memHzd, branchHzd, CLR, we);
	input cntlHzd, memHzd, branchHzd;
	output reg [2:0] CLR;
	output reg [3:0] we;

	always @(*) begin
		if(memHzd) begin
			CLR = 3'b001;
			we = 4'b 000x;			
		end
		else if (branchHzd) begin
			CLR = 3'b010;
			we = 4'b00x1;
		end
		else if (cntlHzd) begin
			CLR = 3'b100; //clear IF/ID stage
			we = 4'b1x11; //	
		end
		else begin
			CLR = 3'b000;
			we = 4'b1111;	
		end
	end
endmodule
