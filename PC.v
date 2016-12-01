module PC(clk, rst_n, we, hlt, branch, call, ret, IF_ID_PCInc, IF_ID_Inst, readData1, currPC, PCIncOut);

	input clk, rst_n, we, hlt, branch, call, ret;
	input [15:0] IF_ID_PCInc, IF_ID_Inst, readData1;
	output reg [15:0] currPC;
	output [15:0] PCIncOut;

	wire branchPC, callPC, nextPC;
	assign PCIncOut = currPC + 1;

	always @ (posedge clk, negedge rst_n) begin
		if(!rst_n)
			currPC <= 0;
		else if(!we || hlt)
			currPC <= currPC;
		else if (branch)
			currPC <= (IF_ID_PCInc + {{7{IF_ID_Inst[8]}}, IF_ID_Inst[8:0]});
		else if (call) 
			currPC <= ({{4{IF_ID_Inst[11]}}, IF_ID_Inst[11:0]} + IF_ID_PCInc);
		else if (ret)
			currPC <= readData1;
		else
			currPC <= PCIncOut;
	end  
endmodule
