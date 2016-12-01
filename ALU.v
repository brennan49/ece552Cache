module ALU(a, b, out, ALUControl, zFlag, nFlag, vFlag);

	input [15:0]a,b;
	input [3:0]ALUControl;

	output reg [15:0]out;
	output zFlag, nFlag, vFlag;

	wire [15:0] out_as, out_shift; 
	wire [1:0] shift_type;
	//wire [15:0] inAfull,inBfull;
	wire addSub;
	wire [7:0] outUp8 , outDwn8;

	assign addSub = (ALUControl[3]) ? 0 : ALUControl[1];

	assign shift_type = (ALUControl[1]) ? ((ALUControl[0]) ? 2'b00 : 2'b10) : 2'b01; 

	satArith_par mainAdder(.a(a), .b(b), .addSub(addSub), .s(out_as), .v(vFlag));
	defparam mainAdder.WIDTH = 16;

	//satArith_par sbAdder1 (.a(inAhalf), .b(inBhalf), .addSub(addSub), .s(out_sb), .v());
	satAdder#(8) 	paddsbUp(.a(a[15:8]) , .b(b[15:8]) , .out(outUp8 ) , .overFlowFlag()),
			paddsbDw(.a(a[7:0]) , .b(b[7:0]) , .out(outDwn8) , .overFlowFlag());
	
	barrelShifter shifter (.a(a), .shVal(b[3:0]), .type(shift_type), .out(out_shift));

	assign nFlag = (~ALUControl[0])&out[15];
	assign zFlag = (~(|out))&(~ALUControl[0]);	

	//assign inAfull = (ALUControl == 4'b1010) ? a : ((ALUControl == 4'b1011) ? 8'h00 : a);
	//assign inBfull = (ALUControl == 4'b1010) ? 8'h00 : ((ALUControl == 4'b1011) ? b : b);

	//assign inAhalf = (ALUControl == 4'b1010) ?  8'h00 : a[15:8];
	//assign inBhalf = (ALUControl == 4'b1010) ?  b[7:0] : b[15:8];

always@(*) begin
	case(ALUControl)
		4'b0000:           out = out_as;            	//16-bit addition
		4'b0001:           out = {outUp8 , outDwn8};  //16-bit PADDSB
		4'b0010:           out = out_as;                //16-bit subtraction
		4'b0011:           out = ~(a&b);                //16-bit NAND
		4'b0100:           out = a^b;                	//16-bit XOR
		4'b0101:           out = out_shift; 		//16-bit SLL
		4'b0110:           out = out_shift;             //16-bit SRL
		4'b0111:           out = out_shift;             //16-bit SRA
		4'b1000:	   out = out_as;		//16-bit LW
		4'b1001:	   out = out_as;		//16-bit SW
		4'b1010:	   out = {b[7:0], a[7:0]};	//16-bit LHB
		4'b1011:	   out = {{8{b[7]}}, b[7:0]};	//16-bit LLB
		default:	   out = out_as;		//not sure what to make the default case
	endcase
end

endmodule
