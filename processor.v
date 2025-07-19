/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	 
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

    // bypassing logic
    wire[31:0] bypassA, bypassB;

    // pipeline stage signals, extracted insn fields for bypassing decisions
    wire[31:0] data, DX_InstOut, XM_InstOut, MW_InstOut, address_dmem, XM_Bout, data_writeReg, DX_Aout, DX_Bout, XM_exceptionData, MW_exceptionData;
    wire[4:0] DX_IR_RS1, DX_IR_RS2, XM_IR_RD, MW_IR_RD, DX_IR_OP, XM_IR_OP, MW_IR_OP, XM_SW_RD;
    wire DX_r, DX_i, DX_j1, DX_j2, DX_comp;
    insn instrDX(DX_IR_OP, DX_r, DX_i, DX_j1, DX_j2, DX_InstOut); // decode insn in DX stage

    wire XM_rFlag, XM_iFlag, XM_j1Flag, XM_j2Flag, XM_compIFlag;
    insn instrXM(XM_IR_OP, XM_rFlag, XM_iFlag, XM_j1Flag, XM_j2Flag, XM_InstOut); // decode insn in XM stage

    wire MW_rFlag, MW_iFlag, MW_j1Flag, MW_j2Flag, MW_compIFlag;
    insn instrMW(MW_IR_OP, MW_rFlag, MW_iFlag, MW_j1Flag, MW_j2Flag, MW_InstOut); // decode insn in MW stage

    // instns in various stages are writing back, involve special control flags, or indicate exceptions
    wire DX_rs1, XM_wr, MW_wr, DX_sw, XM_sw, MW_sw, MW_exc, XM_exc;
    assign MW_exc = MW_exceptionData != 32'b0;
    assign XM_exc = XM_exceptionData != 32'b0;
    assign DX_comp = DX_IR_OP == 5'b00110 || DX_IR_OP == 5'b00010;
    assign XM_compIFlag = XM_IR_OP == 5'b00110 || XM_IR_OP == 5'b00010;
    assign MW_compIFlag = MW_IR_OP == 5'b00110 || MW_IR_OP == 5'b00010;
    assign XM_sw = XM_IR_OP == 5'b00111;
    assign MW_sw = MW_IR_OP == 5'b00111;
    assign DX_rs1 = DX_r || (DX_i && ~DX_comp);
    assign XM_wr = XM_rFlag || (XM_iFlag && ~XM_compIFlag && ~XM_sw) || XM_j2Flag;
    assign MW_wr = MW_rFlag || (MW_iFlag && ~MW_compIFlag && ~MW_sw) || MW_j2Flag || MW_exc;

    // bypassing decisions based on reg dependencies btwn stgs
    assign DX_IR_RS1 = DX_rs1 ? DX_InstOut[21:17] : ((DX_j2 || DX_comp) ? DX_InstOut[26:22] : 5'b0);
    assign DX_IR_RS2 = DX_r ? DX_InstOut[16:12] : (DX_comp ? DX_InstOut[21:17] : 5'b0);
    assign XM_IR_RD = XM_wr ? XM_InstOut[26:22] : 5'b0;
    assign MW_IR_RD = MW_wr ? MW_InstOut[26:22] : 5'b0;

    wire DX_RS1_Equals_XM_RD, DX_RS1_Equals_MW_RD; // bypass bypassA
    assign DX_RS1_Equals_XM_RD = ((DX_rs1 || DX_j2 || DX_comp) && XM_wr && XM_IR_RD != 5'b0) ? (DX_IR_RS1 == XM_IR_RD): 1'b0;
    assign DX_RS1_Equals_MW_RD = ((DX_rs1 || DX_j2 || DX_comp) && MW_wr && MW_IR_RD != 5'b0) ? (DX_IR_RS1 == MW_IR_RD): 1'b0;

    wire DX_RS2_Equals_XM_RD, DX_RS2_Equals_MW_RD; // bypass bypassB
    assign DX_RS2_Equals_XM_RD = ((DX_r || DX_comp) && XM_wr && XM_IR_RD != 5'b0) ? (DX_IR_RS2 == XM_IR_RD): 1'b0;
    assign DX_RS2_Equals_MW_RD = ((DX_r || DX_comp) && MW_wr && MW_IR_RD != 5'b0) ? (DX_IR_RS2 == MW_IR_RD): 1'b0;

    // sellecting bypass data based on the determined conditions
    assign bypassA = (XM_exc & DX_IR_RS1 == 5'b11110) ? XM_exceptionData : 
                    (MW_exc & DX_IR_RS1 == 5'b11110) ? MW_exceptionData : 
                    (DX_RS1_Equals_XM_RD ? address_dmem : 
                    (DX_RS1_Equals_MW_RD ? data_writeReg : DX_Aout));
    assign bypassB = (XM_exc & DX_IR_RS2 == 5'b11110) ? XM_exceptionData :
                    (MW_exc & DX_IR_RS2 == 5'b11110) ? MW_exceptionData : 
                    (DX_RS2_Equals_XM_RD ? address_dmem : 
                    (DX_RS2_Equals_MW_RD ? data_writeReg : DX_Bout));

    // special case for data bypassing into DMem for store/load dependencies
    assign XM_SW_RD = XM_sw ? XM_InstOut[26:22] : 5'b0;
    assign data = (XM_sw && MW_wr && XM_SW_RD == MW_IR_RD) ? data_writeReg : XM_Bout;

    // stalling mechanism
    wire latchWrite;
    wire[31:0] nop;
    assign nop = 32'b0;
    assign latchWrite = ~(isMultDiv && ~data_resultRDY);

    // STAGE 1: FETCHHH
    wire [31:0] fetch_PC_out, next_PC;
    wire[31:0] address_imem;
    wire ctrl_branch;

    wire [31:0] incrementedPC, selectPC;
    wire add_ovf;
    cla_32 adder(incrementedPC, add_ovf, address_imem, 32'b1, 1'b0);
    register32 program_ctr(.q(address_imem), .d(selectPC), .clk(~clock), .en(fetch_FD_we), .clr(reset));
    mux_2 jump_check(selectPC, ctrl_branch, incrementedPC, next_PC);

    assign fetch_PC_out = incrementedPC; // Assign the incremented PC to the output for the next stage

    // FD Latch
    wire [31:0] FD_PCout, FD_InstOut, FD_branchCheck;
    wire fetch_FD_we;
    assign fetch_FD_we = latchWrite && ~interlock; // controlled by stalling logic and interlock detection
    register32 FD_PCreg(FD_PCout, fetch_PC_out, ~clock, fetch_FD_we, reset);
    register32 FD_InstReg(FD_InstOut, FD_branchCheck, ~clock, fetch_FD_we, reset);
    mux_2 FD_flush(FD_branchCheck, ctrl_branch, q_imem, nop);

    // STAGE 2: DECODEEE
    wire interlock;
    wire [4:0] opcode, IR_readRegA, j2_readRegA, branchI_readRegB, bex_readRegA;
    wire r, i, j1, j2, sw, branchI, bex;

    insn instr(opcode, r, i, j1, j2, FD_InstOut);

    // control signals for register reads
    assign IR_readRegA = branchI ? FD_InstOut[26:22] : ((r || i) ? FD_InstOut[21:17] : 5'b0);
    assign ctrl_readRegB = r ? FD_InstOut[16:12] : (sw ? FD_InstOut[26:22] : (branchI ? FD_InstOut[21:17] : 5'b0));

    // flags based on opcode
    assign sw = i & (opcode == 5'b00111);
    assign branchI = i & (opcode == 5'b00110 || opcode == 5'b00010);
    assign bex = j1 & (opcode == 5'b10110);

    // J-type and special case handling
    assign j2_readRegA = j2 ? FD_InstOut[26:22] : 5'b0;
    assign bex_readRegA = bex ? 5'b11110 : 5'b0;
    assign ctrl_readRegA = j2 ? j2_readRegA : (bex ? bex_readRegA : IR_readRegA);

    // interlock detection logic
    wire [4:0] FD_IR_OP, FD_IR_RS1, FD_IR_RS2, DX_IR_RD;
    wire FD_rFlag, FD_iFlag, FD_j1Flag, FD_j2Flag, isBNE, isBLT;
    wire DXhasRD, FDhasRS1, FDhasRS2;
    wire FD_RS1_Equals_DX_RD, FD_RS2_Equals_DX_RD;

    insn instrFD(FD_IR_OP, FD_rFlag, FD_iFlag, FD_j1Flag, FD_j2Flag, FD_InstOut);

    assign isBNE = DX_IR_OP == 5'b00010;
    assign isBLT = DX_IR_OP == 5'b00110;
    assign DXhasRD = DX_r || (DX_i && ~isBNE && ~isBLT) || DX_j2;
    assign FDhasRS1 = FD_rFlag || FD_iFlag;
    assign FD_IR_RS1 = FDhasRS1 ? FD_InstOut[21:17] : 5'b0;
    assign DX_IR_RD = DXhasRD ? DX_InstOut[26:22] : 5'b0;
    assign FD_IR_RS2 = FD_rFlag ? FD_InstOut[16:12] : 5'b0;
    assign FD_RS1_Equals_DX_RD = (FDhasRS1 && DXhasRD) ? (FD_IR_RS1 == DX_IR_RD) : 1'b0;
    assign FD_RS2_Equals_DX_RD = (FD_rFlag && DXhasRD) ? (FD_IR_RS2 == DX_IR_RD) : 1'b0;

    assign interlock = ((DX_IR_OP == 5'b01000) && FD_RS1_Equals_DX_RD) ||
                    ((FD_IR_OP != 5'b00111) && FD_RS2_Equals_DX_RD) ||
                    ((DX_IR_OP == 5'b01000) && DX_InstOut[26:22] == 5'b11111 && FD_IR_OP == 5'b00100) ||
                    ((DX_IR_OP == 5'b01000) && FD_IR_OP == 5'b00010 && DX_InstOut[26:22] == FD_InstOut[26:22]);

    // bypass into data_readRegA, decode insn = bex writeback insn = SETX;
    wire[4:0] FDopcode, MWopcode;
    wire[31:0] dataInA;
    wire BEX_SETX_exception;
    assign FDopcode = FD_InstOut[31:26];
    assign MWopcode = MW_InstOut[31:26];
    assign BEX_SETX_exception = (FDopcode == 5'b10110) && (MWopcode == 5'b10101);
    assign dataInA = BEX_SETX_exception ? data_writeReg : data_readRegA;

    // DX Latch
    wire [31:0] DX_PCout, DX_branchCheck;
    register32 DX_PC(.q(DX_PCout), .d(FD_PCout), .clk(~clock), .en(latchWrite), .clr(reset));
    register32 DX_A(.q(DX_Aout), .d(dataInA), .clk(~clock), .en(latchWrite), .clr(reset));
    register32 DX_B(.q(DX_Bout), .d(data_readRegB), .clk(~clock), .en(latchWrite), .clr(reset));
    register32 DX_Inst(.q(DX_InstOut), .d(DX_branchCheck), .clk(~clock), .en(latchWrite), .clr(reset));
    mux_2 DX_flush(DX_branchCheck, ctrl_branch || interlock, FD_InstOut, nop);

    // STAGE 3: EXECUTEEE
    wire[31:0] aluOut, executeOut, selectedA, selectedB, AafterJal, aluOpcodeAfterJal;
    wire[4:0] aluOpcode, shamt;
    wire adder_overflow, isNotEqual, isLessThan, isMultDiv, isBEX;
    execUnit stg3(next_PC, selectedA, selectedB, aluOpcode, shamt, ctrl_branch, isMult, isDiv, isBLT, isBNE, isBEX, bypassA, bypassB, DX_InstOut, DX_PCout, isLessThan, isNotEqual, clock);

    // blking signal, multdiv, alu
    alu alu_exec(selectedA, selectedB, aluOpcode, shamt, aluOut, isNotEqual, isLessThan, adder_overflow, clock);
    dffe_ref blk(blkCtrlSignal, 1'b1, clock, isMultDiv, data_resultRDY);
    multdiv multDiv(bypassA, selectedB, ctrlMult, ctrlDiv, clock, multDivResult, mult_exception, div_exception, data_resultRDY);

    // Special Handling for Multiply/Divide and Jal Instructions
    wire data_resultRDY, mult_exception, div_exception, isMult, isDiv, ctrlMult, ctrlDiv, blkCtrlSignal, exc_in;
    wire[31:0] multDivResult;
    assign isMultDiv = isMult || isDiv;
    assign executeOut = isMultDiv ? multDivResult : aluOut;
    assign ctrlMult = isMult & ~blkCtrlSignal & ~data_resultRDY & ~clock;
    assign ctrlDiv = isDiv & ~blkCtrlSignal & ~data_resultRDY & ~clock;

    assign exc_in = adder_overflow | ((mult_exception || div_exception) && data_resultRDY);
    
    // XM Latch
    wire XM_exceptionOut;
    register32 XM_O(address_dmem, executeOut, ~clock, latchWrite, reset); // address input to dmem
    register32 XM_B(XM_Bout, DX_Bout, ~clock, latchWrite, reset); // data input to dmem
    register32 XM_Inst(XM_InstOut, DX_InstOut, ~clock, latchWrite, reset);
    register XM_error(XM_exceptionOut, exc_in, ~clock, latchWrite, reset);

    // STAGE 4: MEMORYYY
    memoryUnit stg4(wren, XM_exceptionData, XM_exceptionOut, XM_InstOut);

    // MW Latch
    wire MW_exceptionOut;
    wire [31:0] MW_Oout, MW_Dout;
    register32 MW_O(.q(MW_Oout), .d(address_dmem), .clk(~clock), .en(latchWrite), .clr(reset));
    register32 MW_D(.q(MW_Dout), .d(q_dmem), .clk(~clock), .en(latchWrite), .clr(reset));
    register32 MW_Inst(.q(MW_InstOut), .d(XM_InstOut), .clk(~clock), .en(latchWrite), .clr(reset));
    register MW_error(MW_exceptionOut, XM_exceptionOut, ~clock, latchWrite, reset);

    // STAGE 5: WRITEBACKKK
    writebackUnit stg5(ctrl_writeEnable, ctrl_writeReg, data_writeReg, MW_exceptionData, MW_exceptionOut, MW_Dout, MW_Oout, MW_InstOut);

endmodule
