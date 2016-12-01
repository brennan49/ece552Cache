module control(inst, rs, rt, rd, Control_Flush, branchCntl, memToReg, memRead, memWrite, ALUSrc, regWrite, call, ret, hlt, zUpdate, nUpdate, vUpdate);

	input [15:0] inst;
	input Control_Flush;
	output reg memToReg, memWrite, ALUSrc, branchCntl, memRead, regWrite, call, ret, hlt,zUpdate, nUpdate, vUpdate;
	output reg [3:0] rd;
	output  [3:0]rs, rt;


	//combinational block setting the control signals to their respective values for each instruction.
	always @ (*) begin
		ALUSrc = 0;
		memToReg = 0;
		regWrite = 1;
		memRead = 0;
		memWrite = 0;
		branchCntl= 0;	
		call = 0;
		ret = 0;
		hlt = 0;
		case (inst[15:12])
			4'b0101: begin
				ALUSrc = 1;
			end
			4'b0110: begin
				ALUSrc = 1;
			end
			4'b0111: begin
				ALUSrc = 1;
			end
			4'b1000: begin
				ALUSrc = 1;
				memRead = 1;
				memToReg = 1;
			end
			4'b1001: begin
				ALUSrc = 1;
				regWrite = 0;
				memWrite = 1;
			end
			4'b1010: begin
				ALUSrc = 1;
			end
			4'b1011: begin
				ALUSrc = 1;
			end
			4'b1100: begin
				regWrite = 0;
				branchCntl= 1;
			end
			4'b1101: begin
				call = 1;
			end
			4'b1110: begin
				regWrite = 0;
				ret = 1;
			end
			4'b1111: begin
				hlt = 1;
			end
			default: begin
				ALUSrc = 0;
				memToReg = 0;
				regWrite = 1;
				memWrite = 0;
				branchCntl= 0;
				call = 0;
				ret = 0;	
				hlt = 0;
			end
		endcase
	end

	//update signals for the flags for the flag register in EX phase
	always @(*) begin
		zUpdate = 1;
		nUpdate = 0;
		vUpdate = 0;
		case(inst[15:12]) 
			0: begin
				nUpdate = 1;
				vUpdate = 1;
			end
			2: begin
				nUpdate = 1;
				vUpdate = 1;
			end
			default: begin
				zUpdate = 1;
				nUpdate = 0;
				vUpdate = 0;
			end				
		endcase
	end

	always@(*) begin
		if(Control_Flush) begin
			ALUSrc = 0;
			memToReg = 0;
			regWrite = 0;
			memRead = 0;
			memWrite = 0;
			branchCntl= 0;	
			call = 0;
			ret = 0;
			hlt = 0;
		end
	end

assign rs = (inst[15:12] == 10) ? inst[11:8]: inst[7:4]; //if instruction is LHB rs = inst[11:8] else rs = inst[7:4]

assign rt = (inst[15:12] == 9 || inst[15:12] == 8) ? inst[11:8]: inst[3:0]; //if instruction is lw or sw, rt = inst[11:8] else it is inst[3:0]

always @(*) begin
		if(call) begin 
			rd = 4'b1111;
		end
		else begin
			rd = inst[11:8];
		end
end
endmodule
