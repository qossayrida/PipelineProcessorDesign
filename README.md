# Pipeline Processor Design

![image](https://github.com/qossayrida/PipelineProcessorDesign/assets/59481839/0d23f7e3-d67c-4878-a9d0-e9482b42d2c5)


# Instruction Set Table

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



# Instruction Signals Table

| No. | Instruction/Signals | ALUOp | Operation |
|-----|---------------------|-------|-----------|
|  1  | AND                 | AND   | 00        |
|  2  | ADD                 | ADD   | 01        |        
|  3  | SUB                 | SUB   | 10        |        
|  4  | ADDI                | ADD   | 01        |        
|  5  | ANDI                | AND   | 00        |        
|  6  | LW                  | ADD   | 01        |        
|  7  | LBU                 | ADD   | 01        |        
|  8  | LBS                 | ADD   | 01        |        
|  9  | SW                  | ADD   | 01        |        
| 10  | BGT                 | X     | XX        |        
| 11  | BGTZ                | X     | XX        |        
| 12  | BLT                 | X     | XX        |        
| 13  | BLTZ                | X     | XX        |        
| 14  | BEQ                 | X     | XX        |        
| 15  | BEQZ                | X     | XX        |        
| 16  | BNE                 | X     | XX        |        
| 17  | BNEZ                | X     | XX        |        
| 18  | JMP                 | X     | XX        |        
| 19  | CALL                | X     | XX        |        
| 20  | RET                 | X     | XX        |        
| 21  | Sv                  | ADD   | 01        |        


| No. | Instruction/Signals | PCSrc | kill|
|-----|---------------------|-------|-------|
|  1  | AND                 |  0  |  0  |  
|  2  | ADD                 |  0  |  0  |      
|  3  | SUB                 |  0  |  0  |       
|  4  | ADDI                |  0  |  0  |        
|  5  | ANDI                |  0  |  0  |        
|  6  | LW                  |  0  |  0  |         
|  7  | LBU                 |  0  |  0  |          
|  8  | LBS                 |  0  |  0  |        
|  9  | SW                  |  0  |  0  |       
| 10  | BGT                 |  if (Taken) 2 else  0  |  if (Taken) 1 else  0  |       
| 11  | BGTZ                |  if (Taken) 2 else  0   | if (Taken) 1 else  0  |      
| 12  | BLT                 |  if (Taken) 2 else  0   | if (Taken) 1 else  0 |        
| 13  | BLTZ                |  if (Taken) 2 else  0   |  if (Taken) 1 else  0  |       
| 14  | BEQ                 |  if (Taken) 2 else  0   |  if (Taken) 1 else  0  |       
| 15  | BEQZ                |  if (Taken) 2 else  0   |  if (Taken) 1 else  0 |       
| 16  | BNE                 |  if (Taken) 2 else  0   |  if (Taken) 1 else  0  |       
| 17  | BNEZ                |  if (Taken) 2 else  0   |  if (Taken) 1 else  0 |       
| 18  | JMP                 |  1   |  1  |      
| 19  | CALL                |  1   |  1  |         
| 20  | RET                 |  3   |  1  |       
| 21  | Sv                |  0   |  0  |   


## 🔗 Links

[![facebook](https://img.shields.io/badge/facebook-0077B5?style=for-the-badge&logo=facebook&logoColor=white)](https://www.facebook.com/qossay.rida?mibextid=2JQ9oc)

[![Whatsapp](https://img.shields.io/badge/Whatsapp-25D366?style=for-the-badge&logo=Whatsapp&logoColor=white)](https://wa.me/+972598592423)

[![linkedin](https://img.shields.io/badge/linkedin-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/qossay-rida-3aa3b81a1?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app )

[![twitter](https://img.shields.io/badge/twitter-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white)](https://twitter.com/qossayrida)