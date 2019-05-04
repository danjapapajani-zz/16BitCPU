module RF
(
	input [2:0] reg_num,
	input rd_wr,     // 0 -> read 1->write
	input [15:0] d_in,
	output logic [15:0] d_out
);

logic  [15:0] R0, R1, R2, R3, R4, R5, R6, R7;


always_comb begin
	if (!rd_wr) begin  
		case (reg_num)
			3'b000:		d_out = R0;
			3'b001:		d_out = R1;
			3'b010:		d_out = R2;
			3'b011:		d_out = R3;
			3'b100:		d_out = R4;
			3'b101:		d_out = R5;
			3'b110:		d_out = R6;
			3'b111:		d_out = R7;
		endcase
	end
	else begin			  
		case (reg_num)
			3'b000:		R0 = d_in;
			3'b001:		R1 = d_in;
			3'b010:		R2 = d_in;
			3'b011:		R3 = d_in;
			3'b100:		R4 = d_in;
			3'b101:		R5 = d_in;
			3'b110:		R6 = d_in;
			3'b111:		R7 = d_in;
		endcase
	end
end

endmodule
			