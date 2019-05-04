# Processor Design
Custom 16-bit processor, designed and programmed on an Altera FPGA

# Processor Architecture
# Registers
The Program Counter (PC) register contains thebyte  addressof the currently executing instruction tofetch  from  memory,  and  is  always  an  even  number  (the  lowest  bit  is  0).   The  PC  should  automatically increment by 2 after each executed instruction, and certain instructions (jumps and calls) can further modify its value indirectly.There are also two 1-bit flags registers, N and Z. These stand for Negative and Zero.

# Instruction Set
The first column gives each instruction’s name and operands. Operands Rx or Ry are place holders for the names of one of the eight general-purpose registers. Some  instructions  take  their  inputs  not  from  the  contents  of  registers,  but  fromimmediateoperands, which are numbers stored within the instruction word itself.  These come in two sizes:  8-bit (imm8)or 11-bit (imm11), and are sometimes sign-extended to 16 bits before use.The second column describes the operations performed by the instruction.[Rx]refers to the contentsof the register named by the 3-bit indexRxin the general-purpose register file, and this is the conventionused throughout this document. Finally, the right-hand  side  of  the  table  gives  the  encoding  of  the  instruction. The least-significant  5bits specify theopcodethat identifies the type of the instruction, with the remaining 11 bits encoding theoperands, which are some combination of register names and/or immediate values.  

<img width="571" alt="Screen Shot 2019-05-04 at 5 40 12 PM" src="https://user-images.githubusercontent.com/25554970/57185101-5792d800-6e93-11e9-87f6-035175f16558.png">

# Operation
Upon reset, the contents of registers PC, R0-R7, N, and Z shall be set to 0.  After coming out of reset, the processor will continue to execute instructions forever.  This involves:
  1. Fetching the 16-bit word from memory at address = PC
  2. Incrementing PC by 2
  3. Based on the encoding of the fetched 16-bit word, performing the corresponding operation(s)
  4. Going back to step 1.
  
Our design can execute one instruction every 3 or 4 clock cycles.  

# Signal Interface
Our processor writes to memory by asserting address, writedata, and the write enable.  For reads, read data will be returned one cycle after you assert address and the read enable.

<img width="271" alt="Screen Shot 2019-05-04 at 5 50 07 PM" src="https://user-images.githubusercontent.com/25554970/57185161-6e85fa00-6e94-11e9-8127-825e72fb460c.png">



