module cpu_tb();
	wire clk, rst_n;
	wire hlt;
	wire [15:0] pc;

	clockGenerator genClock(.clk(clk), .reset_n(rst_n));
	cpu theCpu(.clk(clk), .rst_n(rst_n), .hlt(hlt), .PC(pc));
	
	always @(*) begin
		if(hlt) begin //create a small delay so that there is enough time for the cpu to dump the register file contents.
			$stop;
		end
	end

endmodule
