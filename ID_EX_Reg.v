module ID_EX_Reg(clk, rst_n, PCInc, inst, CLR, we, readData2, preA, inB_offset, 
		ID_Rs, ID_Rt, ID_Rd, zUpdate, vUpdate, nUpdate,
		memToReg, regWrite, memRead, memWrite, ret, branchCntl, call, hlt, ALUSrc, 
		InstOut, PCIncOut, ID_RsOut, ID_RtOut, ID_RdOut, readData2Out, preAOut, inB_offsetOut, memToRegOut, zOut, vOut, nOut,
		regWriteOut, memReadOut, memWriteOut, retOut, branchCntlOut, callOut, hltOut, ALUSrcOut);

	input clk, CLR, we, rst_n, zUpdate, vUpdate, nUpdate;
	input memToReg, regWrite, memRead, memWrite, ret, branchCntl, call, hlt, ALUSrc;
	input [15:0]PCInc, inst, readData2, preA, inB_offset;
	input [3:0] ID_Rs, ID_Rt, ID_Rd;
	//TO DO: FIGURE OUT ALL OF THE CONTROL SIGNALS NECESSARY AND MAKE AS INPUTS

	output reg [15:0] PCIncOut, InstOut, readData2Out, preAOut, inB_offsetOut;
	output reg [3:0] ID_RsOut, ID_RtOut, ID_RdOut;
	output reg memToRegOut, regWriteOut, memReadOut, memWriteOut, retOut, branchCntlOut, callOut, hltOut, zOut, vOut, nOut, ALUSrcOut;

	always @ (posedge clk, negedge rst_n) begin
		if(!rst_n) begin
			PCIncOut <= 0;
			InstOut <= 0;
			readData2Out <= 0;
			preAOut <= 0;
			inB_offsetOut <= 0;
			ID_RsOut <= 0;
			ID_RtOut <= 0;
			ID_RdOut <= 0;
			memToRegOut <= 0;
			regWriteOut <= 0;
			memReadOut <= 0;
			memWriteOut <= 0;
			retOut <= 0;
			branchCntlOut <= 0;
			callOut <= 0;
			hltOut <= 0;
			zOut <= 0;
			vOut <= 0;
			nOut <= 0;
			ALUSrcOut <= 0;
		end
		else if(CLR) begin
			PCIncOut <= 0;
			InstOut <= 0;
			readData2Out <= 0;
			preAOut <= 0;
			inB_offsetOut <= 0;
			ID_RsOut <= 0;
			ID_RtOut <= 0;
			ID_RdOut <= 0;
			memToRegOut <= 0;
			regWriteOut <= 0;
			memReadOut <= 0;
			memWriteOut <= 0;
			retOut <= 0;
			branchCntlOut <= 0;
			callOut <= 0;
			hltOut <= 0;
			zOut <= 0;
			vOut <= 0;
			nOut <= 0;
			ALUSrcOut <= 0;
		end
		else if (we) begin
			PCIncOut <= PCInc;
			InstOut <= inst;
			readData2Out <= readData2;
			preAOut <= preA;
			inB_offsetOut <= inB_offset;
			ID_RsOut <= ID_Rs;
			ID_RtOut <= ID_Rt;
			ID_RdOut <= ID_Rd;
			memToRegOut <= memToReg;
			regWriteOut <= regWrite;
			memReadOut <= memRead;
			memWriteOut <= memWrite;
			retOut <= ret;
			branchCntlOut <= branchCntl;
			callOut <= call;
			hltOut <= hlt;
			zOut <= zUpdate;
			vOut <= vUpdate;
			nOut <= nUpdate;
			ALUSrcOut <= ALUSrc;
		end
		else begin
			PCIncOut <= PCIncOut;
			InstOut <= InstOut;
			readData2Out <= readData2Out;
			preAOut <= preAOut;
			inB_offsetOut <= inB_offsetOut;
			ID_RsOut <= ID_RsOut;
			ID_RtOut <= ID_RtOut;
			ID_RdOut <= ID_RdOut;
			memToRegOut <= memToRegOut;
			regWriteOut <= regWriteOut;
			memReadOut <= memReadOut;
			memWriteOut <= memWriteOut;
			retOut <= retOut;
			branchCntlOut <= branchCntlOut;
			callOut <= callOut;
			hltOut <= hltOut;
			zOut <= zOut;
			vOut <= vOut;
			nOut <= nOut;
			ALUSrcOut <= ALUSrcOut;
		end
	end
endmodule
