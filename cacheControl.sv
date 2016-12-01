module cacheControl(clk, rst_n, rdy, dCache_or_iCache, write_or_read, Ihit, Dhit, Ddirty, dataSetDirty, Irdy, Drdy, currState);
input clk, rst_n; 
input dCache_or_iCache, write_or_read, rdy; // read and write enable
input Ihit, Dhit, Ddirty; //specify if hit/miss in instruction and data cache respectively 
output reg dataSetDirty; //only write to data cache so only need a dirty signal from data cache
output reg Irdy, Drdy; //I cach and D cache ready signal.
output reg [1:0] currState;

typedef enum reg [1:0] {CACHEACCESS, WRITEBACK, READ_MISS, WRITE_MISS} state_t;
state_t state, nxt_state;

always_ff @(posedge clk, negedge rst_n) begin
	if(!rst_n)
		state <= CACHEACCESS;
	else
		state <= nxt_state;
end

always_comb begin
	Irdy = 0;
	Drdy = 0;
	dataSetDirty = 0;
	//nxt_state = CACHEACCESS;
	currState = state;
	case(state)
		CACHEACCESS: begin
			if(dCache_or_iCache) begin
				if(Dhit) begin
					dataSetDirty = 1;
					nxt_state = CACHEACCESS;
				end
				else if (!Dhit && Ddirty)  begin
					nxt_state = WRITEBACK;
					Drdy = 1;
					Irdy = 1;
				end
				else if(write_or_read && !Dhit && !Ddirty) begin
					nxt_state = WRITE_MISS;
					Drdy = 1;
					Irdy = 1;
				end
				else if (!write_or_read && !Dhit && !Ddirty) begin
					nxt_state = READ_MISS;
					Drdy = 1;
					Irdy = 1;
				end
				else
					nxt_state = CACHEACCESS;
			end
			else begin
				if(Ihit) begin
					nxt_state = CACHEACCESS;
				end
				else begin
					nxt_state = READ_MISS;
					Drdy = 1;
					Irdy = 1;
				end
			end
		end
		WRITE_MISS: begin
			Irdy = 1;
			Drdy = 1;
			if(rdy) begin
				dataSetDirty = 1;
				nxt_state = CACHEACCESS;
			end
			else
				nxt_state = WRITE_MISS;
		end
		WRITEBACK: begin
			Drdy = 1;
			Irdy = 1;
			if(rdy) begin	
				if(write_or_read)
					nxt_state = WRITE_MISS;
				else
					nxt_state = READ_MISS;
			end
			else 
				nxt_state = WRITEBACK;
		end
		READ_MISS: begin
			Drdy = 1;
			Irdy = 1;
			if(rdy)	begin
				if(dCache_or_iCache) begin
					dataSetDirty = 1;
					nxt_state = CACHEACCESS;
				end
				else begin
					nxt_state = CACHEACCESS;
				end
			end
			else 
				nxt_state = READ_MISS;
		end
		default: begin
			Drdy = 0;
			Irdy = 0;
			dataSetDirty = 0;
			nxt_state = CACHEACCESS;
			currState = state;
		end
	endcase
end

endmodule
