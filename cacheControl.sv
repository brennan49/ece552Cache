module cacheControl(clk, rst_n, rdy, we, re, Ihit, Dhit, Ddirty, Irdy, Drdy);
input clk, rst_n; 
input we, re, rdy; // read and write enable
input Ihit, Dhit; //specify if hit/miss in instruction and data cache respectively 
output reg Ddirty; //only write to data cache so only need a dirty signal from data cache
output reg Irdy, Drdy; //I cach and D cache ready signal.

reg [2:0] RWCounter;
wire countDone;
reg readAndWrite;

typedef enum reg [3:0] {IDLE, WRITE, READ, WRITEBACK, READ_MISS, READ_DATA, WRITE_MISS} state_t;
state_t state, nxt_state;

always_ff @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		state <= IDLE;
	else
		state <= nxt_state;
end

always_ff @(posedge clk, negedge rst_n) begin
	if((state == WRITE_MISS) || (state == READ_MISS) || (state == WRITEBACK)) begin
		RWCounter <= RWCounter - 1;
	end
	else begin
		RWCounter <= 5;
	end
end

assign countDone = (RWCounter == 0) ? 1 : 0;

always_comb begin
	Irdy = 0;
	Drdy = 0;
	Ddirty = 0;
	nxt_state = IDLE;
	case(state)
		IDLE: begin
			if(re || (re && we))
				nxt_state = READ;
			else
				nxt_state = WRITE;
		end
		WRITE: begin
			if(Dhit) begin
				Drdy = 1;
				Ddirty = 1;
				nxt_state = IDLE;
			end
			else
				nxt_state = WRITE_MISS;
		end
		WRITE_MISS: begin
			if(countDone) begin
				Ddirty = 1;
				Drdy = 1; 
				nxt_state = IDLE;
			end
			else
				nxt_state = WRITE_MISS;
		end
		/*WRITE_DATA: begin  //don't think WRITE_DATA is necessary
			Ddirty = 1;
			Drdy = 1;
			nxt_state = IDLE;
		end*/
		READ: begin
			if(Dhit) begin
				Drdy = 1;
				nxt_state = IDLE;
			end
			else if (Ihit) begin
				Irdy = 1;
				nxt_state = IDLE;
			end
			else if (!Dhit && Ddirty) 
				nxt_state = WRITEBACK;
			else 
				nxt_state = READ_MISS;
		end
		WRITEBACK: begin
			if(countDone)
				nxt_state = READ_MISS;
			else 
				nxt_state = WRITEBACK;
		end
		READ_MISS: begin
			if(countDone)
				nxt_state = READ_DATA;
			else 
				nxt_state = READ_MISS;
		end
		READ_DATA: begin
			
		end
	endcase
end

endmodule
