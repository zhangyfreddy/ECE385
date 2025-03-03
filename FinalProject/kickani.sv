module kick_ani(
		input logic Clk,
		input logic Reset,
		input logic keypress,
		output logic [1:0] ani
		);
	enum logic[3:0] {
		Start, transition, kick, done
	} curr_state, next_state;
	
	logic [7:0] counter;
	logic next;
	
	always_ff @ (posedge Clk)
	begin
		if(Reset)
		begin
			curr_state = Start;
			counter = 0;
		end
		else
		begin
			curr_state = next_state;
			if(curr_state == Start)
				counter = 0;
			else if(counter == 150)
				counter = 0;
			else
				counter <= counter + 1;
		end
	end
	
	always_comb
	begin
		next_state = curr_state;
		unique case (curr_state)
			Start:
			begin
				ani = 0;
				if(keypress)
				begin
					next_state = transition;
				end
				else
				begin
					next_state = Start;
				end
			end
			
			transition:
			begin
				ani = 1;
				if(counter == 50)
				begin
					next_state = kick;
				end
				else
				begin
					next_state = transition;
				end
			end
			
			kick:
			begin
				ani = 2;
				if(counter == 100)
				begin
					next_state = done;
				end
				else
				begin
					next_state = kick;
				end
			end
			
			done:
			begin
				ani = 1;
				if(counter == 150)
				begin
					next_state = Start;
				end
				else
				begin
					next_state = done;
				end
			end
		endcase
		
	end
endmodule