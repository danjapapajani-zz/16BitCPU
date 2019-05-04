# Processor Design
Custom 16-bit processor, designed and programmed on an Altera FPGA

# Processor Architecture
# Registers
The Program Counter (PC) register contains thebyte  addressof the currently executing instruction tofetch  from  memory,  and  is  always  an  even  number  (the  lowest  bit  is  0).   The  PC  should  automatically increment by 2 after each executed instruction, and certain instructions (jumps and calls) can further modify its value indirectly.There are also two 1-bit flags registers, N and Z. These stand for Negative and Zero.

<img width="571" alt="Screen Shot 2019-05-04 at 5 40 12 PM" src="https://user-images.githubusercontent.com/25554970/57185101-5792d800-6e93-11e9-87f6-035175f16558.png">


