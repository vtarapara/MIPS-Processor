module branchUnit(
    output [31:0] nextPC,
    output ctrl_branch, overwriteReg31, isBLT, isBNE, isBEX, isSETX, jumpFlag,
    input iFlag, j1Flag, j2Flag, isLessThan, isNotEqual,
    input [31:0] insn, data_readRegA, PC, immediate
);

    // Opcode extraction and flag assignments
    wire [4:0] opcode = insn[31:27];
    wire jalFlag = (opcode == 5'b00011) && j1Flag;
    wire jrFlag = (opcode == 5'b00100) && j2Flag;
    wire jumpFlag = (opcode == 5'b00001) && j1Flag;
    wire isBLT = (opcode == 5'b00110) && iFlag;
    wire isBNE = (opcode == 5'b00010) && iFlag;
    wire isBEX = (opcode == 5'b10110) && j1Flag;
    wire isSETX = (opcode == 5'b10101) && j1Flag;

    // branch control signal
    assign ctrl_branch = (isBEX & isNotEqual) || (isBNE & isNotEqual) || (isBLT & isLessThan) || jalFlag || jumpFlag || jrFlag;
    assign overwriteReg31 = jalFlag; // Only jal sets register 31

    // Sign extension and addition for branch address calculation
    wire [26:0] target = insn[26:0];
    wire [31:0] extendedTarget = {{5{target[26]}}, target}; // Direct sign extension
    wire [31:0] PCafterAdd;
    wire overflow; // Overflow from addition, currently unused, available for future use
    cla_32 adder(PCafterAdd, overflow, PC, immediate, 1'b0);

    // determine next PC based on branching conditions and flags
    assign nextPC = jrFlag ? data_readRegA :
                         (jalFlag || jumpFlag || isBEX || isSETX ? extendedTarget :
                         (isBLT || isBNE ? PCafterAdd : PC));

endmodule
