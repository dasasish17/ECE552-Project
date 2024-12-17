`default_nettype none

module control (Opcode, Func, err, Halt,
                zeroExt, ImmSrc, ALU_jump, RegWrite, memReadorWrite, memRead, memWrite, 
                InvA, InvB, Cin, Beq, Bne, Blt, Bgt,
                RegDst, MemtoReg, ALUSrc1, ALUSrc2, ALU_op);

    // inputs
    input wire [4:0] Opcode;
    input wire [1:0] Func;

    // error
    output reg err;

    // mux select inputs
    output reg zeroExt;         // 0 = signext,               1 = 0ext
    output reg ImmSrc;          // 0 = 8b extended for jump,  1 = 11b for jump
    output reg ALU_jump;        // 1 = jr, jalr               0 otherwise

    output reg [1:0] RegDst;    // 00 = instr[7:5]     01 = instr[10:8]    10 = instr[4:2]     11 = R7
    output reg [1:0] MemtoReg;  // 00 = PC+2           01 = Mem            10 = ALU value
    output reg [1:0] ALUSrc1;   // 00 = Read Data 1    01 = 16'b0          10 = Read Data << 3
    output reg [1:0] ALUSrc2;   // 00 = Read Data 2    01 = imm5 extend    10 = imm8 extend    11 = 16'b0
    output reg [3:0] ALU_op;

    // Read/write
    output reg RegWrite;
    output reg memReadorWrite;
    output reg memRead;
    output reg memWrite;
    //output reg potRAW_R;
    //output reg potRAW_I;

    // Add/subtract
    output reg InvA;
    output reg InvB;
    output reg Cin;

    // Branch Condition Signals
    output reg Beq;
    output reg Bne;
    output reg Blt;
    output reg Bgt;

    output reg Halt;

    reg potRAW_R, potRAW_I;

    // Combinational logic block
    always @(*) begin
        // Default values for control signals

        RegDst = 2'b00;
        MemtoReg = 2'b10; //ALU as default
        ALUSrc1 = 2'b00;
        ALUSrc2 = 2'b00;
        ALU_op = 4'b0000;

        zeroExt = 1'b0;
        ImmSrc = 1'b0;
        ALU_jump = 1'b0;

        RegWrite = 1'b1; //writing to register as default
        memReadorWrite = 1'b0;
        memWrite = 1'b0;
        memRead = 1'b0;
        potRAW_R = 1'b0;
        potRAW_I = 1'b0;

        err = 1'b0;
        Halt = 1'b0;

        InvA = 1'b0;
        InvB = 1'b0;
        Cin = 1'b0;

        Beq = 1'b0;
        Bne = 1'b0;
        Blt = 1'b0;
        Bgt = 1'b0;

        // casex statement based on Opcode and Func
        casex ({Opcode, Func})
            // 1. halt
            7'b00000_xx: begin
                Halt = 1'b1;
                RegWrite = 1'b0;
            end
            
            // 2. nop (No operation, do nothing)
            7'b00001_xx: begin
                // not writing to register
                RegWrite = 1'b0;
            end 
            
            // 3. addi
            7'b01000_xx: begin
                ALUSrc2 = 2'b01;
                ALU_op = 4'b0100;
                potRAW_I = 1'b1;
            end
            
            // 4. subi
            7'b01001_xx: begin
                ALUSrc2 = 2'b01;
                ALU_op = 4'b0100;
                InvA = 1'b1;
                Cin = 1'b1;
                potRAW_I = 1'b1;
            end
            
            // 5. xori
            7'b01010_xx: begin
                ALUSrc2 = 2'b01;
                zeroExt = 1'b1;
                ALU_op = 4'b0111;
                potRAW_I = 1'b1;
            end
            
            // 6. andni
            7'b01011_xx: begin
                ALUSrc2 = 2'b01;
                ALU_op = 4'b0101;
                zeroExt = 1'b1;
                InvB = 1'b1;
                potRAW_I = 1'b1;
            end
            
            // 7. roli
            7'b10100_xx: begin
                ALUSrc2 = 2'b01;
                ALU_op = 4'b0000;
                zeroExt = 1'b1;
                potRAW_I = 1'b1;
            end
            
            // 8. slli
            7'b10101_xx: begin
                ALUSrc2 = 2'b01;
                ALU_op = 4'b0001;
                zeroExt = 1'b1;
                potRAW_I = 1'b1;
            end
            
            // 9. rori
            7'b10110_xx: begin
                ALUSrc2 = 2'b01;
                ALU_op = 4'b0010;
                zeroExt = 1'b1;
                potRAW_I = 1'b1;
            end
            
            // 10. srli
            7'b10111_xx: begin
                ALUSrc2 = 2'b01;
                ALU_op = 4'b0011;
                zeroExt = 1'b1;
                potRAW_I = 1'b1;
            end
            
            // 11. st (store)
            7'b10000_xx: begin
                ALUSrc2 = 2'b01;
                ALU_op = 4'b0100;
                RegWrite = 1'b0;
                memReadorWrite = 1'b1;//no longer using it
                memWrite = 1'b1;
                RegDst = 2'b00;
                potRAW_R = 1'b1;
            end
            
            // 12. ld (load)
            7'b10001_xx: begin
                ALUSrc2 = 2'b01;
                MemtoReg = 2'b01;
                ALU_op = 4'b0100;
                memReadorWrite = 1'b1;
                memRead = 1'b1;
                potRAW_I = 1'b1;
            end
            
            // 13. stu (store with update)
            7'b10011_xx: begin
                RegDst = 2'b01;
                ALUSrc2 = 2'b01;
                ALU_op = 4'b0100;
                memReadorWrite = 1'b1;
                memWrite = 1'b1;
                potRAW_R = 1'b1;
            end
            
            // 14. btr (bit reverse)
            7'b11001_xx: begin
                RegDst = 2'b10;
                ALU_op = 4'b1111;
                potRAW_R = 1'b1;
            end
            // (Add other instructions as needed)
            // 15. add
            7'b11011_00: begin
                RegDst = 2'b10;
                ALU_op = 4'b0100;
                potRAW_R = 1'b1;
            end

            // 16. sub
            7'b11011_01: begin
                RegDst = 2'b10;
                ALU_op = 4'b0100;
                Cin = 1'b1;
                InvA = 1'b1;
                potRAW_R = 1'b1;
            end

            // 17. xor
            7'b11011_10: begin
                RegDst = 2'b10;
                ALU_op = 4'b0111;
                potRAW_R = 1'b1;
            end

            // 18. andn
            7'b11011_11: begin
                RegDst = 2'b10;
                ALU_op = 4'b0101;
                InvB = 1'b1;
                potRAW_R = 1'b1;
            end

            // 19. rol
            7'b11010_00: begin
                RegDst = 2'b10;
                ALU_op = 4'b0000;
                potRAW_R = 1'b1;
            end

            // 20. sll
            7'b11010_01: begin
                RegDst = 2'b10;
                ALU_op = 4'b0001;
                potRAW_R = 1'b1;
            end

            // 22. ror
            7'b11010_10: begin
                RegDst = 2'b10;
                ALU_op = 4'b0010;
                potRAW_R = 1'b1;
            end

            // 23. srl
            7'b11010_11: begin
                RegDst = 2'b10;
                ALU_op = 4'b0011;
                potRAW_R = 1'b1;
            end

            // 24. seq
            7'b11100_xx: begin
                RegDst = 2'b10;
                ALU_op = 4'b1001;
                InvB = 1'b1;
                Cin = 1'b1;
                potRAW_R = 1'b1;
            end

            // 25. slt
            7'b11101_xx: begin
                RegDst = 2'b10;
                ALU_op = 4'b1010;
                InvB = 1'b1;
                Cin = 1'b1;
                potRAW_R = 1'b1;
            end

            // 26. sle
            7'b11110_xx: begin
                RegDst = 2'b10;
                ALU_op = 4'b1100;
                InvB = 1'b1;
                Cin = 1'b1;
                potRAW_R = 1'b1;
            end

            // 27. sco
            7'b11111_xx: begin
                RegDst = 2'b10;
                ALU_op = 4'b1011;
                potRAW_R = 1'b1;
            end

            // 28. beqz
            7'b01100_xx: begin
                ALUSrc2 = 2'b11;
                ALU_op = 4'b0100;
                RegWrite = 1'b0;
                Beq = 1'b1;
                potRAW_I = 1'b1;
            end

            // 29. bnez
            7'b01101_xx: begin
                ALUSrc2 = 2'b11;
                ALU_op = 4'b0100;
                RegWrite = 1'b0;
                Bne = 1'b1;
                potRAW_I = 1'b1;
            end

            // 30. bltz
            7'b01110_xx: begin
                ALUSrc2 = 2'b11;
                ALU_op = 4'b0100;
                RegWrite = 1'b0;
                Blt = 1'b1;
                potRAW_I = 1'b1;
            end

            // 31. bgez
            7'b01111_xx: begin
                ALUSrc2 = 2'b11;
                ALU_op = 4'b0100;
                RegWrite = 1'b0;
                Bgt = 1'b1;
                potRAW_I = 1'b1;
            end

            // 32. lbi
            7'b11000_xx: begin
                RegDst = 2'b01;
                ALUSrc1 = 2'b01;
                ALUSrc2 = 2'b10;
                ALU_op = 4'b0100;
                potRAW_I = 1'b1;// need to check
            end

            // 33. slbi
            7'b10010_xx: begin
                ALUSrc1 = 2'b10;
                ALUSrc2 = 2'b10;
                RegDst = 2'b01;
                ALU_op = 4'b1110;
                zeroExt = 1'b1;
                potRAW_I = 1'b1;
            end

            // 34. j
            7'b00100_xx: begin
                ALU_op = 4'b1101;
                RegWrite = 1'b0;
                ImmSrc = 1'b1;
            end

            // 35. jr
            7'b00101_xx: begin
                ALUSrc2 = 2'b10;
                ALU_op = 4'b0100;
                RegWrite = 1'b0;
                ALU_jump = 1'b1;
                potRAW_I = 1'b1;
            end

            // 36. jal
            7'b00110_xx: begin
                MemtoReg = 2'b00;
                RegDst = 2'b11;
                ALU_op = 4'b1101;
                ImmSrc = 1'b1;
            end

            // 37. jalr
            7'b00111_xx: begin
                ALUSrc2 = 2'b10;
                RegDst = 2'b11;
                MemtoReg = 2'b00;
                ALU_op = 4'b0100;
                ALU_jump = 1'b1;
                potRAW_I = 1'b1;
            end

            // Default case
            default: begin
            err = 1'b1;
            RegWrite = 1'b0;
            
            end
        endcase
    end
endmodule
`default_nettype wire
