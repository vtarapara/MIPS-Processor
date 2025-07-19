module writebackUnit(
    output ctrl_writeEnable,
    output [4:0] ctrl_writeReg,
    output [31:0] data_writeReg, exceptionData,
    input exception,
    input [31:0] dataFromDmem, dataFromAlu, insn
);
    wire rFlag, iFlag, j1Flag, j2Flag;
    wire [4:0] opcode, aluOpcode;
    insn decInsn(opcode, rFlag, iFlag, j1Flag, j2Flag, insn);

    // flag assignments
    wire lwFlag = iFlag && (opcode == 5'b01000);
    wire jalFlag = j1Flag && (opcode == 5'b00011);
    wire setxFlag = j1Flag && (opcode == 5'b10101);
    
    // control signals based on insn flags
    assign ctrl_writeEnable = rFlag || lwFlag || (iFlag && opcode == 5'b00101) || jalFlag || setxFlag || exception;
    assign ctrl_writeReg = exception ? 5'b11110 : 
                           (rFlag || lwFlag || (iFlag && opcode == 5'b00101)) ? insn[26:22] : 
                           (jalFlag ? 5'b11111 : (setxFlag ? 5'b11110 : 5'b0));

    // exceptionData based on aluOpcode and exception presence
    assign aluOpcode = insn[6:2];
    assign exceptionData = (exception) ? (
                             (rFlag && aluOpcode == 5'b00000) ? 32'd1 :   // ADD exception
                             ((iFlag && opcode == 5'b00101) ? 32'd2 :     // ADDI exception
                             (rFlag && aluOpcode == 5'b00001) ? 32'd3 :   // SUB exception
                             (rFlag && aluOpcode == 5'b00110) ? 32'd4 :   // MULT exception
                             (rFlag && aluOpcode == 5'b00111) ? 32'd5 : 32'd0)) : 32'd0;

    // determine data to write back based on instruction type and presence of exceptions
    wire useRamData = lwFlag; // reflects LW instruction handling
    assign data_writeReg = exception ? exceptionData : (useRamData ? dataFromDmem : dataFromAlu);

endmodule
