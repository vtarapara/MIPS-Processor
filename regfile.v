module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;

	output [31:0] data_readRegA, data_readRegB;

	// add your code here
	wire [31:0] write_en, write;
	decoder32 writeDecoder(write_en, ctrl_writeReg, ctrl_writeEnable);

	// port A to each reg
	wire [31:0] readRegisterA;
	decoder32 readA(readRegisterA, ctrl_readRegA, 1'b1);

	// port B to each reg
	wire [31:0] readRegisterB;
	decoder32 readB(readRegisterB, ctrl_readRegB, 1'b1);

	// connect regs
	wire [31:0] registers[31:0];

	and gate0(write[0], write_en[0], ctrl_writeEnable);
	register32 reg0(registers[0], data_writeReg, clock, 1'b0, ctrl_reset);
	tristate_buffer buffer0A(data_readRegA, 32'b0, readRegisterA[0]);
	tristate_buffer buffer0B(data_readRegB, 32'b0, readRegisterB[0]);

	and gate1(write[1], write_en[1], ctrl_writeEnable);
	register32 reg1(registers[1], data_writeReg, clock, write[1], ctrl_reset);
	tristate_buffer bufferA1(data_readRegA, registers[1], readRegisterA[1]);
	tristate_buffer bufferB1(data_readRegB, registers[1], readRegisterB[1]);

	and gate2(write[2], write_en[2], ctrl_writeEnable);
	register32 reg2(registers[2], data_writeReg, clock, write[2], ctrl_reset);
	tristate_buffer bufferA2(data_readRegA, registers[2], readRegisterA[2]);
	tristate_buffer bufferB2(data_readRegB, registers[2], readRegisterB[2]);

	and gate3(write[3], write_en[3], ctrl_writeEnable);
	register32 reg3(registers[3], data_writeReg, clock, write[3], ctrl_reset);
	tristate_buffer bufferA3(data_readRegA, registers[3], readRegisterA[3]);
	tristate_buffer bufferB3(data_readRegB, registers[3], readRegisterB[3]);

	and gate4(write[4], write_en[4], ctrl_writeEnable);
	register32 reg4(registers[4], data_writeReg, clock, write[4], ctrl_reset);
	tristate_buffer bufferA4(data_readRegA, registers[4], readRegisterA[4]);
	tristate_buffer bufferB4(data_readRegB, registers[4], readRegisterB[4]);

	and gate5(write[5], write_en[5], ctrl_writeEnable);
	register32 reg5(registers[5], data_writeReg, clock, write[5], ctrl_reset);
	tristate_buffer bufferA5(data_readRegA, registers[5], readRegisterA[5]);
	tristate_buffer bufferB5(data_readRegB, registers[5], readRegisterB[5]);

	and gate6(write[6], write_en[6], ctrl_writeEnable);
	register32 reg6(registers[6], data_writeReg, clock, write[6], ctrl_reset);
	tristate_buffer bufferA6(data_readRegA, registers[6], readRegisterA[6]);
	tristate_buffer bufferB6(data_readRegB, registers[6], readRegisterB[6]);

	and gate7(write[7], write_en[7], ctrl_writeEnable);
	register32 reg7(registers[7], data_writeReg, clock, write[7], ctrl_reset);
	tristate_buffer bufferA7(data_readRegA, registers[7], readRegisterA[7]);
	tristate_buffer bufferB7(data_readRegB, registers[7], readRegisterB[7]);

	and gate8(write[8], write_en[8], ctrl_writeEnable);
	register32 reg8(registers[8], data_writeReg, clock, write[8], ctrl_reset);
	tristate_buffer bufferA8(data_readRegA, registers[8], readRegisterA[8]);
	tristate_buffer bufferB8(data_readRegB, registers[8], readRegisterB[8]);

	and gate9(write[9], write_en[9], ctrl_writeEnable);
	register32 reg9(registers[9], data_writeReg, clock, write[9], ctrl_reset);
	tristate_buffer bufferA9(data_readRegA, registers[9], readRegisterA[9]);
	tristate_buffer bufferB9(data_readRegB, registers[9], readRegisterB[9]);

	and gate10(write[10], write_en[10], ctrl_writeEnable);
	register32 reg10(registers[10], data_writeReg, clock, write[10], ctrl_reset);
	tristate_buffer bufferA10(data_readRegA, registers[10], readRegisterA[10]);
	tristate_buffer bufferB10(data_readRegB, registers[10], readRegisterB[10]);

	and gate11(write[11], write_en[11], ctrl_writeEnable);
	register32 reg11(registers[11], data_writeReg, clock, write[11], ctrl_reset);
	tristate_buffer bufferA11(data_readRegA, registers[11], readRegisterA[11]);
	tristate_buffer bufferB11(data_readRegB, registers[11], readRegisterB[11]);

	and gate12(write[12], write_en[12], ctrl_writeEnable);
	register32 reg12(registers[12], data_writeReg, clock, write[12], ctrl_reset);
	tristate_buffer bufferA12(data_readRegA, registers[12], readRegisterA[12]);
	tristate_buffer bufferB12(data_readRegB, registers[12], readRegisterB[12]);

	and gate13(write[13], write_en[13], ctrl_writeEnable);
	register32 reg13(registers[13], data_writeReg, clock, write[13], ctrl_reset);
	tristate_buffer bufferA13(data_readRegA, registers[13], readRegisterA[13]);
	tristate_buffer bufferB13(data_readRegB, registers[13], readRegisterB[13]);

	and gate14(write[14], write_en[14], ctrl_writeEnable);
	register32 reg14(registers[14], data_writeReg, clock, write[14], ctrl_reset);
	tristate_buffer bufferA14(data_readRegA, registers[14], readRegisterA[14]);
	tristate_buffer bufferB14(data_readRegB, registers[14], readRegisterB[14]);

	and gate15(write[15], write_en[15], ctrl_writeEnable);
	register32 reg15(registers[15], data_writeReg, clock, write[15], ctrl_reset);
	tristate_buffer bufferA15(data_readRegA, registers[15], readRegisterA[15]);
	tristate_buffer bufferB15(data_readRegB, registers[15], readRegisterB[15]);

	and gate16(write[16], write_en[16], ctrl_writeEnable);
	register32 reg16(registers[16], data_writeReg, clock, write[16], ctrl_reset);
	tristate_buffer bufferA16(data_readRegA, registers[16], readRegisterA[16]);
	tristate_buffer bufferB16(data_readRegB, registers[16], readRegisterB[16]);

	and gate17(write[17], write_en[17], ctrl_writeEnable);
	register32 reg17(registers[17], data_writeReg, clock, write[17], ctrl_reset);
	tristate_buffer bufferA17(data_readRegA, registers[17], readRegisterA[17]);
	tristate_buffer bufferB17(data_readRegB, registers[17], readRegisterB[17]);

	and gate18(write[18], write_en[18], ctrl_writeEnable);
	register32 reg18(registers[18], data_writeReg, clock, write[18], ctrl_reset);
	tristate_buffer bufferA18(data_readRegA, registers[18], readRegisterA[18]);
	tristate_buffer bufferB18(data_readRegB, registers[18], readRegisterB[18]);

	and gate19(write[19], write_en[19], ctrl_writeEnable);
	register32 reg19(registers[19], data_writeReg, clock, write[19], ctrl_reset);
	tristate_buffer bufferA19(data_readRegA, registers[19], readRegisterA[19]);
	tristate_buffer bufferB19(data_readRegB, registers[19], readRegisterB[19]);

	and gate20(write[20], write_en[20], ctrl_writeEnable);
	register32 reg20(registers[20], data_writeReg, clock, write[20], ctrl_reset);
	tristate_buffer bufferA20(data_readRegA, registers[20], readRegisterA[20]);
	tristate_buffer bufferB20(data_readRegB, registers[20], readRegisterB[20]);

	and gate21(write[21], write_en[21], ctrl_writeEnable);
	register32 reg21(registers[21], data_writeReg, clock, write[21], ctrl_reset);
	tristate_buffer bufferA21(data_readRegA, registers[21], readRegisterA[21]);
	tristate_buffer bufferB21(data_readRegB, registers[21], readRegisterB[21]);

	and gate22(write[22], write_en[22], ctrl_writeEnable);
	register32 reg22(registers[22], data_writeReg, clock, write[22], ctrl_reset);
	tristate_buffer bufferA22(data_readRegA, registers[22], readRegisterA[22]);
	tristate_buffer bufferB22(data_readRegB, registers[22], readRegisterB[22]);

	and gate23(write[23], write_en[23], ctrl_writeEnable);
	register32 reg23(registers[23], data_writeReg, clock, write[23], ctrl_reset);
	tristate_buffer bufferA23(data_readRegA, registers[23], readRegisterA[23]);
	tristate_buffer bufferB23(data_readRegB, registers[23], readRegisterB[23]);

	and gate24(write[24], write_en[24], ctrl_writeEnable);
	register32 reg24(registers[24], data_writeReg, clock, write[24], ctrl_reset);
	tristate_buffer bufferA24(data_readRegA, registers[24], readRegisterA[24]);
	tristate_buffer bufferB24(data_readRegB, registers[24], readRegisterB[24]);

	and gate25(write[25], write_en[25], ctrl_writeEnable);
	register32 reg25(registers[25], data_writeReg, clock, write[25], ctrl_reset);
	tristate_buffer bufferA25(data_readRegA, registers[25], readRegisterA[25]);
	tristate_buffer bufferB25(data_readRegB, registers[25], readRegisterB[25]);

	and gate26(write[26], write_en[26], ctrl_writeEnable);
	register32 reg26(registers[26], data_writeReg, clock, write[26], ctrl_reset);
	tristate_buffer bufferA26(data_readRegA, registers[26], readRegisterA[26]);
	tristate_buffer bufferB26(data_readRegB, registers[26], readRegisterB[26]);

	and gate27(write[27], write_en[27], ctrl_writeEnable);
	register32 reg27(registers[27], data_writeReg, clock, write[27], ctrl_reset);
	tristate_buffer bufferA27(data_readRegA, registers[27], readRegisterA[27]);
	tristate_buffer bufferB27(data_readRegB, registers[27], readRegisterB[27]);

	and gate28(write[28], write_en[28], ctrl_writeEnable);
	register32 reg28(registers[28], data_writeReg, clock, write[28], ctrl_reset);
	tristate_buffer bufferA28(data_readRegA, registers[28], readRegisterA[28]);
	tristate_buffer bufferB28(data_readRegB, registers[28], readRegisterB[28]);

	and gate29(write[29], write_en[29], ctrl_writeEnable);
	register32 reg29(registers[29], data_writeReg, clock, write[29], ctrl_reset);
	tristate_buffer bufferA29(data_readRegA, registers[29], readRegisterA[29]);
	tristate_buffer bufferB29(data_readRegB, registers[29], readRegisterB[29]);

	and gate30(write[30], write_en[30], ctrl_writeEnable);
	register32 reg30(registers[30], data_writeReg, clock, write[30], ctrl_reset);
	tristate_buffer bufferA30(data_readRegA, registers[30], readRegisterA[30]);
	tristate_buffer bufferB30(data_readRegB, registers[30], readRegisterB[30]);

	and gate31(write[31], write_en[31], ctrl_writeEnable);
	register32 reg31(registers[31], data_writeReg, clock, write[31], ctrl_reset);
	tristate_buffer bufferA31(data_readRegA, registers[31], readRegisterA[31]);
	tristate_buffer bufferB31(data_readRegB, registers[31], readRegisterB[31]);
	

endmodule
