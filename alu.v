module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow, clock);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;
    input clock;
    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;
    // add your code here:
    wire [31:0] ares;
    wire [31:0] ores;
    wire [31:0] nb;
    wire [31:0] add_res;
    wire [31:0] sub_res;
    wire add_of;
    wire sub_of;
    wire nsub_res;
    wire [31:0] sll_res;
    wire [31:0] sra_res;

    mux_2_onebit mux_1b(overflow, ctrl_ALUopcode[0], add_of, sub_of);
    mux_8 mux_32b(data_result, ctrl_ALUopcode[2:0], add_res[31:0], sub_res[31:0], ares[31:0], ores[31:0], sll_res[31:0], sra_res[31:0], 32'b0, 32'b0);
    assign isLessThan = overflow ? nsub_res : sub_res[31];
    not notsubout(nsub_res, sub_res[31]);

    and_32_bitwise and_op(data_operandA, data_operandB, ares);
    not_32_bitwise nb_op(data_operandB, nb);
    or_32_bitwise or_op(data_operandA, data_operandB, ores);
    sra_32_bit sra_op(sra_res, data_operandA, ctrl_shiftamt);
    sll_32_bit sll_op(sll_res, data_operandA, ctrl_shiftamt);

    cla_32 add(.s(add_res), .cout(add_of), .a(data_operandA), .b(data_operandB), .cin(1'b0));
    sub subtract(.s(sub_res), .cout(sub_of), .a(data_operandA), .b(data_operandB), .c0(1'b1));
    or ne(isNotEqual, sub_res[0], sub_res[1], sub_res[2], sub_res[3], sub_res[4], sub_res[5], sub_res[6], sub_res[7], sub_res[8], sub_res[9], sub_res[10], sub_res[11], sub_res[12], sub_res[13], sub_res[14], sub_res[15], sub_res[16], sub_res[17], sub_res[18], sub_res[19], sub_res[20], sub_res[21], sub_res[22], sub_res[23], sub_res[24], sub_res[25], sub_res[26], sub_res[27], sub_res[28], sub_res[29], sub_res[30], sub_res[31]);

endmodule