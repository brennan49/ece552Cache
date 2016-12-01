module flagRegister(clk, rst_n, nFlag, zFlag, vFlag, nEn, zEn, vEn, nFlagOut, zFlagOut, vFlagOut);
	input clk, rst_n, nFlag, zFlag, vFlag, nEn, zEn, vEn;
	output reg nFlagOut, zFlagOut, vFlagOut;

	always@ (posedge clk, negedge rst_n) begin
		if(!rst_n)
			nFlagOut <= 0;
		else if(nEn)
			nFlagOut <= nFlag;
		else
			nFlagOut <= nFlagOut;
	end

	always @ (posedge clk, negedge rst_n) begin
		if(!rst_n)
			zFlagOut <= 0;
		else if(zEn)
			zFlagOut <= zFlag;
		else
			zFlagOut <= zFlagOut;
	end
	
	always @ (posedge clk, negedge rst_n) begin
		if(!rst_n)
			vFlagOut <= 0;
		else if(vEn)
			vFlagOut = vFlag;
		else
			vFlagOut = vFlagOut;
	end
endmodule
