module execUnit(
    output [31:0] nextPC, selectedA, selectedB,
    output [4:0] aluOpcode, shiftAmt,
    output ctrl_branch, isMult, isDiv, isBLT, isBNE, isBEX,
    input [31:0] dataRegA, dataRegB, insn, PC,
    input isLessThan, isNotEqual, clock
);

    wire rType, iType, j1Type, j2Type, setReg31, branchCond, isSetxOp, isJump;
    wire [4:0] insnOp, jumpReg;
    insn decodeInsn(insnOp, rType, iType, j1Type, j2Type, insn);

    // Set flags for multiply and divide operations
    assign isMult = rType && (aluOpcode == 5'b00110);
    assign isDiv = rType && (aluOpcode == 5'b00111);

    // Determine ALU operation and shift amount based on R-type instruction
    assign aluOpcode = rType ? insn[6:2] : 5'b0;
    assign shiftAmt = rType ? insn[11:7] : 5'b0;

    assign branchCond = isBLT || isBNE; // Check for branch conditions
    // Control branching logic
    branchUnit branching(
    nextPC, ctrl_branch, setReg31, isBLT, isBNE, 
    isBEX, isSetxOp, isJump, iType, j1Type, j2Type, 
    isLessThan, isNotEqual, insn, dataRegA, PC, immVal
    );

    // Determine selectedA based on whether PC is to be used or regular dataRegA
    assign selectedA = setReg31 ? PC : 
                       (isSetxOp ? 32'b0 : dataRegA);

    // Compute selectedB based on instruction type and operation
    wire [31:0] immVal;
    assign immVal = {{15{insn[16]}}, insn[16:0]};// Extend immediate value
    assign selectedB = (rType || branchCond) ? dataRegB : 
                        ((setReg31 || isBEX || isJump) ? 32'b0 : 
                        (isSetxOp ? nextPC : immVal));


endmodule
