module ALU
(
	input [15:0] in_0,
	input [15:0] in_1,
	input ALUop, 
	
	output logic [15:0] result,
	output logic N,
	output logic Z
);

assign result = (ALUop) ? (in_0 - in_1) : (in_0 + in_1);
assign N = result[15];
assign Z = (result == 16'd0);

endmodule