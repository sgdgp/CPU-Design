
//-------------------------------------------- Datapath Modules and Testbench ----------------------------------------------------------------------//

/*Module for D flip-flop*/
module D_FlipFlop ( output Q, output Q_bar, input D, input Clock, input Reset );
	reg Q, Q_bar;
	always @(posedge Clock)	begin
		if(Reset == 1) begin
			Q <= 0;
			Q_bar <= 1;
		end
		else begin
			Q <= D;
			Q_bar <= ~D;
		end
	end
endmodule

/*Module for implementation for 1-bit 2-input AND gate*/
module XOR_2_Gate ( input op1,input op2,output out );
	wire op1, op2, out;
	assign out = op1^op2;
endmodule

/*Module for implementation for 1-bit 2-operand XNOR gate*/
module	XNOR_Gate_1_Bit ( input op1,input op2,output out );
	wire op1,op2,out;
	assign out = !(op1^op2);
endmodule

/*Module for implementation for 1-bit 16-input AND gate*/
module 	AND_16_Gate ( input [15:0] In_Data,output Out );
	wire [15:0] In_Data;
	wire Out;
	assign Out = In_Data[15]&In_Data[14]&In_Data[13]&In_Data[12]&In_Data[11]&In_Data[10]&In_Data[9]&In_Data[8]&In_Data[7]&In_Data[6]&In_Data[5]&In_Data[4]&In_Data[3]&In_Data[2]&In_Data[1]&In_Data[0];
endmodule

/*Module for implementation for MUX_2_to_1*/
module MUX_2_to_1 ( In_1,In_0,Out,select );
	input [15:0] In_0,In_1;
	input select;
	wire [15:0] In_0,In_1;
	wire select;
	output [15:0] Out;
	wire [15:0] Out;	
	assign Out = (select == 1)?(In_1):(In_0);
endmodule

/*Module for implementation for MUX_3_to_1_3_bit*/
module MUX_3_to_1_3_bit ( In_2,In_1,In_0,Out,select );
	input [2:0] In_0,In_1,In_2;
	input [1:0] select;
	wire [2:0] In_0,In_1,In_2;
	wire [1:0] select;
	output [2:0] Out;
	wire [2:0] Out;
	assign Out = ((!select[1])&(!select[0]))?(In_0):(((!select[1])&(select[0]))?(In_1):(((select[1])&(!select[0]))?(In_2):(16'bzzzzzzzzzzzzzzzz)));	
endmodule

/*Module for implementation for MUX_4_to_1*/
module MUX_4_to_1_1_Bit ( In_0,In_1,In_2,In_3,Out,select );
	input In_0,In_1,In_2,In_3;
	input [1:0] select;
	wire In_0,In_1,In_2,In_3;
	wire [1:0] select;
	output Out;
	wire Out;	
	assign Out = ((!select[1])&(!select[0]))?(In_0):(((!select[1])&(select[0]))?(In_1):(((select[1])&(!select[0]))?(In_2):(((select[1])&(select[0]))?(In_3):(16'bzzzzzzzzzzzzzzzz))));	
endmodule

/*Module for implementation for MUX_8_to_1*/
module MUX_8_to_1 ( In_7,In_6,In_5,In_4,In_3,In_2,In_1,In_0,Out,select );
	input [15:0] In_0,In_1,In_2,In_3,In_4,In_5,In_6,In_7;
	input [2:0] select;
	wire [15:0] In_0,In_1,In_2,In_3,In_4,In_5,In_6,In_7;
	wire [2:0] select;
	output [15:0] Out;
	wire [15:0] Out;
	assign Out = ((!select[2])&(!select[1])&(!select[0]))?(In_0):(((!select[2])&(!select[1])&(select[0]))?(In_1):(((!select[2])&(select[1])&(!select[0]))?(In_2):(((!select[2])&(select[1])&(select[0]))?(In_3):(((select[2])&(!select[1])&(!select[0]))?(In_4):(((select[2])&(!select[1])&(select[0]))?(In_5):(((select[2])&(select[1])&(!select[0]))?(In_6):(((select[2])&(select[1])&(select[0]))?(In_7):(16'bzzzzzzzzzzzzzzzz))))))));
endmodule

/*Module for implementation for Decoder_3_to_8*/
module Decoder_3_to_8 ( input [2:0] In_Number, output [7:0] lines );
	wire [2:0] In_Number;
	wire [7:0] lines;
	assign lines[0] = (!In_Number[2])&(!In_Number[1])&(!In_Number[0]);
	assign lines[1] = (!In_Number[2])&(!In_Number[1])&(In_Number[0]);
	assign lines[2] = (!In_Number[2])&(In_Number[1])&(!In_Number[0]);
	assign lines[3] = (!In_Number[2])&(In_Number[1])&(In_Number[0]);
	assign lines[4] = (In_Number[2])&(!In_Number[1])&(!In_Number[0]);
	assign lines[5] = (In_Number[2])&(!In_Number[1])&(In_Number[0]);
	assign lines[6] = (In_Number[2])&(In_Number[1])&(!In_Number[0]);
	assign lines[7] = (In_Number[2])&(In_Number[1])&(In_Number[0]);
endmodule

/*Module for implementation for Tri_State_Buffer*/
module Tri_State_Buffer ( Input_Val,Enable,Output_Val );
	input [15:0] Input_Val;
	input Enable;
		output [15:0] Output_Val;
	assign Output_Val = (Enable==1)? (Input_Val) : (16'bzzzzzzzzzzzzzzzz);
endmodule

/*Module for structural implementation for Register*/
module Register ( input register_reset, input register_write, input [15:0] data_in, output [15:0] data_out);
	wire [15:0] data_out;
	wire [15:0] data_out_bar;
	D_FlipFlop bit_0(data_out[0], data_out_bar[0], (register_reset==1)?(1'b0):(data_in[0]), register_write,0);
	D_FlipFlop bit_1(data_out[1], data_out_bar[1], (register_reset==1)?(1'b0):(data_in[1]), register_write,0);
	D_FlipFlop bit_2(data_out[2], data_out_bar[2], (register_reset==1)?(1'b0):(data_in[2]), register_write,0);
	D_FlipFlop bit_3(data_out[3], data_out_bar[3], (register_reset==1)?(1'b0):(data_in[3]), register_write,0);
	D_FlipFlop bit_4(data_out[4], data_out_bar[4], (register_reset==1)?(1'b0):(data_in[4]), register_write,0);
	D_FlipFlop bit_5(data_out[5], data_out_bar[5], (register_reset==1)?(1'b0):(data_in[5]), register_write,0);
	D_FlipFlop bit_6(data_out[6], data_out_bar[6], (register_reset==1)?(1'b0):(data_in[6]), register_write,0);
	D_FlipFlop bit_7(data_out[7], data_out_bar[7], (register_reset==1)?(1'b0):(data_in[7]), register_write,0);
	D_FlipFlop bit_8(data_out[8], data_out_bar[8], (register_reset==1)?(1'b0):(data_in[8]), register_write,0);
	D_FlipFlop bit_9(data_out[9], data_out_bar[9], (register_reset==1)?(1'b0):(data_in[9]), register_write,0);
	D_FlipFlop bit_10(data_out[10], data_out_bar[10], (register_reset==1)?(1'b0):(data_in[10]), register_write,0);
	D_FlipFlop bit_11(data_out[11], data_out_bar[11], (register_reset==1)?(1'b0):(data_in[11]), register_write,0);
	D_FlipFlop bit_12(data_out[12], data_out_bar[12], (register_reset==1)?(1'b0):(data_in[12]), register_write,0);
	D_FlipFlop bit_13(data_out[13], data_out_bar[13], (register_reset==1)?(1'b0):(data_in[13]), register_write,0);
	D_FlipFlop bit_14(data_out[14], data_out_bar[14], (register_reset==1)?(1'b0):(data_in[14]), register_write,0);
	D_FlipFlop bit_15(data_out[15], data_out_bar[15], (register_reset==1)?(1'b0):(data_in[15]), register_write,0);

endmodule

/*Module for structural implementation for Register Bank*/
module Register_Bank_Structural ( input [2:0] Reg_Number, input [15:0] Write_Data, input RegFile_Read, input RegFileWrite, input RegFile_Reset, output [15:0] Read_Data );		
	wire [7:0] decoder_write;
	Decoder_3_to_8 deco_1(.In_Number(Reg_Number), .lines(decoder_write));
	wire [15:0] Register_Out,Register_7,Register_6,Register_5,Register_4,Register_3,Register_2,Register_1,Register_0;	
	
	Register reg_7 (0,decoder_write[7] & RegFileWrite, Write_Data, Register_7);
	Register reg_6 (0,decoder_write[6] & RegFileWrite, Write_Data, Register_6);
	Register reg_5 (0,decoder_write[5] & RegFileWrite, Write_Data, Register_5);
	Register reg_4 (0,decoder_write[4] & RegFileWrite, Write_Data, Register_4);
	Register reg_3 (0,decoder_write[3] & RegFileWrite, Write_Data, Register_3);
	Register reg_2 (0,decoder_write[2] & RegFileWrite, Write_Data, Register_2);
	Register reg_1 (0,decoder_write[1] & RegFileWrite, Write_Data, Register_1);
	Register reg_0 (0,decoder_write[0] & RegFileWrite, Write_Data, Register_0);

	MUX_8_to_1 Reg_Bank_MUX (Register_7,Register_6,Register_5,Register_4,Register_3,Register_2,Register_1,Register_0,Register_Out,Reg_Number);	

	assign Read_Data = (RegFile_Read)?(Register_Out):(16'bzzzzzzzzzzzzzzzz);	
endmodule

/*Module for behavioral implementation for ALU of the datapath*/
module ALU_DP ( ALU_Control_Signal, In_1, In_2, Output, Carry_Bit_Last, Carry_Bit_Second_Last );
	 input [2:0] ALU_Control_Signal;
	 input [15:0] In_1;
	 input [15:0] In_2;	 
	 output [15:0] Output;
	 output Carry_Bit_Last, Carry_Bit_Second_Last;
	 reg [14:0] temp_sum;
	 reg [15:0] Output;
	 reg Carry_Bit_Last, Carry_Bit_Second_Last;
	 always @(ALU_Control_Signal, In_1, In_2)
	 begin
		 if(ALU_Control_Signal == 3'b000)
		 begin
		 	{Carry_Bit_Last,Output} = In_1 + In_2 ;
		 	{Carry_Bit_Second_Last,temp_sum} = In_1[14:0] + In_2[14:0] ;
		 end
		 else if(ALU_Control_Signal == 3'b001)
		 begin
		 	{Carry_Bit_Last,Output} = In_1 + (~In_2) + (1'b1);
		 	{Carry_Bit_Second_Last,temp_sum} = In_1[14:0] + (~In_2[14:0]) + (1'b1);
		 end
		 else if(ALU_Control_Signal == 3'b010)
		 begin
		 	{Carry_Bit_Last,Output} = In_1 & In_2 ;
		 	{Carry_Bit_Second_Last,temp_sum} = In_1[14:0] & In_2[14:0] ;
		 end
		 else if(ALU_Control_Signal == 3'b011)
		 begin
		 	{Carry_Bit_Last,Output} = In_1 | In_2 ;	
		 	{Carry_Bit_Second_Last,temp_sum} = In_1[14:0] | In_2[14:0] ;	
		 end	 
		 else if(ALU_Control_Signal == 3'b100)
		 begin
		 	{Carry_Bit_Last,Output} = ~In_1 ;
		 	{Carry_Bit_Second_Last,temp_sum} = ~(In_1[14:0]) ;
		 end
	 end
endmodule

/*Module for behavioral implementation for Memory Bank*/
module Memory_Bank ( input Memory_Reset, input [15:0] Mem_Addr, input [15:0] Write_Data, input Mem_Read, input Mem_Write, output [15:0] Read_Data );
	reg[15:0] Memory_Bank_Array [65535:0];
	reg[15:0] Read_Data;
	integer i;
	always @ (Memory_Reset, Mem_Read, Mem_Write)
		begin
		if(Memory_Reset) begin
				Memory_Bank_Array[0] <= 16'b0000011000101000;
		end
		if(Mem_Write) begin
				Memory_Bank_Array[Mem_Addr] <= Write_Data[15:0];
			end
		if(Mem_Read) begin
				Read_Data[15:0] <= Memory_Bank_Array[Mem_Addr];
			end
		end
endmodule
