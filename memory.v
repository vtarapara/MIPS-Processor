module memoryUnit(
    output data_we,
    output [31:0] exceptionData,
    input exception,
    input [31:0] insn
);
    wire rFlag, iFlag, j1Flag, j2Flag;
    wire [4:0] opcode, aluOpcode;
    insn decInsn(opcode, rFlag, iFlag, j1Flag, j2Flag, insn);
    
    // data write enable condition
    assign data_we = iFlag & (opcode == 5'b00111); // Only write for SW operation

    // exception flag assignments
    assign aluOpcode = insn[6:2];
    assign exceptionData = (rFlag & exception) ? 
                            (aluOpcode == 5'b00000 ? 32'd1 :   // ADD exception
                             aluOpcode == 5'b00001 ? 32'd3 :   // SUB exception
                             aluOpcode == 5'b00110 ? 32'd4 :   // MULT exception
                             aluOpcode == 5'b00111 ? 32'd5 :   // DIV exception
                             32'd0) :
                           (iFlag & exception & opcode == 5'b00101 ? 32'd2 : 32'd0); // ADDI exception


endmodule
