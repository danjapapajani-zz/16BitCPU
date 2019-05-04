module cpu(
	
	input clk,
	input reset,
	input logic [15:0] i_mem_rddata,
	input logic i_mem_wait, //new
	input logic i_mem_rddatavalid, //new
	
	output logic [15:0] o_mem_wrdata,
	output logic [15:0] o_mem_addr,
	output logic o_mem_rd,
	output logic o_mem_wr
);

	logic PC_write;
	logic Addr_sel;
	logic mem_rd;
	logic mem_wr;
	logic MDR_load;
	logic IR_load;
	logic OpA_sel;
	logic OpAB_load;
	logic [1:0] ALU_1_sel;
	logic [1:0] ALU_2_sel;
	logic [1:0] ALUop_sel;
	logic ALU_out;
	logic RF_write;
	logic Reg_in;
	logic Flag_write;
	logic RF_write_call;
	logic mov_hi;
	logic N, Z, imm;
	
	logic [3:0] instr;
	
	datapath data(
		.rst(reset),
		.clk(clk), 
		.i_mem_rddata(i_mem_rddata),
		.i_PC_write(PC_write),
		.i_Addr_sel(Addr_sel),
		.i_mem_wr(mem_wr),
		.i_MDR_load(MDR_load),
		.i_IR_load(IR_load),
		.i_OpA_sel(OpA_sel),
		.i_OpAB_load(OpAB_load),
		.i_ALU_1_sel(ALU_1_sel),
		.i_ALU_2_sel(ALU_2_sel),
		.i_ALUop_sel(ALUop_sel),
		.i_ALU_out(ALU_out),
		.i_RF_write(RF_write),
		.i_Reg_in(Reg_in),
		.i_Flag_write(Flag_write),
		.i_RF_write_call(RF_write_call),
		.i_mov_hi(mov_hi),
		
		.o_N(N),
		.o_Z(Z),
		.o_instr(instr),
		.o_mem_wrdata(o_mem_wrdata),
		.o_mem_addr(o_mem_addr),
		.o_mem_rd(mem_rd),
		.o_mem_wr(mem_wr),
		.o_imm(imm)
	);
	
	control control(
		.rst(reset),
		.clk(clk),
		.i_N(N),
		.i_Z(Z),
		.i_instr(instr),
		.i_imm(imm),
		.i_mem_wait(i_mem_wait),
		.i_mem_rddatavalid(i_mem_rddatavalid), //new
		
		.o_PC_write(PC_write),
		.o_Addr_sel(Addr_sel),
		.o_mem_rd(o_mem_rd),
		.o_mem_wr(o_mem_wr),
		.o_MDR_load(MDR_load),
		.o_IR_load(IR_load),
		.o_OpA_sel(OpA_sel),
		.o_OpAB_load(OpAB_load),
		.o_ALU_1_sel(ALU_1_sel),
		.o_ALU_2_sel(ALU_2_sel),
		.o_ALUop_sel(ALUop_sel),
		.o_ALU_out(ALU_out),
		.o_RF_write(RF_write),
		.o_Reg_in(Reg_in),
		.o_Flag_write(Flag_write),
		.o_RF_write_call(RF_write_call),
		.o_mov_hi(mov_hi)
	);
	
endmodule