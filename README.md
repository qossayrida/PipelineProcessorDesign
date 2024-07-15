# Pipeline Processor Design
This repository contains the design and verification of a simple pipelined RISC processor in Verilog, developed as a project for the Computer Architecture course (ENCS4370) at the Faculty of Engineering & Technology, Electrical & Computer Engineering Department.

## Table of Contents
- [Abstract](#abstract)
- [Features](#features)
- [Instruction Set Architecture (ISA)](#instruction-set-architecture-isa)
- [Design and Implementation](#design-and-implementation)
- [Datapath](#datapath)
- [Control Signals](#control-signals)
- [Individual Components](#individual-components)
- [Pipeline Stages](#pipeline-stages)
- [Team Members](#team-members)
- [Acknowledgments](#acknowledgments)

## Abstract
This project involves designing and verifying a simple pipelined RISC processor in Verilog, featuring a five-stage pipeline: fetch, decode, ALU, memory access, and write-back. We implemented an instruction set architecture (ISA) with R-type, I-type, J-type, and S-type instructions, supported by 8 general-purpose registers and byte-addressable memory. Our report provides a comprehensive description of the datapath, control path, control signals, and verification methods, including detailed simulation results. We demonstrate the processor's functionality through rigorous testing and analysis.

## Features
- Five-stage pipeline: Fetch, Decode, Execute, Memory Access, and Write-Back
- Support for R-type, I-type, J-type, and S-type instructions
- 8 general-purpose registers
- Byte-addressable memory
- Hazard detection and forwarding mechanisms

## Instruction Set Architecture (ISA)
### Instruction Types
- **R-Type**: Arithmetic and logic operations
- **I-Type**: Immediate arithmetic and logic operations, load word
- **J-Type**: Jump instructions
- **S-Type**: Store word

### Instruction Formats
- **R-Type**: `Opcode | Rd | Rs1 | Rs2`
- **I-Type**: `Opcode | Rd | Rs1 | Immediate`
- **J-Type**: `Opcode | Jump Offset`
- **S-Type**: `Opcode | Rs | Immediate`

### Instruction Set Table
| No. | Instr | Format | Meaning | Opcode Value | m |
|-----|-------|--------|---------|--------------|---|
| 1   | AND   | R-Type | Reg(Rd) = Reg(Rs1) & Reg(Rs2) | 0000 |   |
| 2   | ADD   | R-Type | Reg(Rd) = Reg(Rs1) + Reg(Rs2) | 0001 |   |
| 3   | SUB   | R-Type | Reg(Rd) = Reg(Rs1) - Reg(Rs2) | 0010 |   |
| 4   | ADDI  | I-Type | Reg(Rd) = Reg(Rs1) + Imm | 0011 |   |
| 5   | ANDI  | I-Type | Reg(Rd) = Reg(Rs1) + Imm | 0100 |   |
| 6   | LW    | I-Type | Reg(Rd) = Mem(Reg(Rs1) + Imm) | 0101 | 0 |
| 7   | LBu   | I-Type | Reg(Rd) = Mem(Reg(Rs1) + Imm) | 0110 | 0 |
| 8   | LB$   | I-Type | Reg(Rd) = Mem(Reg(Rs1) + Imm) | 0110 | 1 |
| 9   | SW    | I-Type | Mem(Reg(Rs1) + Imm) = Reg(Rd) | 0111 |   |
| 10  | BGT   | I-Type | if (Reg(Rd) > Reg(Rs1)) Next PC = PC + sign_extended (Imm) else PC = PC + 2 | 1000 | 0 |
| 11  | BGTZ  | I-Type | if (Reg(Rd) > Reg(R0)) Next PC = PC + sign_extended (Imm) else PC = PC + 2 | 1000 | 1 |
| 12  | BLT   | I-Type | if (Reg(Rd) < Reg(Rs1)) Next PC = PC + sign_extended (Imm) else PC = PC + 2 | 1001 | 0 |
| 13  | BLTZ  | I-Type | if (Reg(Rd) < Reg(R0)) Next PC = PC + sign_extended (Imm) else PC = PC + 2 | 1001 | 1 |
| 14  | BEQ   | I-Type | if (Reg(Rd) == Reg(Rs1)) Next PC = PC + sign_extended (Imm) else PC = PC + 2 | 1010 | 0 |
| 15  | BEQZ  | I-Type | if (Reg(Rd) == Reg(R0)) Next PC = PC + sign_extended (Imm) else PC = PC + 2 | 1010 | 1 |
| 16  | BNE   | I-Type | if (Reg(Rd) != Reg(Rs1)) Next PC = PC + sign_extended (Imm) else PC = PC + 2 | 1011 | 0 |
| 17  | BNEZ  | I-Type | if (Reg(Rd) != Reg(Rs1)) Next PC = PC + sign_extended (Imm) else PC = PC + 2 | 1011 | 1 |
| 18  | JMP   | J-Type | Next PC = {PC[15:10], Immediate} | 1100 |   |
| 19  | CALL  | J-Type | Next PC = {PC[15:10], Immediate} PC + 4 is saved on r15 | 1101 |   |
| 20  | RET   | J-Type | Next PC = r7 | 1110 |   |
| 21  | Sv    | S-Type | M[rs] = imm | 1111 |   | 

## Design and Implementation
The processor design is divided into multiple stages to facilitate pipelining and improve performance. Each component in the datapath was built separately in Verilog and then integrated to form the complete processor.

### Datapath
The datapath includes the flow of data through the processor, including instruction fetch, decoding, execution, memory access, and write-back stages. Key components include the ALU, registers, instruction memory, data memory, and control unit.

![final](https://github.com/qossayrida/PipelineProcessorDesign/assets/164505468/06ee75ba-6b8a-43a8-9df7-f4c44cb20ea2)

### Control Signals
Control signals manage the operation of the processor components, including ALU operations, memory access, and instruction flow control, for more information see the report above.

### Individual Components
- **Instruction Memory**: Stores and fetches instructions.
- **Register File**: Provides read and write access to registers.
- **Data Memory**: Handles data storage and retrieval.
- **ALU**: Performs arithmetic and logic operations.
- **Extender**: Adjusts the bit-width of data.
- **Compare**: Performs value comparisons.
- **Control Unit**: Generates control signals and manages instruction flow.

### Pipeline Stages
1. **Instruction Fetch (IF)**: Retrieves instructions from memory.
2. **Instruction Decode (ID)**: Decodes instructions and reads registers.
3. **Execution (EXE)**: Performs arithmetic and logic operations.
4. **Memory Access (MEM)**: Handles data memory operations.
5. **Write-Back (WB)**: Writes results back to registers.


## Team Members
- Qossay Rida
- Ahmad Hamdan
- Mohammad Fareed

## Acknowledgments
This project was completed under the guidance of Dr. Aziz Qaroush, Faculty of Engineering & Technology, Electrical & Computer Engineering Department.


## 🔗 Links

[![facebook](https://img.shields.io/badge/facebook-0077B5?style=for-the-badge&logo=facebook&logoColor=white)](https://www.facebook.com/qossay.rida?mibextid=2JQ9oc)

[![Whatsapp](https://img.shields.io/badge/Whatsapp-25D366?style=for-the-badge&logo=Whatsapp&logoColor=white)](https://wa.me/+972598592423)

[![linkedin](https://img.shields.io/badge/linkedin-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/qossay-rida-3aa3b81a1?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app )

[![twitter](https://img.shields.io/badge/twitter-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white)](https://twitter.com/qossayrida)
