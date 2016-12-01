module IF_ID_Reg(clk, rst_n, PCInc, Inst, CLR, we, PCIncOut, InstOut, Control_Flush);
	input clk, CLR, we, rst_n;
	input [15:0]PCInc, Inst;

	output reg [15:0] PCIncOut, InstOut;
	output reg Control_Flush; //used to flush the control unit when a NOP is called or on reset.

	always @ (posedge clk, negedge rst_n) begin
		if(!rst_n) begin
			PCIncOut <= 0;
			InstOut <= 16'h0000;
			Control_Flush <= 1;
		end
		else if(CLR) begin
			PCIncOut <= PCInc;
			InstOut <= 0;
			Control_Flush <= 1;
		end
		else if (we) begin
			PCIncOut <= PCInc;
			InstOut <= Inst;
			Control_Flush <= 0;
		end
		else begin
			PCIncOut <= PCIncOut;
			InstOut <= InstOut;
			Control_Flush <= 0;
		end
	end
endmodule
