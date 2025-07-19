module insn( // instruction type
    output [4:0] opcode,
    output rFlag, iFlag, j1Flag, j2Flag,
    input [31:0] instruction
);
    assign opcode = instruction[31:27];

    // Detect R-type instructions; assuming '0' opcode implies R-type except for a NO-OP (0x00000000).
    assign rFlag = (opcode == 5'b00000) && (instruction != 32'b0);

    // Detect I-type instructions based on specific opcodes.
    assign iFlag = opcode == 5'b00010 || opcode == 5'b00101 || 
                   opcode == 5'b00110 || opcode == 5'b00111 || 
                   opcode == 5'b01000;

    // Detect J1-type instructions based on specific opcodes.
    assign j1Flag = opcode == 5'b00001 || opcode == 5'b00011 || 
                    opcode == 5'b10110 || opcode == 5'b10101;

    // Detect J2-type instructions with a specific opcode.
    assign j2Flag = opcode == 5'b00100;

endmodule
