module Up(input logic clock,
			input logic reset_l,
			output logic [31:0] Address,
			output logic [31:0] MemData,
			output logic [31:0] Alu,
			output logic [31:0] resultB, //resultado de B
			output logic [31:0] writeDataMem,
			output logic [31:0] PC,
			output logic [31:0] WriteDataReg,
			output logic [4:0] WriteRegister,
			output logic wr,
			output logic RegWrite,
			output logic IRWrite,
			output logic [31:0] AluOut,
			output logic [5:0] State,
			output logic [31:0] Reg_Desloc
			);


//logic [tamanho] nome 
logic [31:0] resultA;
logic [4:0] code25_21;
logic [4:0] code20_16;
logic [31:0] regisA;
logic [31:0] regisB;
logic [15:0] code15_0;
logic [31:0] pc_next;
logic [5:0] code31_26;
logic [2:0] pc_choosenext;
logic chooseulaA;
logic [1:0] chooseulaB;
logic chooseRegDst;
logic comStoreMem;
logic datawriteline;
logic [2:0]chooseRegData;
logic [2:0] selectULAOp;
logic chooseIorD;
logic zeroalert;
logic setpcwrite;
logic setcondpcwrite;
logic loadpc;
logic [31:0] MDR;
logic comALUOut;
logic [31:0] exten31_0;
logic pccond;
logic callOverflow;
logic [31:0] luishift;
logic [31:0] regAout;
logic [31:0] regBout;
logic comRegA;
logic comRegB;
logic WriteEPC;
logic [31:0] MDRByte;
logic [31:0] MDRHalf;
logic [31:0] addrHalf;
logic [31:0] addrByte;
logic [1:0] selwrmem;
logic [31:0] MemDataExt;
logic [2:0] setDesloc;
logic [4:0] lineshamt;
logic [31:0] DeslocInst;
logic [31:0] DeslocSinal;
logic [31:0] extrapcnext;
logic sinalMenor;

and g1(pccond,zeroalert,setcondpcwrite);
xor g2(loadpc,pccond,setpcwrite);

always @(code25_21)
begin
extrapcnext[31:28] = PC[31:28];
extrapcnext[27:26] =  2'b00;
extrapcnext[25:21] = code25_21;
extrapcnext[20:16] = code20_16;
extrapcnext[15:0] = code15_0;
end

always@(extrapcnext)
begin
DeslocInst = extrapcnext<<2'b10;
end

always@(exten31_0)
begin
DeslocSinal = exten31_0<<2'b10;
end

always@(code15_0)
begin
luishift = code15_0<<5'b10000;
end

UnidadeControle UC (.clock(clock),
					.reset(reset_l),
					.sinalOverflow(callOverflow),
					.OPcode(code31_26),
					.Funct(code15_0[5:0]),
					.SrcPC(pc_choosenext),
					.ULASrcA(chooseulaA),
					.ULASrcB(chooseulaB),
					.EscReg(RegWrite),
					.RegDst(chooseRegDst),
					.IREsc(IRWrite),
					.Mem2Reg(chooseRegData),
					.WriteMem(wr),		//read se for 0, write se for 1
					.SelMemWrite(selwrmem),
					.StoreMem(comStoreMem),
					.ULAOp(selectULAOp),
					.IorD(chooseIorD),
					.PCWri(setpcwrite),
					.PCWriCond(setcondpcwrite),
					.ALUOutCtrl(comALUOut),
					.RegAload(comRegA),
					.RegBload(comRegB),
					.setShift(setDesloc),
					.EPCWrite(WriteEPC),
					.stateout(State)
					);


Registrador RegPC (.Clk(clock),
				.Entrada(pc_next),
				.Saida(PC),
				.Reset(reset_l),
				.Load(loadpc) );

Memoria Mem (.Address(Address),
				.Clock(clock),
				.Wr(wr),
				.Datain(writeDataMem),
				.Dataout(MemData)
				);
				
Registrador MemReg (.Clk(clock),
					.Entrada(MemData),
					.Saida(MDR),
					.Reset(reset_l),
					.Load(comStoreMem)
					);

Instr_Reg RegInstrucao (.Clk(clock),
						.Reset(reset_l),
						.Load_ir(IRWrite),
						.Entrada(MemData),
						.Instr31_26(code31_26),
						.Instr25_21(code25_21),
						.Instr20_16(code20_16),
						.Instr15_0(code15_0)
						);

Banco_Reg BancoRegs (.Clk(clock),
					.Reset(reset_l),
					.RegWrite(RegWrite),
					.ReadReg1(code25_21),
					.ReadReg2(code20_16),
					.WriteReg(WriteRegister),
					.WriteData(WriteDataReg),
					.ReadData1(regisA),
					.ReadData2(regisB)
					);
					
Registrador A (.Clk(clock),
				.Entrada(regisA),
				.Saida(regAout),
				.Reset(reset_l),
				.Load(comRegA) );

Registrador B (.Clk(clock),
				.Entrada(regisB),
				.Saida(regBout),
				.Reset(reset_l),
				.Load(comRegB) );

Multiplex MuxIorD (.f(Address),
					.a(PC),
					.b(AluOut),
					.sel(chooseIorD)
					);

MultiplexMini RegDst (.f(WriteRegister),
					.a(code20_16),
					.b(code15_0[15:11]),
					.sel(chooseRegDst)
					);
					
Multiplex MuxSrcA (.f(resultA),
					.a(PC),
					.b(regAout),
					.sel(chooseulaA)
					);

Multiplex2bit MuxSrcB (.f(resultB),
						.a(regBout),
						.b(32'b00000000000000000000000000000100),
						.c(exten31_0),
						.d(DeslocSinal),
						.sel(chooseulaB)
						);

Multiplex3bit MuxSrcPC (.h(pc_next),
						.a(Alu),
						.b(AluOut),
						.c(DeslocInst),
						.d(MemDataExt),
						.e(getEPC),  //sel = 100
						.sel(pc_choosenext)
						);
						
Multiplex3bit MuxMem2Reg (.h(WriteDataReg),
							.a(MDR),
							.b(AluOut),
							.c(luishift), //quando LUI, sel = 010.
							.d(MDRByte),
							.e(MDRHalf),
							.f(Reg_Desloc), //quando SHIFT, sel = 101
							.g(sinalMenor), //quando SLT, sel = 110
							.sel(chooseRegData));
		
Ula32 ULA (.A(resultA),
			.B(resultB),
			.Seletor(selectULAOp),
			.S(Alu),
			.Overflow(callOverflow),
			.Negativo(),
			.z(zeroalert),
			.Igual(),
			.Maior(),
			.Menor(sinalMenor)
			);
			
			

Registrador ALUOutReg (.Clk(clock),
					.Entrada(Alu),
					.Saida(AluOut),
					.Reset(reset_l),
					.Load(comALUOut)
					);
					
MuxShiftAmount MuxShamt (.shamt(lineshamt),
				.regA(regAout),
				.code15to0(code15_0)
				);
					
RegDesloc ShiftOp (.Clk(clock),
					.Reset(reset_l),
					.Shift(setDesloc), //recebe o seletor da unidade de controle, tem que dar 'load' por aqui
					.N(lineshamt),
					.Entrada(regBout),
					.Saida(Reg_Desloc)
					);

SignedExtend SinalExtensao (.codein(code15_0),
							.outsigned(exten31_0)
							);

UnsignedExtendExc ExtensaoMemInst (.MemIn(MemData),
								.OutNewInst(MemDataExt),
								.Overflow(callOverflow)
								);

Registrador EPC (.Clk(clock),
					.Entrada(Alu),
					.Saida(),
					.Reset(reset_l),
					.Load(WriteEPC)
					);

UnsExtend8 MDRExt8 (.MemIn(MDR),
			.OutByte(MDRByte)
			);
			
UnsExtend16 MDRExt16 (.MemIn(MDR),
			.OutHalfWord(MDRHalf)
			);
			
AdderMem8 AdderByte (.MemByte(addrByte),
					.MDRrs(MDR),
					.rt(regBout)
					);
					
AdderMem16 AdderHlf (.MemHalf(addrHalf),
					.MDRrs (MDR),
					.rt (regBout)
					);

Multiplex3op MuxMemWri (.f(writeDataMem),
						.a(regBout),
						.b(addrByte),
						.c(addrHalf),
						.sel(selwrmem)
						);
endmodule:Up
