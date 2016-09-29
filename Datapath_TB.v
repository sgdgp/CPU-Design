
//-------------------------------------------- Datapath Modules and Testbench ----------------------------------------------------------------------//

module tb();

	/*Various Control Signals and Connecting wires used in the the datapath*/

	/*Signals and wires associated with Memory*/
	reg MB1_Mem_Read, MB1_Mem_Write;
	reg [15:0] MB1_Mem_Addr;
	reg [15:0] MB1_Write_Data;
	wire [15:0] Memory_Data_MDR;
	wire [15:0] MB1_Read_Data;
	reg MB1_Memory_Reset;

	/*Signals and wires associated with MDR register*/
	reg MDRWrite, MDRRead, MDRSrc, MDRMemRead;
	reg [15:0] MDR_Write_Data;
	wire [15:0] MDR_Read_Data;

	/*Signals and wires associated with MAR register*/
	reg MARWrite, MARSrc, MARRead;
	wire [15:0] MAR_Read_Data;
	wire [15:0] MAR_Write_Data;

	/*Signals and wires associated with IR register*/
	reg IRWrite, IRRead;
	wire [15:0] IR_Read_Data;

	/*Signals and wires associated with PC register*/
	reg PCRead, PCWrite, PCReset;
	wire [15:0] PC_Read_Data;

	/*Signals and wires associated with Register file*/
    reg RegFile_Read, RegFileWrite, RegFile_Reset;
    reg [2:0] Reg_Number;
    reg [15:0] Reg_File_WD_Write_Data;
	wire [15:0] Reg_File_RD_Read_Data;
	wire [2:0] reg_number_input;
    reg [1:0] WD_RegFileSrc;
	reg [1:0] RegNumberSrc;
	wire [15:0] Reg_File_WD_Data;

	/*Signals and wires associated with ALU and ALUOut register*/
	reg [2:0] ALU_Control_Signal;
	reg ALUOut_Reg_Read, ALUOutWrite, ALUOutRead;
	wire [15:0] ALU_Read_Data;
	wire ALU_Carry_Second_Last,ALU_Carry_Last;	
	wire [15:0] ALUOut_Reg_Read_Data;

	/*Signals and wires associated with T register*/
	reg TWrite;
	wire [15:0] T_Read_Data;

	/*Signals and wires associated with R#2 register*/
	reg Const_2_Read;
	wire [15:0] Const_2_Write_Data;
	
	/*Signals and wires associated with R#0 register*/
	reg Const_0_Read;
	wire [15:0] Const_0_Write_Data;

	/*Signals and wires associated with jump mechanism*/
	reg M_write, Z_write, O_write, C_write;
	reg [1:0] Jump_Flag_Select;
	wire XNOR_Read_Data;
	wire Jump_MUX_Read_Data;
	wire Zero_Flag_Write_Data, Zero_Flag_Read_Data, Zero_Flag_Read_Data_Bar;
	wire Overflow_Flag_Write_Data, Overflow_Flag_Read_Data, Overflow_Flag_Read_Data_Bar;
	wire Minus_Flag_Read_Data, Minus_Flag_Read_Data_Bar;
	wire Carry_Flag_Read_Data, Carry_Flag_Read_Data_Bar;

	/*Buses used in the datapath*/
	wire [15:0] Bus_1, Bus_2;

	/*Instantiating the Register Bank of the datapath*/
	Register_Bank_Structural regbank(Reg_Number, Reg_File_WD_Write_Data, RegFile_Read, RegFileWrite, RegFile_Reset, Reg_File_RD_Read_Data);

	/*Instantiating the ALU of the datapath*/
	ALU_DP alu_1 (ALU_Control_Signal,T_Read_Data,Bus_1,ALU_Read_Data,ALU_Carry_Second_Last,ALU_Carry_Last);

	/*Instantiating the Memory Bank of the datapath*/
	Memory_Bank mem_bank_1 (MB1_Memory_Reset,MAR_Read_Data,MDR_Read_Data,MB1_Mem_Read,MB1_Mem_Write,Memory_Data_MDR);		
	
	/*External registers used in the Datapath*/
	Register MDR(0,MDRWrite,MDR_Write_Data,MDR_Read_Data);
	Register MAR(0,MARWrite,MAR_Write_Data,MAR_Read_Data);
	Register PC(PCReset,PCWrite | XNOR_Read_Data,Bus_2,PC_Read_Data);
	Register T(0,TWrite,Bus_1,T_Read_Data);
	Register IR(0,IRWrite,Bus_1,IR_Read_Data);
	Register ALUOut(0,ALUOutWrite,Bus_2,ALUOut_Reg_Read_Data);

		/*Tristate buffers used in the Datapath*/
	Tri_State_Buffer PC_Tri(PC_Read_Data,PCRead,Bus_1);
	Tri_State_Buffer Const_2_Tri(Const_2_Write_Data,Const_2_Read,Bus_1);
	Tri_State_Buffer ALU_DP_Tri(ALU_Read_Data,ALUOutRead,Bus_2);
	Tri_State_Buffer Reg_File_Tri(Reg_File_RD_Read_Data,RegFile_Read,Bus_1);
	Tri_State_Buffer MDR_Tri(MDR_Read_Data,MDRRead,Bus_1);
	Tri_State_Buffer ALUOut_Reg_Tri(ALUOut_Reg_Read_Data,ALUOut_Reg_Read,Bus_1);	

	/*Multiplexers used in the Datapath*/
	MUX_2_to_1 MAR_MUX(Bus_1,Bus_2,MAR_Write_Data,MARSrc);
	MUX_2_to_1 MDR_MUX(Bus_2,Memory_Data_MDR,MDR_Write_Data,MDRSrc);
	MUX_3_to_1_3_bit Reg_Number_xor(IR_Read_Data[6:4],IR_Read_Data[12:10],IR_Read_Data[15:13],reg_number_input,RegNumberSrc);
	MUX_2_to_1 Reg_File_WD_MUX(Bus_1,Bus_2,Reg_File_WD_Data,WD_RegFileSrc);
	MUX_4_to_1_1_Bit Jump_Conditional(Minus_Flag_Read_Data,Zero_Flag_Read_Data,Overflow_Flag_Read_Data,Carry_Flag_Read_Data,Jump_MUX_Read_Data,Jump_Flag_Select);
	
	/*D-flipflops used in the Datapath (to store a single bit) */
	D_FlipFlop Minus_Flag(Minus_Flag_Read_Data,Minus_Flag_Read_Data_Bar,ALU_Read_Data[15],M_Write,0);
	D_FlipFlop Zero_Flag(Zero_Flag_Read_Data,Zero_Flag_Read_Data_Bar,Zero_Flag_Write_Data,Z_Write,0);
	D_FlipFlop Overflow_Flag(Overflow_Flag_Read_Data,Overflow_Flag_Read_Data_Bar,Overflow_Flag_Write_Data,O_Write,0);
	D_FlipFlop Carry_Flag(Carry_Flag_Read_Data,Carry_Flag_Read_Data_Bar,ALU_Carry_Last,C_Write,0);

	/*Other logic gates used in the Datapath*/
	AND_16_Gate Zero_And_Gate(ALU_Read_Data,Zero_Flag_Write_Data);	
	XOR_2_Gate XOR_Overflow_1(ALU_Carry_Second_Last,ALU_Carry_Last,Overflow_Flag_Write_Data);
	XNOR_Gate_1_Bit Jump_XNOR_1(IR_Read_Data[7],Jump_MUX_Read_Data,XNOR_Read_Data);

	assign Const_2_Write_Data = 16'b0000000000000010;

	/*
		Here we are first reseting the value in PC to 0. 
		Then we are externally storing a value in the memory bank at the 0th location.
		Then we are transfering the value in PC register to MAR register and T register simultaneously.
		Then we are accessing the value present at that location.
		Then we are transfering the value accessed into the MDR register.
		Then we are transfering the value on R#2 register to the ALU input.
		Then we are adding the present value of PC with the constant 2 and getting the new value of PC i.e. (PC+2) by sending the appropriate control signal to the ALU and getting the ALU output.
		Then we are storing this new updated value of PC in the PC register.
		Then we are storing a new desired value in register number 4 in the Register Bank.
		Then we are checking the previously stored value in the register bank.
		Then we are storing a new desired value in register number 5 in the Register Bank.
		Then we are checking the previously stored value in the register bank.
	*/

    initial begin
		IRWrite = 0;
		IRRead = 0;
		ALUOut_Reg_Read = 0;
		ALUOutWrite = 0;
		ALUOutRead = 0;
		Const_0_Read = 0;
		M_write = 0;
		Z_write = 0;
		O_write = 0;
		C_write = 0;
		RegFile_Read = 0;
		RegFileWrite = 0;
		PCReset = 0;
		Const_2_Read = 0;
		ALUOutRead = 0;
		RegFile_Reset = 0;
		MB1_Memory_Reset = 0;
		MARWrite = 0;
		PCRead = 0;	
		PCWrite = 0;	
		TWrite = 0;
		MB1_Mem_Read = 0;
		MB1_Mem_Write = 0;
		MDRWrite = 0;
		MDRRead = 0;

		#300
		PCReset = 1;
		#1 PCWrite = 1;
		
		#300
		PCReset = 0;
		#1 PCWrite = 0;
	  	 #1 $monitor($time, "\tPC Read Data = %b\n\n",PC_Read_Data);   

		#300
		MB1_Memory_Reset = 1;
	  	 #1 $monitor($time, "\tMemory Bank Array[0] = %b\n\n",mem_bank_1.Memory_Bank_Array[0]);   

		#300
		MB1_Memory_Reset = 0;

		#300
		PCRead = 1;
		#1 MARSrc = 1;
		#1 MARWrite = 1;
		#1 TWrite = 1;
	  	 #1 $monitor($time, "\tMAR Read Data = %b\n\n",MAR_Read_Data);   
	  	 #1 $monitor($time, "\tT Read_Data = %b\n\n",T_Read_Data);   
	  	 #1 $monitor($time, "\tBus_1 Data = %b\n\n",Bus_1);   
			
		#300
		PCRead = 0;
		#1 MARWrite = 0;
		#1 TWrite = 0;

		#300
		Const_2_Read = 0;
		#1 ALUOutRead = 0;
		#1 RegFile_Reset = 0;
		#1 MB1_Memory_Reset = 0;
		#1 MARWrite = 0;
		#1 PCRead = 0;	
		#1 PCWrite = 0;	
		#1 TWrite = 0;
		#1 MB1_Mem_Read = 0;
		#1 MB1_Mem_Write = 0;
		#1 MDRWrite = 0;
		#1 MDRRead = 0;

		#1 MB1_Mem_Read = 1;
		#1 MB1_Mem_Write = 0;
		#1 MDRSrc = 0;
		#1 MDRWrite = 1;
		#1 Const_2_Read = 1;
		#1 ALU_Control_Signal <= 3'b000;
	  	 #1 $monitor($time, "\tMemory Data MDR = %b\n\n",Memory_Data_MDR);
	  	 #1 $monitor($time, "\tMDR_Read_Data = %b\n\n",MDR_Read_Data);
	  	 #1 $monitor($time, "\tBus_1 Data = %b\n\n",Bus_1);  
	  	 #1 $monitor($time, "\tALU Read Data = %b\n\n",ALU_Read_Data);  
	  	 #1 $monitor($time, "\tALU Read Data = %b\n\n",ALUOutRead);  
		
		#300
		ALUOutRead = 1;
		#1 PCWrite = 1;	
	  	 #1 $monitor($time, "\tBus_2 Data = %b\n\n",Bus_2);  
	  	 #1 $monitor($time, "\tPC Read Data = %b\n\n",PC_Read_Data);  

		#300
		ALUOutRead = 0;
		#1 PCWrite = 0;	
		#1 MB1_Mem_Read = 0;
		#1 MB1_Mem_Write = 0;
		#1 MDRWrite = 0;
		#1 Const_2_Read = 0;

		#300
		Const_2_Read = 0;
		#1 ALUOutRead = 0;
		#1 RegFile_Reset = 0;
		#1 MB1_Memory_Reset = 0;
		#1 MARWrite = 0;
		#1 PCRead = 0;	
		#1 PCWrite = 0;	
		#1 TWrite = 0;
		#1 MB1_Mem_Read = 0;
		#1 MB1_Mem_Write = 0;
		#1 MDRWrite = 0;
		#1 MDRRead = 0;

		#300
		Reg_Number = 3'b100; 
		#1 Reg_File_WD_Write_Data = 16'b0000111100000001;
		#1 RegFile_Read = 0;
		#1 RegFileWrite = 1;    

		#300
		Reg_Number = 3'b100;
		#1 RegFile_Read = 1;
		#1 RegFileWrite = 0;  
		
	  	 #1 $monitor($time, "\tRegFile Read Data = %b\n\n",Reg_File_RD_Read_Data);   

		 #1 $monitor($time, "\tRegister_7 Data = %b\n",regbank.Register_7);   
		 #1 $monitor($time, "\tRegister_6 Data = %b\n",regbank.Register_6);   
		 #1 $monitor($time, "\tRegister_5 Data = %b\n",regbank.Register_5);   
		 #1 $monitor($time, "\tRegister_4 Data = %b\n",regbank.Register_4);   
		 #1 $monitor($time, "\tRegister_3 Data = %b\n",regbank.Register_3);   
		 #1 $monitor($time, "\tRegister_2 Data = %b\n",regbank.Register_2);   
		 #1 $monitor($time, "\tRegister_1 Data = %b\n",regbank.Register_1);   
		 #1 $monitor($time, "\tRegister_0 Data = %b\n\n",regbank.Register_0);   

		#300
		Const_2_Read = 0;
		#1 ALUOutRead = 0;
		#1 RegFile_Reset = 0;
		#1 MB1_Memory_Reset = 0;
		#1 MARWrite = 0;
		#1 PCRead = 0;	
		#1 PCWrite = 0;	
		#1 TWrite = 0;
		#1 MB1_Mem_Read = 0;
		#1 MB1_Mem_Write = 0;
		#1 MDRWrite = 0;
		#1 MDRRead = 0;

		#300
		Reg_Number = 3'b101; 
		#1 Reg_File_WD_Write_Data = 16'b0001111111111111;
		#1 RegFile_Read = 0;
		#1 RegFileWrite = 1;    

		#300
		Reg_Number = 3'b101;
		#1 RegFile_Read = 1;
		#1 RegFileWrite = 0;  
		
	  	 #1 $monitor($time, "\tRegFile Read Data = %b\n\n",Reg_File_RD_Read_Data);   

		 #1 $monitor($time, "\tRegister_7 Data = %b\n",regbank.Register_7);   
		 #1 $monitor($time, "\tRegister_6 Data = %b\n",regbank.Register_6);   
		 #1 $monitor($time, "\tRegister_5 Data = %b\n",regbank.Register_5);   
		 #1 $monitor($time, "\tRegister_4 Data = %b\n",regbank.Register_4);   
		 #1 $monitor($time, "\tRegister_3 Data = %b\n",regbank.Register_3);   
		 #1 $monitor($time, "\tRegister_2 Data = %b\n",regbank.Register_2);   
		 #1 $monitor($time, "\tRegister_1 Data = %b\n",regbank.Register_1);   
		 #1 $monitor($time, "\tRegister_0 Data = %b\n\n",regbank.Register_0);

		end

endmodule
