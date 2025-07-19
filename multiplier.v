module multiplier(
    output [31:0] result,
    output overflow,
    output resultReady,
    output resetCounter,
    input [31:0] multiplicand,
    input [31:0] multiplier,
    input clock,
    input [5:0] count
);
    // control signals 
    wire sub, shift, ctrlWE, zeros, ones;
    wire start = ~(count[5] | count[4] | count[3] | count[2] | count[1] | count[0]); // derived from count value
    wire resultReady = ~(count[5] | count[3] | count[2] | count[1] | count[0]) & count[4];
    wire resetCounter = count[4] & ~count[5] & ~count[3] & ~count[2] & count[0] & ~count[1];

    // initial product setup
    wire [64:0] shifted_prod, next_prod;
    wire [64:0] init_prod = {32'b0, multiplier, 1'b0};
    wire [64:0] select_prod = start ? init_prod : next_prod;

    assign init_prod [64:33] = 32'b0;
    assign init_prod [32:1] = multiplier[31:0];
    assign init_prod [0] = 1'b0;
    assign select_prod = start ? init_prod : next_prod;

    // hold shifted/updatded prod value each clk cycle
    register65 post_shift(shifted_prod, select_prod, clock, 1'b1, resetCounter);

    mult_logic ctrl_select(
        .next_prod(next_prod),      
        .sub(sub),        
        .shift(shift),    
        .ctrlWE(ctrlWE),  
        .shifted_prod(shifted_prod), 
        .multiplicand(multiplicand),    
        .opcode(shifted_prod[2:0]), 
        .clock(clock),      
        .reset(resetCounter)     
    );

    assign result = next_prod [32:1]; // Assigning the middle 32 bits of the next product as the result (ignoring the least significant bit for rounding)
    //overflow detection logic
    assign zeros = ~| next_prod [64:33];
    assign ones = & next_prod [64:33];
    assign overflow = (ones & ~result[31]) | (zeros & result[31]) | (~zeros & ~ones);

endmodule