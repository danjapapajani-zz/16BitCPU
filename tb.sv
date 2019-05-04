module tb();

// Change this to use a different program!
localparam HEX_FILE = "capital.hex";

// Create a 100MHz clock
logic clk;
initial clk = '0;
always #5 clk = ~clk;

// Create the reset signal and assert it for a few cycles
logic reset;
initial begin
	reset = '1;
	@(posedge clk);
	@(posedge clk);
	reset = '0;
end

// Declare the bus signals, using the CPU's names for them
logic [15:0] o_mem_addr;
logic o_mem_rd;
logic [15:0] i_mem_rddata;
logic o_mem_wr;
logic [15:0] o_mem_wrdata;

// Instantiate the processor and hook up signals.
// Since the cpu's ports have the same names as the signals
// in the testbench, we can use the .* shorthand to automatically match them up

	logic rst;
	logic set_addr;
	logic read_data;
	logic inc_PC;
	logic updatePC;
	logic read_IR;
	logic mv_rd;
	logic mv_wr;
	logic ld_rd;
	logic readRx_add;
	logic readRy_add;
	logic add_add;
	logic writeRx_add;
	logic readMem;
	logic writeRx_ld;
	logic st_Rx;
	logic rd_Rx_mvi;
	logic mvi;
	logic addi;
	logic jump;
	logic new_PC;
	logic call;
	logic [4:0] instr;
	logic N;
	logic Z;
	logic [3:0] imm;
	
	datapath data(
		.reset(reset),
		.clk(clk), 
		.i_mem_rddata(i_mem_rddata),
		.i_reset(rst),
		.i_set_addr(set_addr),
		.i_read_data(read_data),
		.i_inc_PC(inc_PC),
		.i_read_IR(read_IR),
		.i_mv_rd(mv_rd),
		.i_mv_wr(mv_wr),
		.i_readRx_add(readRx_add),
		.i_readRy_add(readRy_add),
		.i_add_add(add_add),
		.i_updatePC(updatePC),
		.i_writeRx_add(writeRx_add),
		.i_ld_rd(ld_rd),
		.i_readMem(readMem),
		.i_writeRx_ld(writeRx_ld),
		.i_st_Rx(st_Rx),
		.i_rd_Rx_mvi(rd_Rx_mvi),
		.i_mvi(mvi),
		.i_addi(addi),
		.i_jump(jump),
		.i_new_PC(new_PC),
		.i_call(call),
	
		.o_N(N),
		.o_Z(Z),
		.o_opCode(instr),
		.o_mem_wrdata(o_mem_wrdata),
		.o_mem_addr(o_mem_addr),
		.o_mem_rd(o_mem_rd),
		.o_mem_wr(o_mem_wr)
	);
	

	
	control control(
		.reset(reset),
		.clk(clk),
		.i_N(N),
		.i_Z(Z),
		.i_instr(instr),

		.o_mem_rd(o_mem_rd),
		.o_mem_wr(o_mem_wr),
		.o_reset(rst),
		.o_set_addr(set_addr),
		.o_read_data(read_data),
		.o_inc_PC(inc_PC),
		.o_updatePC(updatePC),
		.o_read_IR(read_IR),
		.o_mv_rd(mv_rd),
		.o_mv_wr(mv_wr),
		.o_ld_rd(ld_rd),
		.o_readRx_add(readRx_add),
		.o_readRy_add(readRy_add),
		.o_add_add(add_add),
		.o_writeRx_add(writeRx_add),
		.o_readMem(readMem),
		.o_writeRx_ld(writeRx_ld),
		.o_st_Rx(st_Rx),
		.o_rd_Rx_mvi(rd_Rx_mvi),
		.o_mvi(mvi),
		.o_addi(addi),
		.o_jump(jump),
		.o_new_PC(new_PC),
		.o_call(call)
		
	);
	

// Create a 64KB memory
logic [15:0] mem [0:32767];

always_ff @ (posedge clk) begin
	// Read logic.
	// For extra compliance, fill readdata with garbage unless
	// rd enable is actually used.
	if (o_mem_rd) i_mem_rddata <= mem[o_mem_addr[15:1]];
	else i_mem_rddata <= 16'bx;
	
	// Write logic
	if (o_mem_wr) mem[o_mem_addr[15:1]] <= o_mem_wrdata;
end

// Initialize memory
initial begin
	$display("Reading %s", HEX_FILE);
	$readmemh(HEX_FILE, mem);
end

// Writes to certain addresses will terminate the simulaton and print a result.
always_ff @ (posedge clk) begin
	if (o_mem_wr && o_mem_addr == 16'h1000) begin
		// Writing a number to 0x1000 will display it
		$display("Integer result: %h", o_mem_wrdata);
		$stop();
	end
	else if (o_mem_wr && o_mem_addr == 16'h1002) begin
		// Writing an address to 0x1002 will print the null-terminated string
		// at that address, as long as it's up to 512 characters long.
		int rd_addr;
		string str;
		int str_len;
		
		// Allocate a verilog string with 512 characters (we can't expand strings apparently).
		// rd_addr points to the string to print out, and the CPU gave this to us
		str = {512{" "}};
		str_len = 0;
		rd_addr = o_mem_wrdata;

		while (str_len < 512) begin
			logic [15:0] rd_val;
			rd_val = mem[rd_addr >> 1];
			
			if (rd_val == 16'hxxxx) begin
				$display("Bad string result: got xxxx at address %h",
					rd_addr);
				$stop();
			end
			
			// The lower 8 bits of the 16-bit word are an ASCII character to add to the string
			str.putc(str_len, rd_val[7:0]);
			
			// Got null terminator, we're done
			if (rd_val == 16'd0) 
				break;
			
			// Advance memory read position (by 1 word) and string write position
			rd_addr += 2;
			str_len++;
		end
		
		// Ran out of string room?
		if (str_len == 512) begin
			$display("Bad string result: no null terminator found after 512 chars");
			$stop();
		end
		
		// Got string, display it
		$display("String result: %s", str.substr(0, str_len-1));
		$stop();
	end
end

endmodule
