module EX_MEM_Reg(clk, rst_n, CLR, we, readData2, inB, outVal, 
		ID_EX_Rd, memToReg, regWrite, memRead, memWrite, hlt,
		readData2Out, inBOut, outValOut, ID_EX_RdOut, memToRegOut, regWriteOut, memReadOut, memWriteOut, hltOut);

	input clk, CLR, we, rst_n;
	input memToReg, regWrite, memRead, memWrite, hlt;
	input [15:0] readData2, inB, outVal;
	input [3:0] ID_EX_Rd;

//inB is the B input to ALU outVal is the output value chosen from the from the mux after the ALU.
	output reg [15:0] readData2Out, inBOut, outValOut; 
	output reg [3:0] ID_EX_RdOut;
	output reg memToRegOut, regWriteOut, memReadOut, memWriteOut, hltOut;

	always @ (posedge clk, negedge rst_n) begin
		if(!rst_n) begin
			readData2Out <= 0;
			inBOut = 0;
			outValOut = 0;
			ID_EX_RdOut <= 0;
			memToRegOut <= 0;
			regWriteOut <= 0;
			memReadOut <= 0;
			memWriteOut <= 0;
			hltOut <= 0;
		end
		else if(CLR) begin
			readData2Out <= 0;
			inBOut <= 0;
			outValOut <= 0;
			ID_EX_RdOut <= 0;
			memToRegOut <= 0;
			regWriteOut <= 0;
			memReadOut <= 0;
			memWriteOut <= 0;
			hltOut <= 0;
		end
		else if (we) begin
			readData2Out <= readData2;
			inBOut <= inB;
			outValOut <= outVal;
			ID_EX_RdOut <= ID_EX_Rd;
			memToRegOut <= memToReg;
			regWriteOut <= regWrite;
			memReadOut <= memRead;
			memWriteOut <= memWrite;
			hltOut <= hlt;
		end
		else begin
			readData2Out <= readData2Out;
			inBOut <= inBOut;
			outValOut <= outValOut;
			ID_EX_RdOut <= ID_EX_RdOut;
			memToRegOut <= memToReg;
			regWriteOut <= regWrite;
			memReadOut <= memReadOut;
			memWriteOut <= memWriteOut;
			hltOut <= hltOut;
		end
	end
endmodule
