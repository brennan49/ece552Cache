module MEM_WB_Reg(clk, rst_n, dataMem, outVal,  
		EX_MEM_Rd, memToReg, regWrite, hlt,
		dataMemOut, outValOut, EX_MEM_RdOut, memToRegOut, regWriteOut, hltOut);

	input clk,rst_n;
	input memToReg, regWrite, hlt;
	input [15:0] dataMem, outVal;
	input [3:0] EX_MEM_Rd;

//inB is the B input to ALU outVal is the output value chosen from the from the mux after the ALU.
	output reg [15:0] dataMemOut, outValOut; 
	output reg [3:0] EX_MEM_RdOut;
	output reg memToRegOut, regWriteOut, hltOut;

	always @ (posedge clk, negedge rst_n) begin
		if(!rst_n) begin
			dataMemOut <= 0;
			outValOut <= 0;
			EX_MEM_RdOut <= 0;
			memToRegOut <= 0;
			regWriteOut <= 0;
			hltOut <= 0;
		end
		else begin
			dataMemOut <= dataMem;
			outValOut <= outVal;
			EX_MEM_RdOut <= EX_MEM_Rd;
			memToRegOut <= memToReg;
			regWriteOut <= regWrite;
			hltOut <= hlt;
		end
	end
endmodule
