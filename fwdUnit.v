module fwdUnit(rs, rt, EX_MEM_Rd, MEM_WB_Rd, EX_MEM_RegWrite, MEM_WB_RegWrite, opCode, fwdA, fwdB);
	input [3:0] rs, rt, EX_MEM_Rd, MEM_WB_Rd;
	input [3:0] opCode; //opcode from the ID/EX register
	input EX_MEM_RegWrite, MEM_WB_RegWrite;

	output reg[1:0] fwdA, fwdB;

always @(*) begin
	//Execution hazard formula
	fwdA = 0;
	fwdB = 0;
	if(EX_MEM_RegWrite && (EX_MEM_Rd != 0)) begin
		if(EX_MEM_Rd == rs) begin
			fwdA = 1; 
		end
		if(EX_MEM_Rd == rt) begin
			fwdB = 1; 
		end
	end

	//Memory Hazard formula
	if(MEM_WB_RegWrite && (MEM_WB_Rd != 0)) begin
		//if(!((EX_MEM_RegWrite && (EX_MEM_Rd != 0)) && ((EX_MEM_Rd == rs)||(EX_MEM_Rd == rt)))) begin
			if((MEM_WB_Rd == rs) && (!(EX_MEM_RegWrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == rs)))) begin
				fwdA = 2;
			end
			if((MEM_WB_Rd == rt) && (!(EX_MEM_RegWrite && (EX_MEM_Rd != 0) && (EX_MEM_Rd == rt)))) begin
				fwdB = 2;
			end
		//end
	end
end

endmodule
