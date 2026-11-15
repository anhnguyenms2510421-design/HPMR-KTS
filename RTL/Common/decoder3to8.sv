module decoder3to8 (
	input logic			EN,
	input logic [2:0] 	din,
	output logic [7:0]	dout
);

	assign dout = EN ? (8'b00000001 << din) : 8'b00000000;

endmodule
