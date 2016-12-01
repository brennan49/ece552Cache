module cpu(clk, rst_n, hlt, PC);

	input clk, rst_n;
	output hlt;
	output [15:0] PC;

	//IF phase variables
	wire [15:0] IF_Inst, currPC, PCInc; //IF phase instruction directly from inst mem.

	//ID Phase variables
	wire [15:0] ID_Inst, ID_PCInc; //16-bit outputs from modules
	
	wire cntlFlush; //1 bit outputs from modules. (NOTE: cntlFlush will flush the control unit on a control hazard
	wire branchTaken; // 1bit output of branch lut to determine if branch is taken or not

	//Control Outputs
	wire branchCntl, memToReg, memWrite, memRead, ALUSrc, regWrite, call, ret, zUpdate, vUpdate, nUpdate, HALT;
	wire [3:0] ID_rs, ID_rt, ID_rd;

	//rf_piplined inputs
	wire [15:0] writeData;

	//rf_pipelined outputs
	wire [15:0] rd2;

	//Hazard detection/LUT outputs
	wire [2:0] CLR;
	wire [3:0] we;

	//ID phase variables
	wire[15:0] preA;
	reg [15:0] preB;//preB is the output of the mux that chooses to use rd2 or the offset as the input for b.
	wire cntlHzd, memHzd, branchHzd;
	
	//EX phase variables
	wire [15:0] EX_Inst, EX_PCInc, EX_rd2, EX_preA, EX_preB, ALUOut, result, EX_writeData;
	reg [15:0] inA, inB;
	wire [3:0] EX_rs, EX_rt, EX_rd;
	wire [1:0] fwdA, fwdB; //2'b01 is an execution hazard, 2'b10 is a memory hazard, 2'b00 is a normal non-hazard 
	wire EX_memToReg, EX_regWrite, EX_memRead, EX_memWrite, EX_ret, EX_branchCntl, EX_call, EX_hlt, EX_zUpdate, EX_vUpdate, EX_nUpdate, EX_ALUSrc;
	
	//EX phase flags
	wire nFlag, vFlag, zFlag, EX_nUpdatedFlag, EX_vUpdatedFlag, EX_zUpdatedFlag;
	
	//MEM PHASE VARIABLES
	wire [15:0] MEM_rd2, MEM_writeData, MEM_result, dataMemOut;
	wire [3:0] MEM_rd;
	wire MEM_memToReg, MEM_regWrite, MEM_memRead, MEM_memWrite, MEM_hlt;

	//WB PHASE VARIABLES
	wire [15:0] WB_dataMem, WB_result;
	wire [3:0] WB_rd;
	wire WB_memToReg, WB_regWrite, WB_hlt;

	///////////////////////////
	//mem_hierarchy Variables//
	///////////////////////////
	//wire clock = 
	wire instStall, dataStall;

	//////////////////////
	//IF PHASE	    //
	//////////////////////
	PC thePC(.clk(clk), .rst_n(rst_n), .we(we[3] & (~dataStall & ~instStall)), .hlt(HALT), .branch(branchTaken), .call(call), .ret(ret), .IF_ID_PCInc(ID_PCInc), .IF_ID_Inst(ID_Inst), .readData1(preA), .currPC(currPC), 
		 .PCIncOut(PCInc));
	assign PC = currPC;

	//IM instructions(.clk(clk), .addr(currPC), .rd_en(1'b1), .instr(IF_Inst));
	//DM DataMemory(.clk(clk), .addr(MEM_result), .re(MEM_memRead), .we(MEM_memWrite),.wrt_data(MEM_writeData), .rd_data(dataMemOut));

	mem_hierarchy cacheMoney (.clk(clk), .rst_n(rst_n), .i_addr(PC), .d_addr(MEM_result), .instr(IF_Inst), .i_rdy(instStall), .d_rdy(dataStall), .re(MEM_memRead), .we(MEM_memWrite), .wrt_data(MEM_writeData), .rd_data(dataMemOut));

	//IF/ID Pipeline Register
	IF_ID_Reg IF_ID_Pipe(.clk(clk), .rst_n(rst_n), .PCInc(PCInc), .Inst(IF_Inst), .CLR(CLR[2]), .we(we[2] & (~dataStall & ~instStall)), .PCIncOut(ID_PCInc), .InstOut(ID_Inst), .Control_Flush(cntlFlush));

	//////////////////////
	//ID PHASE	    //
	////////////////////// 
	control cntl(.inst(ID_Inst), .Control_Flush(cntlFlush), .rs(ID_rs), .rt(ID_rt), .rd(ID_rd), .branchCntl(branchCntl), .memToReg(memToReg),
		     .memWrite(memWrite), .memRead(memRead), .ALUSrc(ALUSrc), .regWrite(regWrite), .call(call), .ret(ret), .hlt(HALT), .zUpdate(zUpdate), .nUpdate(nUpdate), .vUpdate(vUpdate));

	rf regFile(.clk(clk), .p0_addr(ID_rs), .p1_addr(ID_rt), .p0(preA), .p1(rd2), .re0(1'b1), .re1(1'b1), .dst_addr(WB_rd), .dst(writeData), .we(WB_regWrite), .hlt(HALT));

	always @(*) begin
		preB = rd2;
		case (ID_Inst[15:12])
			5: preB = {{12{ID_Inst[3]}}, ID_Inst[3:0]};
			6: preB = {{12{ID_Inst[3]}}, ID_Inst[3:0]};
			7: preB = {{12{ID_Inst[3]}}, ID_Inst[3:0]};
			8: preB = {{12{ID_Inst[3]}}, ID_Inst[3:0]};
			9: preB = {{12{ID_Inst[3]}}, ID_Inst[3:0]};
			10: preB = {{8{ID_Inst[7]}}, ID_Inst[7:0]};
			11: preB = {{8{ID_Inst[7]}}, ID_Inst[7:0]};
			12: preB = {{7{ID_Inst[8]}}, ID_Inst[8:0]};
			13: preB = {{4{ID_Inst[11]}}, ID_Inst[11:0]};
			default: preB = rd2;
		endcase
			
	end

	branchLUT toTakeorNotToTake(.condition(ID_Inst[11:9]), .branchCntl(branchCntl), .nFlag(EX_nUpdatedFlag), .vFlag(EX_vUpdatedFlag), .zFlag(EX_zUpdatedFlag), .branch(branchTaken));

	hzdDetectionUnit HazardsBeHere(.ret(ret), .call(call), .branch(branchTaken), .branchCntl(branchCntl), .hlt(HALT), .memToReg(WB_memToReg), .rs(EX_rs), .rt(EX_rt), .rd(MEM_rd), 
					.cntlHzd(cntlHzd), .memHzd(memHzd), .branchHzd(branchHzd), .EX_zUpdate(EX_zUpdate), .EX_vUpdate(EX_vUpdate), .EX_nUpdate(EX_nUpdate));
	
	hzdLUT chooseYourHazard(.cntlHzd(cntlHzd), .memHzd(memHzd), .branchHzd(branchHzd), .CLR(CLR), .we(we));
	
	//ID/EX pipline Register
	ID_EX_Reg ID_EX_pipe(.clk(clk), .rst_n(rst_n), .PCInc(ID_PCInc), .inst(ID_Inst), .CLR(CLR[1]), .we(we[1] & (~dataStall & ~instStall)), .readData2(rd2), .preA(preA), .inB_offset(preB), 
				.ID_Rs(ID_rs), .ID_Rt(ID_rt), .ID_Rd(ID_rd), .zUpdate(zUpdate), .vUpdate(vUpdate), .nUpdate(nUpdate), .ALUSrc(ALUSrc),
				.memToReg(memToReg), .regWrite(regWrite), .memRead(memRead), .memWrite(memWrite), .ret(ret), .branchCntl(branchCntl), .call(call), .hlt(HALT), 
				.InstOut(EX_Inst), .PCIncOut(EX_PCInc), .ID_RsOut(EX_rs), .ID_RtOut(EX_rt), .ID_RdOut(EX_rd), .readData2Out(EX_rd2), .preAOut(EX_preA), .inB_offsetOut(EX_preB), .memToRegOut(EX_memToReg), 
				.zOut(EX_zUpdate), .vOut(EX_vUpdate), .nOut(EX_nUpdate), .regWriteOut(EX_regWrite), .memReadOut(EX_memRead), .memWriteOut(EX_memWrite), 
				.retOut(EX_ret), .branchCntlOut(EX_branchCntl), .callOut(EX_call), .hltOut(EX_hlt), .ALUSrcOut(EX_ALUSrc));
	//////////////////////
	//EX PHASE          //
	//////////////////////  
	//determine if forwarding and what input A to ALU should be
	always @ (*) begin
		if (fwdA == 1)
			inA = MEM_result;//EX/MEM.Val
		else if (fwdA == 2)
			inA = writeData;//MEM/WB.Val
		else
			inA = EX_preA;
	end

	//determine if forwarding and what input B to ALU should be
	always @ (*) begin
		if (fwdB == 1 && !EX_ALUSrc)
			inB = MEM_result;//EX/MEM.Val
		else if (fwdB == 2 && !EX_ALUSrc)
			inB = writeData;//MEM/WB.Val
		else
			inB = EX_preB;
	end
	
	ALU EX_ALU(.a(inA), .b(inB), .out(ALUOut), .ALUControl(EX_Inst[15:12]), .zFlag(zFlag), .nFlag(nFlag), .vFlag(vFlag));

	flagRegister theFlags(.clk(clk), .rst_n(rst_n), .nFlag(nFlag), .zFlag(zFlag), .vFlag(vFlag), .nEn(EX_nUpdate), .zEn(EX_zUpdate), .vEn(EX_vUpdate), 
				.nFlagOut(EX_nUpdatedFlag), .zFlagOut(EX_zUpdatedFlag), .vFlagOut(EX_vUpdatedFlag));

	

	fwdUnit Forwarding(.rs(EX_rs), .rt(EX_rt), .EX_MEM_Rd(MEM_rd), .MEM_WB_Rd(WB_rd), .EX_MEM_RegWrite(MEM_regWrite), .MEM_WB_RegWrite(WB_regWrite), .opCode(EX_Inst[15:12]),
				.fwdA(fwdA), .fwdB(fwdB));

	assign EX_writeData = ((fwdB == 1)) ? MEM_result : (fwdB == 2) ? writeData : EX_rd2;
	
	assign result = (EX_call) ? EX_PCInc : ALUOut;

	//EX/MEM PIPELINE REGISTER
	EX_MEM_Reg EX_MEM_pipe(.clk(clk), .rst_n(rst_n), .CLR(CLR[0]), .we(we[0] & (~dataStall & ~instStall)), .readData2(EX_rd2), .inB(EX_writeData), .outVal(result), 
		.ID_EX_Rd(EX_rd), .memToReg(EX_memToReg), .regWrite(EX_regWrite), .memRead(EX_memRead), .memWrite(EX_memWrite), .hlt(EX_hlt),
		.readData2Out(MEM_rd2), .inBOut(MEM_writeData), .outValOut(MEM_result), .ID_EX_RdOut(MEM_rd), .memToRegOut(MEM_memToReg), .regWriteOut(MEM_regWrite), 
		.memReadOut(MEM_memRead), .memWriteOut(MEM_memWrite), .hltOut(MEM_hlt));
	
	/////////////////////
	//MEM PHASE        //
	/////////////////////


	//MEM/WB PIPELINE REGISTER
	MEM_WB_Reg MEM_WB_pipe(.clk(clk), .rst_n(rst_n), .dataMem(dataMemOut), .outVal(MEM_result),  
		.EX_MEM_Rd(MEM_rd), .memToReg(MEM_memToReg), .regWrite(MEM_regWrite), .hlt(MEM_hlt), 
		.dataMemOut(WB_dataMem), .outValOut(WB_result), .EX_MEM_RdOut(WB_rd), .memToRegOut(WB_memToReg), .regWriteOut(WB_regWrite), .hltOut(WB_hlt));
	
	assign hlt = WB_hlt;

	assign writeData = (WB_memToReg) ? WB_dataMem : WB_result;


endmodule
