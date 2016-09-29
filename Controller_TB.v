
//-------------------------------------------- Controller Module and Testbench ----------------------------------------------------------------------//

module tb;
    reg [3:0]opcode_arr [7:0];
    reg [2:0]mode [7:0];
    reg ready, clk;
    reg  [2:0]jump_instr_type[7:0];

    
    wire MemRead, MemWrite, MARRead, MARWrite, MDRWrite, MDRSrc, MDRRead, MDRMemRead, MARSrc, IRWrite, IRRead, PCWrite, PCRead, RegFileRead, RegFileWrite, WD_RegFileSrc, ALUOutRead, ALUOutWrite, ALUOutRegRead, T_Read, T_Write,  const_2_Read,  const_0_Read, Z_Write, C_Write, M_Write, O_Write;
    
   wire [6:0]state;
    wire [1:0]RegNumberSrc;

    wire [2:0]ALU_CS;

    wire [1:0]Jump_Flag_Select;

  controller ctr(opcode_arr, mode,state, ready, jump_instr_type, clk, MemRead, MemWrite, MARWrite, MARRead, MARSrc, MDRSrc, MDRRead, MDRMemRead, WD_RegFileSrc, MDRWrite, IRWrite, IRRead, PCWrite, PCRead, RegFileRead, RegFileWrite, WD_RegFileSrc, ALUOutWrite, ALUOutRead, ALUOutRegRead, T_Read, T_Write, ALU_CS, Jump_Flag_Select, RegNumberSrc, const_0_Read, const_2_Read, Z_Write, C_Write, M_Write, O_Write);
    initial begin
    clk = 0;
    $display("\tThe instructions tested are according to the following serial number :\n");
    $display("\t\t1.Load Immediate\n");
    opcode_arr[0] = 4'b1000;
    mode[0] = 3'b001;
    jump_instr_type[0] = 3'b000;
    ready = 0;
    $display("\t\t2.Load Indirect\n");
    opcode_arr[1] = 4'b1000;
    mode[1] = 3'b100;
    jump_instr_type[0] = 3'b000;
    ready = 0;

    $display("\t\t3.Add Indirect\n");
    opcode_arr[2] = 4'b0000;
    mode[2] = 3'b100;
    jump_instr_type[2] = 3'b000;
    ready = 0;

    $display("\t\t4.Sub Register\n");
    opcode_arr[3] = 4'b0001;
    mode[3] = 3'b000;
    jump_instr_type[3] = 3'b000;
    ready = 0;

    $display("\t\t5.And Base-Indexed\n");
    opcode_arr[4] = 4'b0010;
    mode[4] = 3'b010;
    jump_instr_type[4] = 3'b000;
    ready = 0;

    $display("\t\t6.Jump Unconditional\n");
    opcode_arr[5] = 4'b1010;
    mode[5] = 3'b101;
    jump_instr_type[5] = 3'b000;
    ready = 0;

    $display("\t\t7.Store Base_addressed\n");
    opcode_arr[6] = 4'b1001;
    mode[6] = 3'b011;
    jump_instr_type[6] = 3'b000;
    ready = 0;

    $display("\t\t8.jal instruction\n");
    opcode_arr[7] = 4'b1100;
    mode[7] = 3'b011;
    jump_instr_type[7] = 3'b000;
    ready = 0;

    end
    always  #50 clk = ~(clk);
endmodule
