
module datapath
(
	input clk,
	input reset,
	
	output logic [15:0] o_mem_addr,
	
	output logic o_mem_rd,
	input [15:0] i_mem_rddata,
	
	output logic o_mem_wr,
	output logic [15:0] o_mem_wrdata,
	
	input i_reset,
	input i_set_addr,
	input i_read_data,
	input i_inc_PC,
	input i_read_IR,
	input i_mv_rd,
	input i_mv_wr,
	input i_readRx_add,
	input i_readRy_add,
	input i_add_add,
	input i_updatePC,
	input i_writeRx_add,
	input i_ld_rd,
	input i_readMem,
	input i_writeRx_ld,
	input i_st_Rx,
	input i_rd_Rx_mvi,
	input i_mvi,
	input i_addi,
	input i_jump,
	input i_new_PC,
	input i_call,
	
	output logic [4:0] o_opCode,
	output logic o_N,
	output logic o_Z
);

	logic [15:0] ALU_in0;
	logic [15:0] ALU_in1;
	logic ALUop;
	logic [15:0] ALU_out;
	logic N_temp;
	logic Z_temp;
	logic set_flags;

	ALU ALU
	(
		.in_0(ALU_in0),
		.in_1(ALU_in1),
		.ALUop(ALUop),
		.result(ALU_out),
		.N(N_temp),
		.Z(Z_temp)
	);

	always @ (set_flags) begin
		o_N <= N_temp;
		o_Z <= Z_temp;
	end

	logic [15:0] PC;
	logic [15:0] IR;
	logic [15:0] MDR;

	logic [2:0] reg_num;
	logic reg_rd_wr;
	logic [15:0] reg_data_in;
	logic [15:0] reg_data_out;
	
	RF register_file
	(
		.reg_num(reg_num),
		.rd_wr(reg_rd_wr),
		.d_in(reg_data_in),
		.d_out(reg_data_out)
	);

	logic [2:0] Rx;
	logic [2:0] Ry;
	logic [7:0] imm8;
	logic [10:0] imm11;

	logic [15:0] tempReg1;
	logic [15:0] tempReg2;

	logic [15:0] mem_data;
	always@ (negedge clk) begin
		mem_data <= i_mem_rddata;
	end

	always_comb begin
		set_flags = 1'b0;
		if (i_reset) begin
			PC = 16'b0;
			IR = 16'b0;
		end
		
		else if (i_set_addr) o_mem_addr = PC;
		
		else if (i_read_data) IR = mem_data;
		
		else if (i_inc_PC) begin
			ALU_in0 = PC;
			ALU_in1 = 2'd2;
			ALUop = 1'b0;
		end 
		
		else if (i_updatePC) PC = ALU_out;
		
		else if (i_read_IR) begin
			o_opCode = IR[4:0];
			Rx = IR[7:5];
			Ry = IR[10:8];
			imm8 = IR[15:8];
			imm11 = IR[15:5];
		end
		
		else if (i_mv_rd) begin
			reg_num = Ry;
			reg_rd_wr = 1'b0;
			tempReg1 = reg_data_out;
		end
		
		else if (i_mv_wr) begin
			reg_num = Rx;
			reg_rd_wr = 1'b1;
			reg_data_in = tempReg1;
		end
		
		else if (i_readRx_add) begin
			reg_num = Rx;
			reg_rd_wr = 1'b0;
			tempReg1 = reg_data_out;
		end
		
		else if (i_readRy_add) begin
			reg_num = Ry;
			reg_rd_wr = 1'b0;
			tempReg2 = reg_data_out;
		end
		
		else if (i_add_add) begin
			ALU_in0 = tempReg1;
			ALU_in1 = tempReg2;
			if (o_opCode == 5'b00001 || o_opCode == 5'b10001) ALUop = 1'b0; 
			else ALUop = 1'b1;
			set_flags = 1'b1;
		end
		
		else if (i_writeRx_add) begin
			reg_num = Rx;
			reg_rd_wr = 1'b1;
			reg_data_in = ALU_out;
		end
		
		else if (i_ld_rd) begin
			reg_num = Ry;
			reg_rd_wr = 1'b0;
			tempReg1 = reg_data_out;
		end
		
		else if (i_readMem) o_mem_addr = tempReg1;
		
		else if (i_writeRx_ld) begin
			reg_num = Rx;
			reg_rd_wr = 1'b1;
			reg_data_in = mem_data;
		end
		
		else if (i_st_Rx) begin
			o_mem_addr = tempReg2;
			o_mem_wrdata = tempReg1;
		end
		
		else if (i_rd_Rx_mvi) begin
			reg_num = Rx;
			reg_rd_wr = 1'b0;
			tempReg1 = reg_data_out;
		end
		
		else if (i_mvi) begin
			reg_num = Rx;
			reg_rd_wr = 1'b1;
			if (o_opCode == 5'b10110) begin
				reg_data_in[7:0] = tempReg1[7:0];
				reg_data_in[15:8] = imm8; 
			end
			else reg_data_in = $signed(imm8);
		end
		
		else if (i_addi) begin
			tempReg2 = $signed(imm8);
		end
		
		else if (i_jump) begin
			if (o_opCode[4] == 0) begin 
				reg_num = Rx;
				reg_rd_wr = 1'b0;
				tempReg1 = reg_data_out;
			end
			else begin
				tempReg1 = PC + $signed(2 * $signed(imm11));
			end
		end
		
		else if (i_new_PC) begin
			PC = tempReg1;
		end
		
		else if (i_call) begin  
			reg_num = 3'b111;
			reg_rd_wr = 1'b1;
			reg_data_in = PC;
		end
		
	end
endmodule 

	
		
	
