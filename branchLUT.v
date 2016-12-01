module branchLUT(condition, branchCntl, nFlag, vFlag, zFlag, branch);

	input [2:0] condition;
	input branchCntl, nFlag, vFlag, zFlag;
	output reg branch;

	always @ (*) begin
		branch = 0;
		if(branchCntl) begin
			casex(    {nFlag, zFlag, vFlag , condition}) // rows of table 1
				{3'bx0x, 3'b000}, 			//Not Equal (Z = 0) 
				{3'bx1x, 3'b001}, 			//Equal (Z = 1) 
				{3'b00x, 3'b010}, 			//Greater Than (Z = N = 0) 
				{3'b1xx, 3'b011}, 			//Less Than (N = 1)  
				{3'bx1x, 3'b100},{3'b00x, 3'b100},	//Greater Than or Equal (Z = 1 or Z = N = 0) 
				{3'b1xx, 3'b101},{3'bx1x, 3'b101},	//Less Than or Equal ( N = 1 or Z = 1) 
				{3'bxx1, 3'b110}, 			//Overflow (V = 1) 
				{3'bxxx, 3'b111}: 			//Unconditional 
				 branch = 1;
			endcase
		end
	end
endmodule

