# Initialize registers
ADDI R1, R0, 5      # Load immediate value 5 into R1
ADDI R2, R0, 10     # Load immediate value 10 into R2
ADDI R3, R0, 20     # Load immediate value 20 into R3

# Data Hazard Check (R4 depends on R1)
ADD R4, R1, R2      # R4 = R1 + R2 (should be 15)
SUB R5, R4, R3      # R5 = R4 - R3 (should be -5, check for data hazard here)

# Control Hazard Check (branching)
BEQ R1, R2, label1  # Branch should *not* be taken
ADD R6, R0, R0      # R6 = 0, executes if branch not taken
J label2            # Jump to skip label1

label1:
ADDI R6, R0, 100    # This should be skipped due to the jump

label2:
# Load and Store Test
ADDI R7, R0, 40     # Load address (assume 40) into R7
SW R4, 0(R7)        # Store R4 (15) at memory[40]
LW R8, 0(R7)        # Load from memory[40] into R8, R8 should be 15

# Further testing of hazards and stalls
ADD R9, R8, R1      # R9 = R8 + R1 (should be 20)
BEQ R8, R4, label3  # Branch taken if R8 == R4 (expected, since R8 = 15)
ADD R10, R0, R0     # This should be skipped if branch is taken

label3:
SUB R11, R8, R1     # R11 = R8 - R1 (should be 10)

