module hzdDetectionUnit(ret, call, branch, branchCntl, hlt, memToReg, rs, rt, rd, cntlHzd, memHzd, branchHzd, EX_zUpdate, EX_vUpdate, EX_nUpdate);
	input ret, call, branch, branchCntl, hlt, memToReg, EX_zUpdate, EX_vUpdate, EX_nUpdate;
	input [3:0] rs, rt, rd;

	output reg cntlHzd, memHzd, branchHzd;

	//memory hazard
	always @(*) begin
		memHzd = 0;
		branchHzd = 0;
		cntlHzd = 0;
		if(rd != 0) begin
			if(memToReg && ((rd == rs) || (rd == rt))) begin
				memHzd = 1;
			end
		end
		//check that any of the flags are being changed, if so then stall for a cycle for flags to update
		if(branchCntl && (EX_zUpdate || EX_vUpdate || EX_nUpdate)) begin
			branchHzd = 1;
		end
		if(branch || ret || call || hlt) begin
			cntlHzd = 1;
		end
	end
endmodule
