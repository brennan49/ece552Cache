module ALU_tb();

	reg [15:0]a, b;
	reg [3:0] ALUControl;
	wire [15:0] out;
	wire zFlag,nFlag,vFlag;
	integer i;

	ALU iDUT(.a(a), .b(b), .ALUControl(ALUControl), .out(out), .zFlag(zFlag), .nFlag(nFlag), .vFlag(vFlag));


	initial begin
		a = 1070;
		b = 5024;
		ALUControl = 10;
		#100;
		for (i = 0; i < 12; i = i+1) begin
			a = $random;
			b = $random;
			ALUControl = i;
			#100;
		end
		a = 5;
		b = 2;
		ALUControl = 2;
		#100;
	end
endmodule
