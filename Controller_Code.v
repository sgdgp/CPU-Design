
//-------------------------------------------- Controller Module and Testbench ----------------------------------------------------------------------//


module controller(opcode_arr, mode_arr, state, ready, jump_instr_type_arr, clock, MemRead, MemWrite, MARWrite, MARRead, MARSrc, MDRSrc, MDRRead, MDRMemRead, WD_RegFileSrc, MDRWrite, IRWrite, IRRead, PCWrite, PCRead, RegFileRead, RegFileWrite, WD_RegFileSrc, ALUOutWrite, ALUOutRead, ALUOutRegRead, T_Read, T_Write, ALU_CS, Jump_Flag_Select, RegNumberSrc, const_0_Read, const_2_Read, Z_Write, C_Write, M_Write, O_Write);
    reg [3:0]opcode;
    input [3:0] opcode_arr [7:0];
    input [2:0] mode_arr[7:0];
    reg [2:0]mode;
    input clock, ready;
    output [6:0]state;
    input [2:0]jump_instr_type_arr[7:0];
    reg [2:0]jump_instr_type;

    output MemRead, MemWrite, MARRead, MARWrite, MDRWrite, MDRSrc, MDRRead, MDRMemRead, MARSrc, IRWrite, IRRead, PCWrite, PCRead, RegFileRead, RegFileWrite, WD_RegFileSrc, ALUOutRead, ALUOutWrite, ALUOutRegRead, T_Read, T_Write,  const_2_Read,  const_0_Read, Z_Write, C_Write, M_Write, O_Write;
    
    reg MemRead, MemWrite, MARRead, MARWrite, MDRWrite, MDRSrc, MDRRead, MDRMemRead, MARSrc, IRWrite, IRRead, PCWrite, PCRead, RegFileRead, RegFileWrite, WD_RegFileSrc, ALUOutRead, ALUOutWrite, ALUOutRegRead, T_Read, T_Write,  const_2_Read,  const_0_Read, Z_Write, C_Write, M_Write, O_Write;
    
    output [1:0]RegNumberSrc;
    reg [1:0]RegNumberSrc;

    output [2:0]ALU_CS;
    reg [2:0]ALU_CS;

    output [1:0]Jump_Flag_Select;
    reg [1:0]Jump_Flag_Select;

    reg [3:0]i;
    reg [3:0]lim;
    reg [6:0] reset;

    reg [6:0] state, next_state;
    initial begin
        state = 7'b1011101;
    //$monitor($time, "\tCurrent state = %b\n", state);
        //ready = 0;
        reset = 1;  
        i = 4'd0;
        lim = 4'd8;
    end

    //state declarations
    parameter scomm1 = 7'b0000000 , scomm2 = 7'b0000001, scomm_mem = 7'b0000010, simm_comm = 7'b0000011, simm_load_imm = 7'b0000100,
        simm_add_imm = 7'b0000101, simm_sub_imm = 7'b0000110, simm_and_imm = 7'b0000111, simm_or_imm = 7'b0001000, simm_mem = 7'b0001001
        , simm_comm2 = 7'b0001011,  scomm3 = 7'b0001100, simm_comm1 = 7'b0001101, simm_load2 = 7'b0001110, simm_comm1_mem = 7'b0001111,
        dummy_state_register_mode = 7'b0010000, load_reg_mode1 = 7'b0010001, load_reg_mode2 = 7'b0010010, RType_reg_mode1 = 7'b0010011, add_reg_mode1 = 7'b0010100,
        sub_reg_mode1 = 7'b0010101, and_reg_mode1 = 7'b0010110, or_reg_mode1 = 7'b0010111, cmp_reg_mode1 = 7'b0011000, base_indexed_comm1 = 7'b0011001,
        base_indexed_comm2 = 7'b0011010, base_indexed_comm3 = 7'b0011011, base_indexed_comm4 = 7'b0011100, base_indexed_comm5 = 7'b0011101, 
        base_indexed_comm6 = 7'b0011110, base_indexed_comm7 = 7'b0011111, load_base_indexed1 = 7'b0100000, load_base_indexed_mem1 = 7'b0100001,
        load_base_indexed2 = 7'b0100010, R_Type_base_indexed1 = 7'b0100011, R_Type_base_indexed_mem = 7'b0100100, add_base_indexed = 7'b0100101,
        sub_base_indexed = 7'b0100110, and_base_indexed = 7'b0100111, or_base_indexed = 7'b0101000, base_addressing_comm1 = 7'b0101001, 
        base_addressing_comm2 = 7'b0101010, base_addressing_comm3 = 7'b0101011, base_addressing_comm4 = 7'b0101100, base_addressing_comm5 = 7'b0101101,
        base_addressing_comm6 = 7'b0101110, base_addressing_comm7 = 7'b0101111, base_addressing_comm8 = 7'b0110000, indirect_comm1 = 7'b0110001,
        indirect_comm2 = 7'b0110010, indirect_comm3 = 7'b0110011, indirect_comm4 = 7'b0110100, indirect_comm5 = 7'b0110101, indirect_comm6 = 7'b0110110,
        indirect_comm7 = 7'b0110111, indirect_comm8 = 7'b0111000, indirect_comm9 = 7'b0111001, indirect_comm10 = 7'b0111010,
        indirect_load1 = 7'b0111011, indirect_load2 = 7'b0111100,indirect_load3 = 7'b0111101,indirect_store1 = 7'b0111110,indirect_store2 = 7'b0111111, indirect_store3 = 7'b1000000,
        indirect_store4 = 7'b1000001, indirect_R_Type = 7'b1000010, indirect_R_Type_mem = 7'b1000011, indirect_add = 7'b1000100, indirect_sub = 7'b1000101, 
        indirect_and = 7'b1000110, indirect_or = 7'b1000111, pc_rel_dummy = 7'b1001000, j_instr1 = 7'b1001001, j_instr2 = 7'b1001010, j_instr3 = 7'b1001011,
        j_instr4 = 7'b1001100, cond_jump1 = 7'b1001101, cond_jump2 = 7'b1001110, jm_1 = 7'b1001111, jz_1 = 7'b1010000, jv_1 = 7'b1010001, jc_1 = 7'b1010010,
        cond_comm = 7'b1010011, jr_1 = 7'b1010100, jal_1 = 7'b1010101, jal_mem = 7'b1010110, jal_2 = 7'b1010111, jal_3 = 7'b1011000, jal_4 = 7'b1011001, 
        jal_5 = 7'b1011010, jal_6 = 7'b1011011, scomm0 = 7'b1011100, scomm_start = 7'b1011101;

    always @ (posedge clock) begin
        
        
        MemRead <= 1'b0;
        MemWrite <= 1'b0;
        MARRead <= 1'b0;
        MARWrite <= 1'b0;
        MARSrc <= 1'b0;
        MDRRead <= 1'b0;
        MDRWrite <= 1'b0;
        MDRSrc <= 1'b0;
        MDRMemRead <= 1'b0;
        IRWrite <= 1'b0;
        IRRead <= 1'b0;
        PCWrite <= 1'b0;
        PCRead <= 1'b0;
        RegFileWrite <= 1'b0;
        WD_RegFileSrc <= 1'b0;
        ALUOutRead <= 1'b0;
        ALUOutWrite <= 1'b0;
        ALUOutRegRead <= 1'b0;
        T_Read <= 1'b0;
        T_Write <= 1'b0;
        const_2_Read <= 1'b0;
        const_0_Read <= 1'b0;
        Z_Write <= 1'b0;
        C_Write <= 1'b0;
        M_Write <= 1'b0;
        O_Write <= 1'b0;

        if (state == scomm1) begin
            if(lim == i) begin
                    $finish;
            end
            if(opcode == 4'b1100) begin
                   state = jal_1;
            end
            else begin
                $display("\t------------------------New Instruction-------------------------\n");
                $display("\tInstruction No. = %d\n", i + 1); 
                $display("\tStart State = 0000000");
                $monitor("\tMemRead = %b\n\tMemWrite = %b\n\tMARRead = %b\n\tMARSrc = %b\n\tMARWrite = %b\n\tMDRWrite = %b\n\tMDRSrc = %b\n\tMDRMemRead = %b\n\tMDRRead = %b\n\tIRWrite = %b\n\tPCWrite = %b\n\tPCRead= %b\n\tRegFileWrite = %b\n\tWD_RegFileSrc = %b\n\tALUOutRead = %b\n\tALUOutWrite = %b\n\tALUOutRegRead = %b\n\tT_Read = %b\n\tT_Write = %b\n\tconst_2_Read = %b\n\tconst_0_Read = %b\n\tZ_Write = %b\n\tC_Write = %b\n\tM_Write = %b\n\tO_Write = %b\n\n\tCurrent state = %b", MemRead, MemWrite, MARRead, MARSrc, MARWrite, MDRWrite, MDRSrc, MDRMemRead, MDRRead, IRWrite, PCWrite,
                         PCRead, RegFileWrite, WD_RegFileSrc, ALUOutRead, ALUOutWrite, ALUOutRegRead, T_Read, T_Write, const_2_Read, const_0_Read,
                         Z_Write, C_Write, M_Write, O_Write, state);
            end      
        end

        case(state) 
            scomm_start :
            begin
                if(reset) begin
                    state = scomm1;
                end
            end

            scomm1 :    //start of common states
            begin
                MARWrite <= 1'b1;
                T_Write <= 1'b1;
                MARSrc <= 1'b1;
                PCRead <= 1'b1;
                opcode <= opcode_arr[i];
                mode <= mode_arr[i];
                jump_instr_type <= jump_instr_type_arr[i];
                i = i + 1;
                state = scomm0;
                
            end

            scomm0 :
            begin
                if(opcode == 4'b1100) begin
                   state = jal_1;
                end else begin
                    state = scomm2;
                end
            end

            scomm2 :
            begin
                PCWrite <= 1'b1;
                MemRead <= 1'b1;
                MDRWrite <= 1'b1;
                MDRSrc <= 1'b1;
                ALU_CS <= 3'b000;
                Z_Write <= 1;
                C_Write <= 1;
                M_Write <= 1;
                O_Write <= 1;
                ALUOutRead <= 1;
                const_2_Read <= 1'b1;
                state = scomm_mem;
            end
            scomm_mem :     
            begin            //check this part
                if(ready) begin         //corrected
                    state = scomm_mem;
                end else
                    state =  scomm3;
            end
            scomm3 :        //branch on basis of addressing modes 
            begin
                IRWrite <= 1'b1;
                MDRRead <= 1'b1;
                if(opcode == 4'b1110) begin
                    state = jr_1;
                end else if(mode == 3'b001) begin
                    state = simm_comm;
                end else if(mode == 3'b000) begin
                    state = dummy_state_register_mode;
                end else if(mode == 3'b010) begin
                    state = base_indexed_comm1;
                end else if(mode == 3'b011) begin
                    state = base_addressing_comm1;
                end else if(mode == 3'b100) begin
                    state = indirect_comm1;
                end else if(mode == 3'b101) begin
                    state = pc_rel_dummy;
                end 
                //add more modes here   //done
            end

            //immediate mode
            simm_comm :   
            begin      
                T_Write <= 1;
                MARWrite <= 1;
                MARSrc <= 1;
                PCRead <= 1;
                if(opcode == 4'b1000 && mode == 3'b001) begin
                    state = simm_load_imm;
                end else if(mode == 3'b001) begin
                    state = simm_comm;
                end
            end

            simm_load_imm : 
            begin
                MemRead <= 1'b1;
                PCWrite <= 1'b1;
                ALU_CS <= 3'b000;
                Z_Write <= 1;
                C_Write <= 1;
                M_Write <= 1;
                O_Write <= 1;
                ALUOutRead <= 1;
                MDRWrite <= 1;
                MDRSrc <= 1;
                const_2_Read <= 1;
                state = simm_mem;
            end

            simm_mem : 
            begin
                if(!ready) begin
                    state = simm_load2;
                end else begin
                    state = simm_mem;
                end
            end

            simm_load2 :
            begin
                RegNumberSrc <= 2'b00;
                RegFileWrite <= 1;
                WD_RegFileSrc <= 1;
                state = scomm1;
            end

            simm_comm1:
            begin
                MDRWrite <= 1'b1;
                MDRSrc <= 1;
                MemRead <= 1'b1;
                PCWrite <= 1'b1;
                ALU_CS <= 3'b000;
                Z_Write <= 1;
                C_Write <= 1;
                M_Write <= 1;
                O_Write <= 1;
                ALUOutRead <= 1;
                state = simm_comm1_mem;
            end

            simm_comm1_mem :
            begin
                if(ready) begin
                    state = simm_comm1_mem;
                end else
                    state = simm_comm2;
            end

            simm_comm2 :
            begin
                T_Write <= 1'b1;
                RegNumberSrc <= 2'b00;
                RegFileRead <= 1'b1;
                if(opcode == 4'b0000) begin
                        state = simm_add_imm;
                    end else if(opcode == 4'b0001) begin
                        state = simm_sub_imm;
                    end else if(opcode == 4'b0010) begin
                        state = simm_and_imm;
                    end else if (opcode == 4'b0011) begin
                        state = simm_or_imm;
                    end
            end
            simm_add_imm :
            begin
                WD_RegFileSrc = 1'b1;
                ALU_CS = 3'b000;
                Z_Write <= 1;
                C_Write <= 1;
                M_Write <= 1;
                O_Write <= 1;
                ALUOutRead <= 1;
                RegFileWrite = 1'b1;
                RegNumberSrc <= 2'b00;
                state = scomm1;
                //$finish;
            end
            simm_sub_imm :
            begin
                WD_RegFileSrc = 1'b1;
                ALU_CS = 3'b001;
                Z_Write <= 1;
                C_Write <= 1;
                M_Write <= 1;
                O_Write <= 1;
                ALUOutRead <= 1;
                RegFileWrite = 1'b1;
                RegNumberSrc <= 2'b00;
                state = scomm1;
                //$finish;
            end
            simm_and_imm :
            begin
                WD_RegFileSrc = 1'b1;
                ALU_CS = 3'b010;
                Z_Write <= 1;
                C_Write <= 1;
                M_Write <= 1;
                O_Write <= 1;
                ALUOutRead <= 1;
                RegFileWrite = 1'b1;
                RegNumberSrc <= 2'b00;
                state = scomm1;
                //$finish;
            end
            simm_or_imm :
            begin
                WD_RegFileSrc = 1'b1;
                ALU_CS = 3'b011;
                Z_Write <= 1;
                C_Write <= 1;
                M_Write <= 1;
                O_Write <= 1;
                ALUOutRead <= 1;
                RegFileWrite = 1'b1;
                RegNumberSrc <= 2'b00;
                state = scomm1;
                //$finish;
            end
            //register mode
            dummy_state_register_mode :
            begin
                if(opcode == 4'b1000) begin
                    state = load_reg_mode1;
                end else if (opcode[0] == 1)begin
                    state = RType_reg_mode1;
                end
            end
            load_reg_mode1 : 
            begin
                RegFileRead <= 1;
                T_Write <= 1;
                RegNumberSrc <= 00;
                state = load_reg_mode2;
            end
            load_reg_mode2 :
            begin
                ALU_CS <= 3'b000;
                Z_Write <= 1;
                C_Write <= 1;
                M_Write <= 1;
                O_Write <= 1;
                ALUOutRead <= 1;
                WD_RegFileSrc <= 1;
                RegFileWrite <= 1;
                RegNumberSrc <= 2'b01;
                state = scomm1;
                //$finish;
            end
            RType_reg_mode1 :
            begin
                T_Write = 1;
                RegFileRead = 1;
                if(opcode == 4'b0000) begin
                    state = add_reg_mode1;
                end else if(opcode == 4'b0001) begin
                    state = sub_reg_mode1;
                end else if (opcode == 4'b0010) begin
                    state = and_reg_mode1;
                end else if(opcode == 4'b0011) begin
                    state = or_reg_mode1;
                end else if(opcode == 4'b0100) begin
                    state = cmp_reg_mode1;
                end
            end
            add_reg_mode1 : 
            begin
                RegFileWrite <= 1;
                WD_RegFileSrc <= 1;
                RegNumberSrc <= 2'b00;
                ALU_CS <= 3'b000;
                Z_Write <= 1;
                C_Write <= 1;
                M_Write <= 1;
                O_Write <= 1;
                ALUOutRead <= 1;
                state = scomm1;
                //$finish;
            end
            sub_reg_mode1 : 
            begin
                RegFileWrite <= 1;
                WD_RegFileSrc <= 1;
                RegNumberSrc <= 00;
                ALU_CS <= 3'b001;
                Z_Write <= 1;
                C_Write <= 1;
                M_Write <= 1;
                O_Write <= 1;
                ALUOutRead <= 1;
                state = scomm1;
                //$finish;
            end

            add_reg_mode1 : 
            begin
                RegFileWrite <= 1;
                WD_RegFileSrc <= 1;
                RegNumberSrc <= 2'b00;
                ALU_CS <= 3'b010;
                Z_Write <= 1;
                C_Write <= 1;
                M_Write <= 1;
                O_Write <= 1;
                ALUOutRead <= 1;
                state = scomm1;
                //$finish;
            end
            or_reg_mode1 : 
            begin
                RegFileWrite <= 1;
                WD_RegFileSrc <= 1;
                RegNumberSrc <= 2'b00;
                ALU_CS <= 3'b011;
                Z_Write <= 1;
                C_Write <= 1;
                M_Write <= 1;
                O_Write <= 1;
                ALUOutRead <= 1;
                state = scomm1;
                //$finish;
            end
            cmp_reg_mode1 :
            begin
                RegFileWrite <= 1;
                WD_RegFileSrc <= 1;
                RegNumberSrc <= 2'b01;
                ALU_CS <= 3'b100;
                Z_Write <= 1;
                C_Write <= 1;
                M_Write <= 1;
                O_Write <= 1;
                ALUOutRead <= 1;
                state = scomm1;
                //$finish;
            end

            //base-indexed mode
            base_indexed_comm1 :
            begin
                T_Write <= 1;
                RegFileRead <= 1;
                RegNumberSrc <= 2'b00;
                state = base_indexed_comm2;
            end
            base_indexed_comm2 :
            begin
                ALUOutWrite <= 1;
                ALU_CS <= 3'b000;
                Z_Write <= 1;
                C_Write <= 1;
                M_Write <= 1;
                O_Write <= 1;
                ALUOutRead <= 1;
                RegFileRead <= 01;
                state <= base_indexed_comm3;
            end
            base_indexed_comm3 :
            begin
                MARWrite <= 1;
                MARSrc <= 1;
                T_Write <= 1;
                PCRead <= 1;    
                state = base_indexed_comm4;
            end
            base_indexed_comm4:
            begin
                PCWrite <= 1;
                MemRead <= 1;
                MDRWrite <= 1;
                MDRSrc <= 1;
                ALU_CS <= 3'b000;
                Z_Write <= 1;
                C_Write <= 1;
                M_Write <= 1;
                O_Write <= 1;
                ALUOutRead <= 1;
                const_2_Read <= 1;
                state = base_indexed_comm5;
            end
            base_indexed_comm5 :
            begin
                if(ready) begin
                    state = base_indexed_comm5;
                end else begin
                    state = base_indexed_comm6;
                end
            end
            base_indexed_comm6 :
            begin
                RegFileRead <= 1;
                RegNumberSrc <= 10;
                state = base_indexed_comm7;
            end
            base_indexed_comm7 :
            begin
                MDRRead <= 1;
                MARWrite <= 1;
                MARSrc <= 0;
                ALU_CS <= 3'b000;
                Z_Write <= 1;
                C_Write <= 1;
                M_Write <= 1;
                O_Write <= 1;
                ALUOutRead <= 1;
                if(opcode[0] == 1) begin
                    state = load_base_indexed1;
                end else begin
                    state = R_Type_base_indexed1;
                end
            end
            load_base_indexed1 : 
            begin
                MemRead <= 1;
                MDRWrite <= 1;
                MDRSrc <= 1;
                state = load_base_indexed_mem1;
            end
            load_base_indexed_mem1 :
            begin
                if(ready) begin
                    state = load_base_indexed_mem1;
                end else begin
                    state = load_base_indexed2;
                end
            end
            load_base_indexed2 :
            begin
                WD_RegFileSrc <= 0;
                MDRRead <= 1;
                RegFileWrite <= 1;
                RegNumberSrc <= 2'b00;
                state = scomm1;
                //$finish;
            end
            R_Type_base_indexed1 :
            begin
                MDRWrite <= 1;
                MemRead <= 1;
                T_Write <= 1;
                RegFileRead <= 1;
                RegNumberSrc <= 2'b00;
                state = R_Type_base_indexed_mem;
            end
            R_Type_base_indexed_mem :
            begin
                if(ready) begin
                    state = R_Type_base_indexed_mem;
                end else begin
                    if(opcode == 4'b0000) begin
                        state = add_base_indexed;
                    end else if (opcode == 4'b0001) begin
                        state = sub_base_indexed;
                    end else if(opcode == 4'b0010) begin
                        state = and_base_indexed;
                    end else if(opcode == 4'b0011) begin
                        state = or_base_indexed;
                    end
                end    
            end
            add_base_indexed :
            begin
                ALU_CS <= 3'b000;
                Z_Write <= 1;
                C_Write <= 1;
                M_Write <= 1;
                O_Write <= 1;
                ALUOutRead <= 1;
                WD_RegFileSrc <= 1;
                RegFileWrite <= 1;
                RegNumberSrc <= 00;
                state = scomm1;
                //$finish;
            end
            sub_base_indexed :
            begin
                ALU_CS <= 3'b001;
                Z_Write <= 1;
                C_Write <= 1;
                M_Write <= 1;
                O_Write <= 1;
                ALUOutRead <= 1;
                WD_RegFileSrc <= 1;
                RegFileWrite <= 1;
                RegNumberSrc <= 00;
                state = scomm1;
                //$finish;
            end
            and_base_indexed :
            begin
                ALU_CS <= 3'b010;
                Z_Write <= 1;
                C_Write <= 1;
                M_Write <= 1;
                O_Write <= 1;
                ALUOutRead <= 1;
                WD_RegFileSrc <= 1;
                RegFileWrite <= 1;
                RegNumberSrc <= 00;
                state = scomm1;
                //$finish;
            end
            or_base_indexed :
            begin
                ALU_CS <= 3'b011;
                Z_Write <= 1;
                C_Write <= 1;
                M_Write <= 1;
                O_Write <= 1;
                ALUOutRead <= 1;
                WD_RegFileSrc <= 1;
                RegFileWrite <= 1;
                RegNumberSrc <= 00;
                state = scomm1;
                //$finish;
            end

            //base addressing mode
            base_addressing_comm1 :
            begin
                T_Write <= 1;
                RegFileRead <= 1;
                RegNumberSrc <= 2'b00;
                state = base_addressing_comm2;
            end
            base_addressing_comm2 :
            begin
                MARWrite <= 1;
                PCRead <= 1;
                MARSrc <= 1;
                state = base_addressing_comm3;
            end
            base_addressing_comm3 :
            begin
                MDRWrite <= 1;
                PCWrite <= 1 ;
                MDRSrc <= 0;
                MemWrite <= 1;
                ALU_CS = 3'b000;
                Z_Write <= 1;
                C_Write <= 1;
                M_Write <= 1;
                O_Write <= 1;
                ALUOutRead <= 1;
                const_2_Read = 1;
                state = base_addressing_comm4;
            end
            base_addressing_comm4 :
            begin
                if(ready) begin
                    state = base_addressing_comm4;
                end else begin
                    state = base_addressing_comm5;
                end
            end
            base_addressing_comm5 :
            begin
                MDRRead <= 1;
                ALU_CS <= 3'b000;
                Z_Write <= 1;
                C_Write <= 1;
                M_Write <= 1;
                O_Write <= 1;
                ALUOutRead <= 1;
                MARWrite <= 1;
                MARSrc <= 0;
                state = base_addressing_comm6;
            end
            base_addressing_comm6 :
            begin
                RegFileRead <= 1;
                RegNumberSrc <= 01;
                MDRWrite <= 1;
                state = base_addressing_comm7;
            end
            base_addressing_comm7 : //check this
            begin
                MemWrite <= 1;
                MDRMemRead <= 1;
                state = base_addressing_comm8;
            end
            base_addressing_comm8 :
            begin
                if(ready) begin
                    state = base_addressing_comm8;
                end else begin 
                    state = scomm1;
                    //$finish;
                end
            end

            //indirect mode
            indirect_comm1 :
            begin
                T_Write <= 1;
                RegFileRead <= 1;
                RegNumberSrc <= 2'b01;
                state = indirect_comm2;
            end
            indirect_comm2 :
            begin
                RegFileRead <= 1;
                RegNumberSrc <= 2'b10;
                ALU_CS = 3'b000;
                Z_Write <= 1;
                C_Write <= 1;
                M_Write <= 1;
                O_Write <= 1;
                ALUOutRead <= 1;
                ALUOutWrite <= 1;
                state = indirect_comm3;
            end
            indirect_comm3 :
            begin
                PCRead <= 1;
                MARWrite <= 1;
                MARSrc <= 1;
                T_Write <= 1;
                state = indirect_comm4;
            end
            indirect_comm4 :
            begin
                MemRead <= 1;
                MDRWrite <= 1;
                MDRSrc <= 1;
                PCWrite <= 1;
                ALU_CS = 3'b000;
                Z_Write <= 1;
                C_Write <= 1;
                M_Write <= 1;
                O_Write <= 1;
                ALUOutRead <= 1;
                const_2_Read <= 1;
                state = indirect_comm5;
            end
            indirect_comm5 :
            begin
                if(ready) begin
                    state = indirect_comm5;
                end else begin 
                    state = indirect_comm6;
                end
            end
            indirect_comm6 :
            begin
                ALUOutRegRead <= 1;
                T_Write <= 1;
                state =indirect_comm7;
            end
            indirect_comm7 :
            begin
                MARWrite <= 1;
                MARSrc <= 0;
                MDRRead <= 1;
                ALU_CS <= 3'b000;
                Z_Write <= 1;
                C_Write <= 1;
                M_Write <= 1;
                O_Write <= 1;
                ALUOutRead <= 1;
                state = indirect_comm8;
            end
            indirect_comm8 :
            begin
                MemRead <= 1;
                MDRWrite <= 1;
                MDRSrc <= 0;
                MARRead <= 1;
                state = indirect_comm9;
            end
            indirect_comm9 :
            begin
                if(ready) begin 
                    state = indirect_comm9;
                end else begin
                    state = indirect_comm10;
                end
            end
            indirect_comm10 :
            begin
                MDRRead <= 1;
                MARWrite <= 1;
                MARSrc <= 1;
                if(opcode == 4'b1000) begin
                    state = indirect_load1;
                end else if(opcode == 4'b1001) begin
                    state = indirect_store1;
                end else if(opcode[0] == 0) begin
                    state = indirect_R_Type;
                end
            end
            indirect_load1 :
            begin
                MemRead <= 1;
                MDRWrite <= 1;
                MDRSrc <= 0;
                state = indirect_load2;
            end
            indirect_load2 :
            begin
                if(ready) begin
                    state = indirect_load2;
                end else begin
                    state = indirect_load3;
                end
            end
            indirect_load3 :
            begin
                MDRRead <= 1;
                RegFileWrite <= 1;
                RegNumberSrc <= 2'b00;
                WD_RegFileSrc <= 0;
                state = scomm1;
                //$finish;
            end
            indirect_store1 :
            begin
                RegFileRead <= 1;
                T_Write <= 1;
                RegNumberSrc <= 2'b00;
                state = indirect_store2;
            end
            indirect_store2 :
            begin
                ALU_CS <= 3'b000;
                Z_Write <= 1;
                C_Write <= 1;
                M_Write <= 1;
                O_Write <= 1;
                ALUOutRead <= 1;
                const_0_Read <= 1;
                MDRWrite <= 1;
                MDRSrc <= 1;
                state = indirect_store3;
            end
            indirect_store3 :
            begin
                MemWrite <= 1;
                MDRMemRead <= 1;
                state = indirect_store4;
            end
            indirect_store4 :
            begin
                if(ready) begin
                    state = indirect_store4;
                end else begin
                    state = scomm1;
                    //$finish;
                end
            end
            indirect_R_Type :
            begin
                MemRead <= 1;
                MDRWrite <= 1;
                MDRSrc <= 0;
                T_Write <= 1;
                RegFileRead <= 1;
                RegNumberSrc <= 2'b00;
                state = indirect_R_Type_mem;
            end
            indirect_R_Type_mem :
            begin
                if(ready) begin
                    state = indirect_R_Type_mem;
                end else if(opcode == 4'b000) begin
                    state = indirect_add;
                end else if(opcode == 4'b001) begin
                    state = indirect_sub;
                end else if(opcode == 4'b010) begin
                    state = indirect_and;
                end else if(opcode == 4'b011) begin
                    state = indirect_or;
                end
            end
            indirect_add :
            begin
                MDRRead <= 1;
                ALU_CS <= 3'b000;
                Z_Write <= 1;
                C_Write <= 1;
                M_Write <= 1;
                O_Write <= 1;
                ALUOutRead <= 1;
                WD_RegFileSrc <= 1;
                RegFileWrite <= 1;
                RegNumberSrc <= 2'b00;
                state = scomm1;
                //$finish;
            end
            indirect_sub :
            begin
                MDRRead <= 1;
                ALU_CS <= 3'b001;
                Z_Write <= 1;
                C_Write <= 1;
                M_Write <= 1;
                O_Write <= 1;
                ALUOutRead <= 1;
                WD_RegFileSrc <= 1;
                RegFileWrite <= 1;
                RegNumberSrc <= 2'b00;
                state = scomm1;
                //$finish;
            end
            indirect_and :
            begin
                MDRRead <= 1;
                ALU_CS <= 3'b010;
                Z_Write <= 1;
                C_Write <= 1;
                M_Write <= 1;
                O_Write <= 1;
                ALUOutRead <= 1;
                WD_RegFileSrc <= 1;
                RegFileWrite <= 1;
                RegNumberSrc <= 2'b00;
                state = scomm1;
                //$finish;
            end
            indirect_or :
            begin
                MDRRead <= 1;
                ALU_CS <= 3'b011;
                Z_Write <= 1;
                C_Write <= 1;
                M_Write <= 1;
                O_Write <= 1;
                ALUOutRead <= 1;
                WD_RegFileSrc <= 1;
                RegFileWrite <= 1;
                RegNumberSrc <= 2'b00;
                state = scomm1;
                //$finish;
            end

            //pc relative mode
            pc_rel_dummy :
            begin
                if(opcode == 4'b1010 && jump_instr_type == 3'b000) begin
                    state = j_instr1;
                end else if(opcode == 4'b1010) begin
                    state = cond_jump1;
                end
            end
            j_instr1 :
            begin
                MARWrite <= 1;
                MARSrc <= 1;
                T_Write <= 1;
                PCRead <= 1;
                state = j_instr2;
            end
            j_instr2 :
            begin
                MDRWrite <= 1;
                MDRSrc <= 0;
                MemRead <= 1;
                PCWrite <= 1;
                ALU_CS <= 3'b000;
                ALUOutRead <= 1;
                const_2_Read <= 1;
                state = j_instr3;
            end
            j_instr3 :
            begin
                if(ready) begin
                    state = j_instr3;
                end else begin
                    state = j_instr4;
                end
            end
            j_instr4 :
            begin
                MDRRead <= 1;
                ALU_CS <= 3'b000;
                ALUOutRead <= 1;
                PCWrite <= 1;
                state = scomm1;
                //$finish;
            end
            cond_jump1 :
            begin
                MARWrite <= 1;
                MARSrc <= 1;
                T_Write <= 1;
                PCRead <= 1;
                state = cond_jump2;
            end
            cond_jump2 :
            begin
                MDRWrite <= 1;
                MDRSrc <= 0;
                MemRead <= 1;
                PCWrite <= 1;
                ALU_CS = 3'b000;
                ALUOutRead <= 1;
                const_2_Read <= 1;
                if(jump_instr_type == 3'b100) begin
                    state = jm_1;
                end else if(jump_instr_type == 3'b001) begin
                    state = jz_1;
                end else if(jump_instr_type == 3'b011) begin
                    state = jv_1;
                end else if(jump_instr_type == 3'b010) begin
                    state = jc_1;
                end
            end
            jm_1 :
            begin
                Jump_Flag_Select <= 2'b00;
                T_Write <= 1;
                PCRead <= 1;
                state = cond_comm;
            end
            jz_1 :
            begin
                Jump_Flag_Select <= 2'b01;
                T_Write <= 1;
                PCRead <= 1;
                state = cond_comm;
            end
            jv_1 :
            begin
                Jump_Flag_Select <= 2'b10;
                T_Write <= 1;
                PCRead <= 1;
                state = cond_comm;
            end
            jc_1 :
            begin
                Jump_Flag_Select <= 2'b11;
                T_Write <= 1;
                PCRead <= 1;
                state = cond_comm;
            end
            cond_comm :
            begin
                MDRRead <= 1;
                ALU_CS = 3'b000;
                ALUOutRead <= 1;
                PCWrite <= 1;
                state = scomm1;
                //$finish;
            end

            //special jr states
            jr_1 :
            begin
                PCWrite <= 1;
                RegFileRead <= 1;
                RegNumberSrc <= 2'b00;
                state = scomm1;
                //$finish;
            end

            //special jal states
            jal_1:
            begin
                PCWrite <= 1;
                MemRead <= 1;
                MDRWrite <= 1;
                MDRSrc <=1;
                IRWrite <= 1;
                ALU_CS <= 3'b000;
                ALUOutRead <= 1;
                const_2_Read <= 1;
                ALUOutWrite <= 1;
                state = jal_mem;
            end
            jal_mem :
            begin
                if(ready) begin
                    state = jal_mem;
                end else begin
                    state = jal_2;
                end
            end
            jal_2 :
            begin
                WD_RegFileSrc <= 0;
                ALUOutRegRead <= 1;
                state = jal_3;
            end
            jal_3 :
            begin
                MARWrite <= 1;
                MARSrc <= 1;
                T_Write <= 1;
                PCRead <= 1;
                state = jal_4;
            end
            jal_4 :
            begin
                MDRWrite <= 1;
                MemRead <= 1;
                MDRSrc <= 0;
                PCWrite <= 1;
                const_2_Read <= 1;
                state = jal_5;
            end
            jal_5 :
            begin
                if(ready) begin
                    state = jal_5;
                end else begin
                    state = jal_6;
                end
            end
            jal_6 :
            begin
                ALUOutWrite <= 1;
                MDRRead <= 1;
                PCWrite <= 1;
                state = scomm1;
                //$finish;
            end
        endcase
    end
endmodule
