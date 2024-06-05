parameter

    LOW = 0,
    HIGH = 1,
	
	OP_CODE_LENGTH=3'd4,
	AND  = 4'b0000, // AND operation
    ADD  = 4'b0001, // ADD operation
    SUB  = 4'b0010, // SUB operation
    ADDI = 4'b0011, // ADD Immediate
    ANDI = 4'b0100, // AND Immediate
    LW   = 4'b0101, // Load Word
    LBu  = 4'b0110, // Load Byte unsigned
    LBs  = 4'b0110, // Load Byte signed
	LOAD_BYTE  = 4'b0110,
    SW   = 4'b0111, // Store Word
    
    BGT  = 4'b1000, // Branch if Greater Than
    BGTZ = 4'b1000, // Branch if Greater Than Zero
    BLT  = 4'b1001, // Branch if Less Than
    BLTZ = 4'b1001, // Branch if Less Than Zero
    BEQ  = 4'b1010, // Branch if Equal
    BEOZ = 4'b1010, // Branch if Equal to Zero
    BNE  = 4'b1011, // Branch if Not Equal
    BNEZ = 4'b1011, // Branch if Not Equal to Zero
    
    JMP  = 4'b1100, // Jump
    CALL = 4'b1101, // Call subroutine
    RET  = 4'b1110, // Return from subroutine
    Sv   = 4'b1111, // Store value
	
	
	R0 = 3'd0, // zero register
    R1 = 3'd1, // general purpose register
    R2 = 3'd2, // general purpose register
    R3 = 3'd3, // general purpose register
    R4 = 3'd4, // general purpose register
    R5 = 3'd5, // general purpose register
    R6 = 3'd6, // general purpose register
    R7 = 3'd7, // general purpose register
	
	ALU_OP_CODE_LENGTH=3'd2,
	ALU_OP_AND = 2'b00,
    ALU_OP_ADD = 2'b01,
    ALU_OP_SUB = 2'b10;