/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module  title_text
(
		input [54239:0] read_address,
		input Clk,

		output logic data_Out
);

// mem has width of 3 bits and a total of 400 addresses
logic [3:0] mem [0:54239];

initial
begin
	 $readmemh("sprite_bytes/title.txt", mem);
end

//always_comb
//begin
//	data_Out = mem[read_address];
//end
always_ff @ (posedge Clk) begin
	data_Out<= mem[read_address];
end

endmodule
