module reg_file (
		input logic[15:0] register [7:0],
		input logic Clk,
		input logic[2:0]select,
		
		output logic[15:0] register [7:0]);
		