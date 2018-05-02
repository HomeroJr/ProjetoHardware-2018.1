module Up(input logic clock,
			input logic reset_l,
			output logic [31:0] Address,
			output logic [31:0] MemData,
			output logic [31:0] Alu,
			output logic [31:0] WriteDataMem, //resultado de B
			output logic [31:0] extrapcnext,
			output logic [31:0] PC,
			output logic [31:0] WriteDataReg,
			output logic [4:0] WriteRegister,
			output logic [31:0] DeslocInst,
			output logic [31:0] DeslocSinal,
			output logic wr,
			output logic RegWrite,
			output logic IRWrite,
			output logic [31:0] AluOut,
			output logic [4:0] State
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
logic [1:0] pc_choosenext;
logic chooseulaA;
logic [1:0] chooseulaB;
logic chooseRegDst;
logic comStoreMem;
logic datawriteline;
logic [1:0]chooseRegData;
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

and g1(pccond,zeroalert,setcondpcwrite);
xor g2(loadpc,pccond,setpcwrite);

always @(code25_21)
begin
extrapcnext[31:30] = 2'b00;
extrapcnext[29:26] =  PC[31:28];
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
					.StoreMem(comStoreMem),
					.ULAOp(selectULAOp),
					.IorD(chooseIorD),
					.PCWri(setpcwrite),
					.PCWriCond(setcondpcwrite),
					.ALUOutCtrl(comALUOut),
					.RegAload(comRegA),
					.RegBload(comRegB),
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
				.Datain(WriteDataMem),
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

Multiplex2bit MuxSrcB (.f(WriteDataMem),
						.a(regBout),
						.b(32'b00000000000000000000000000000100),
						.c(exten31_0),
						.d(DeslocSinal),
						.sel(chooseulaB)
						);

Multiplex2bit MuxSrcPC (.f(pc_next),
						.a(Alu),
						.b(AluOut),
						.c(DeslocInst),
						.d(MemDataExt),
						.sel(pc_choosenext)
						);
						
Multiplex3op MuxMem2Reg (.f(WriteDataReg),
							.a(MDR),
							.b(AluOut),
							.c(luishift), //quando LUI, sel = 10.
							.sel(chooseRegData));
		
Ula32 ULA (.A(resultA),
			.B(WriteDataMem),
			.Seletor(selectULAOp),
			.S(Alu),
			.Overflow(callOverflow),
			.Negativo(),
			.z(zeroalert),
			.Igual(),
			.Maior(),
			.Menor()
			);

Registrador ALUOut (.Clk(clock),
					.Entrada(Alu),
					.Saida(AluOut),
					.Reset(reset_l),
					.Load(comALUOut)
					);

SignedExtend SinalExtensao (.codein(code15_0),
							.outsigned(exten31_0)
							);

UnsignedExtend ExtensaoMemInst (.MemIn(MemData),
								.OutNewInst(MemDataExt),
								.Overflow()
								);

Registrador EPC (.Clk(clock),
					.Entrada(Alu),
					.Saida(),
					.Reset(reset_l),
					.Load(WriteEPC)
					);

endmodule:Up
