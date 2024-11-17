# Initialize registers with different values
ADDI R1, R0, 7         # Load immediate value 7 into R1
ADDI R2, R0, 14        # Load immediate value 14 into R2
ADDI R3, R0, 30        # Load immediate value 30 into R3

# Test data hazards
ADD R4, R1, R1         # R4 = R1 + R1 (should be 14)
ADD R4, R4, R1         # R4 = R4 + R1 (should be 21)
ADD R4, R4, R1         # R4 = R4 + R1 (should be 28)
ADD R4, R4, R1         # R4 = R4 + R1 (should be 35)
ADD R4, R4, R2         # R4 = R4 + R2 (should be 49)

SUB R5, R4, R3         # R5 = R4 - R3 (should be 19, check for hazard with R4)

# Control hazard check using branch condition
BNE R1, R2, label1     # Branch should be taken, since R1 != R2
XOR R6, R0, R0         # R6 = 0 (this should be skipped due to the branch)
J label2               # Jump to label2 to skip label1

label1:
ADDI R6, R0, 200       # This should be executed if the branch is taken

label2:
# Load and store test with different addresses
ADDI R7, R0, 50        # Load address (assume 50) into R7
SW R5, 0(R7)           # Store R5 (19) at memory[50]
LW R8, 0(R7)           # Load from memory[50] into R8, R8 should be 19

# Further testing of data hazards 
ADD R9, R8, R1         # R9 = R8 + R1 (should be 26)
BGE R8, R9, label3     # Branch NOT taken, since 19 < 26
OR R10, R0, R0         # This should be executed if branch is not taken

label3:
ADD R11, R8, R2        # R11 = R8 + R2 (should be 33)
SCO R12, R1, R2        # R12 = 1 if R1 + R2 generates carry out, otherwise R12 = 0
JR R3, 6               # Jump to R3 + 6 (30 + 6 = 36)
JAL 12                 # Save return address in R7, jump to PC + 2 + 12
BTR R13, R9            # R13 = bit-reversed value of R9 (bit-reverse of 26)
