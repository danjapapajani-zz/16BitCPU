module control(

	input clk,
	input reset,
	input [4:0] i_instr,
	input i_N,
	input i_Z,


	output logic o_reset,
	output logic o_set_addr,
	output logic o_mem_rd,
	output logic o_mem_wr,
	output logic o_read_data,
	output logic o_inc_PC,
	output logic o_updatePC,
	output logic o_read_IR,
	output logic o_mv_rd,
	output logic o_mv_wr,
	output logic o_readRx_add,
	output logic o_readRy_add,
	output logic o_add_add,
	output logic o_writeRx_add,
	output logic o_ld_rd,
	output logic o_readMem,
	output logic o_writeRx_ld,
	output logic o_st_Rx,
	output logic o_rd_Rx_mvi,
	output logic o_mvi,
	output logic o_addi,
	output logic o_jump,
	output logic o_new_PC,
	output logic o_call
);

	enum int unsigned
	{
		S_RESET,
		S_FETCH,
		S_READ_DATA,
		S_INC_PC,
		S_UPDATE_PC,
		S_READ_IR,
		S_DECODE,
		S_MV,
		S_READ_OPB_MV,
		S_WRITE_OPA_MV,
		S_ADD,
		S_READ_OPA_ADD,
		S_READ_OPB_ADD,
		S_ADD_INSTR,
		S_WRITE_OPA_ADD,
		S_LD,
		S_READ_OPB_LD,
		S_FETCH_RD,
		S_READ_MEM,
		S_WRITE_OPA_LD,
		S_ST,
		S_ST_OPA,
		S_MVI,
		S_READ_OPA_MVI,
		S_WRITE_OPA_MVI,
		S_NEW_PC,
		S_J_JR_JZ,
		S_CALL,
		S_ADDI
	} state, nextstate;


always_ff @ (posedge clk or posedge reset) begin
	if (reset) state = S_RESET;
	else state <= nextstate;
end


	always_comb begin
	
		nextstate = state;
		o_reset = 1'b0;
		o_set_addr = 1'b0;
		o_mem_rd = 1'b0;
		o_mem_wr = 1'b0;
		o_read_data = 1'b0;
		o_inc_PC = 1'b0;
		o_updatePC = 1'b0;
		o_read_IR = 1'b0;
		o_mv_rd = 1'b0;
		o_mv_wr = 1'b0;
		o_ld_rd = 1'b0;
		o_readRx_add = 1'b0;
		o_readRy_add = 1'b0;
		o_add_add = 1'b0;
		o_writeRx_add = 1'b0;
		o_ld_rd = 1'b0;
		o_readMem = 1'b0;
		o_writeRx_ld= 1'b0;
		o_st_Rx= 1'b0;
		o_rd_Rx_mvi = 1'b0;
		o_mvi= 1'b0;
		o_addi = 1'b0;
		o_jump = 1'b0;
		o_new_PC= 1'b0;
		o_call= 1'b0;

		case (state)
			S_RESET: begin
				o_reset = 1'b1;
				nextstate = S_FETCH;
			end
			
			S_FETCH: begin
				o_set_addr = 1'b1;
				o_mem_rd = 1'b1;
				nextstate = S_READ_DATA;
			end
			
			S_READ_DATA: begin
				o_read_data = 1'b1;
				nextstate = S_INC_PC;
			end
			
			S_INC_PC: begin
				o_inc_PC= 1'b1;
				nextstate = S_UPDATE_PC;
			end
			
			S_UPDATE_PC: begin 
				o_updatePC = 1'b1;
				nextstate = S_READ_IR;
			end
			
			S_READ_IR: begin
				o_read_IR = 1'b1;
				nextstate = S_DECODE;
			end
			
			S_DECODE: begin
				case (i_instr)
					5'b00000:	nextstate = S_MV;
					5'b00001:	nextstate = S_ADD;
					5'b00010:	nextstate = S_ADD;
					5'b00011:	nextstate = S_ADD;
					5'b00100:	nextstate = S_LD;
					5'b00101:	nextstate = S_ST;
					5'b10000:	nextstate = S_MVI;
					5'b10001:	nextstate = S_ADDI;
					5'b10010:	nextstate = S_ADDI;
					5'b10011:	nextstate = S_ADDI;
					5'b10110:	nextstate = S_MVI;
					5'b01000:	nextstate = S_J_JR_JZ;
					5'b01001:	nextstate = S_J_JR_JZ;
					5'b01010:	nextstate = S_J_JR_JZ;
					5'b01100:	nextstate = S_CALL;
					5'b11000:	nextstate = S_J_JR_JZ;
					5'b11001:	nextstate = S_J_JR_JZ;
					5'b11010:	nextstate = S_J_JR_JZ;
					5'b11100:	nextstate = S_CALL;
				endcase
			end
			
			S_MV: begin
				nextstate = S_READ_OPB_MV;
			end 
			
			S_READ_OPB_MV: begin
				o_mv_rd= 1'b1;
				nextstate = S_WRITE_OPA_MV;
			end
			
			S_WRITE_OPA_MV: begin
				o_mv_wr = 1'b1;
				nextstate = S_FETCH;
			end
			
			S_ADD: begin
				nextstate = S_READ_OPA_ADD;
			end
			
			S_READ_OPA_ADD: begin
				o_readRx_add = 1'b1;
				if (i_instr == 5'b10001 || i_instr == 5'b10010 || i_instr == 5'b10011) nextstate = S_ADD_INSTR; 
				else nextstate = S_READ_OPB_ADD;
			end
			
			S_READ_OPB_ADD: begin
				o_readRy_add = 1'b1;
				if (i_instr == 5'b00101) nextstate = S_ST_OPA; // if its a st 
				else nextstate = S_ADD_INSTR;
			end
			
			S_ADD_INSTR: begin
				o_add_add = 1'b1;
				if (i_instr == 5'b00011 || i_instr == 5'b10011) nextstate = S_FETCH; // only for cmp & cmpi
				else nextstate = S_WRITE_OPA_ADD;
			end
			
			S_WRITE_OPA_ADD: begin 
				o_writeRx_add = 1'b1;
				nextstate = S_FETCH;
			end

			S_LD: begin 
				nextstate = S_READ_OPB_LD;
			end
			
			S_READ_OPB_LD: begin
				o_ld_rd = 1'b1;
				nextstate = S_FETCH_RD;
			end
			
			S_FETCH_RD: begin
				o_mem_rd = 1'b1;
				nextstate = S_READ_MEM;
			end
			
			S_READ_MEM :begin
				o_readMem = 1'b1;
				o_mem_rd = 1'b1;
				nextstate = S_WRITE_OPA_LD;
			end
			
			S_WRITE_OPA_LD: begin 
				o_writeRx_ld = 1'b1;
				nextstate = S_FETCH;
			end
			
			S_ST: begin 
				nextstate = S_READ_OPA_ADD;
			end
			
			S_ST_OPA: begin
				o_st_Rx = 1'b1;
				o_mem_wr = 1'b1;
				nextstate = S_FETCH;
			end
			
			S_MVI: begin
				nextstate = S_READ_OPA_MVI;
			end
			
			S_READ_OPA_MVI: begin
				o_rd_Rx_mvi = 1'b1;
				nextstate = S_WRITE_OPA_MVI;
			end

			S_WRITE_OPA_MVI: begin 
				o_mvi = 1'b1;
				nextstate = S_FETCH;
			end

			S_ADDI: begin
				o_addi = 1'b1;
				nextstate = S_READ_OPA_ADD;
			end
			
			S_J_JR_JZ: begin
				o_jump = 1'b1;
				nextstate = S_NEW_PC;
			end
			
			S_NEW_PC: begin
				if (i_instr[3:0] == 4'b1000 || (i_instr[3:0] == 4'b1001 && i_Z == 1) || 
					(i_instr[3:0] == 4'b1010 && i_N == 1) ||i_instr[3:0] == 4'b1100) begin
						o_new_PC = 1'b1;
				end
				nextstate = S_FETCH;
			end
			
			S_CALL: begin
				o_call = 1'b1;
				nextstate = S_J_JR_JZ;
			end
			
			default: nextstate = S_RESET;
			
		endcase
	end
endmodule
