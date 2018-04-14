module Up(input logic clock,
			input logic reset_l,
			output logic [31:0] address_exit
			output logic [31:0] memline,
			output logic [31:0] resultULA);


//logic [tamanho] nome 
logic [31:0] address_pc;
logic [31:0] address_exit;
logic [31:0] resultA;
logic [31:0] resultB;
logic [4:0] code25_21;
logic [4:0] code20_16;
logic [31:0] regisA;
logic [31:0] regisB;
logic [15:0] code15_0;
logic [4:0] writeregsult;
logic [31:0] pc_next;
logic [4:0] code31_26;
logic comMemWrite;
logic pc_choosenext;
logic chooseulaA;
logic chooseulaB;
logic comWriteReg;
logic chooseRegDst;
logic comLoadIR;
logic comStoreMem;
logic datawriteline;
logic chooseRegData;
logic selectULAOp;
logic chooseIorD;
logic zeroalert;
logic setpcwrite;
logic setcondpcwrite;
logic loadpc;
logic [31:0] memdata;

and(pccond,zeroalert,setcondpcwrite);
or(loadpc,pccond,setpcwrite);


UnidadeControle UC (.clock(clock),
					.reset(reset_l),
					.OPcode(code31_26),
					.SrcPC(pc_choosenext),
					.ULASrcA(chooseulaA),
					.ULASrcB(chooseulaB),
					.EscReg(comWriteReg),
					.RegDst(chooseRegDst),
					.IREsc(comLoadIR),
					.Mem2Reg(chooseRegData),
					.WriteMem(comMemWrite),		//read se for 0, write se for 1
					.StoreMem(comStoreMem),
					.ULAOp(selectULAOp),
					.IorD(chooseIorD),
					.PCWri(setpcwrite),
					.PCWriCond(setcondpcwrite)
					);


Registrador PC (.Clk(clock),
				.Entrada(pc_next),
				.Saida(address_pc),
				.Reset(reset_l),
				.Load(loadpc) );

Memoria Mem (.Address(address_exit),
				.Clock(clock),
				.Wr(comMemWrite),
				.Datain(resultB),
				.Dataout(memline)
				);
				
Registrador MemReg (.Clk(clock),
					.Entrada(memline),
					.Saida(memdata),
					.Reset(reset_l),
					.Load(comStoreMem)
					);

Instr_Reg RegInstrucao (.Clk(clock),
						.Reset(reset_l),
						.Load_ir(comLoadIR),
						.Entrada(memline),
						.Instr31_26(code31_26),
						.Instr25_21(code25_21),
						.Instr20_16(code20_16),
						.Instr15_0(code15_0)
						);

Banco_Reg BancoRegs (.Clk(clock),
					.Reset(reset_l),
					.RegWrite(comWriteReg),
					.ReadReg1(code25_21),
					.ReadReg2(code20_16),
					.WriteReg(writeregsult),
					.WriteData(),
					.ReadData1(regisA),
					.ReadData2(regisB)
					);

Multiplex MuxIorD (.f(address_exit),
					.a(address_pc),
					.b(),
					.sel(chooseIorD)
					);

Multiplex RegDst (.f(writeregsult),
					.a(code20_16),
					.b(code15_0[15:11]),
					.sel(chooseRegDst)
					);
					
Multiplex Mem2Reg (.f(datawriteline),
					.a(),
					.b(memdata),
					.sel(chooseRegData)
					);

Multiplex MuxSrcA (.f(resultA),
					.a(address_pc),
					.b(regisA),
					.sel(chooseulaA)
					);

Multiplex2bit MuxSrcB (.f(resultB),
						.a(regisB),
						.b(32'b00000000000000000000000000000100),
						.c(),
						.d(),
						.sel(chooseulaB)
						);

Multiplex2bit MuxSrcPC (.f(pc_next),
						.a(resultULA),
						.b(),
						.c(),
						.d(),
						.sel(pc_choosenext)
						);
		
Ula32 ULA (.A(resultA),
			.B(resultB),
			.Seletor(selectULAOp),
			.S(resultULA),
			.Overflow(),
			.Negativo(),
			.z(zeroalert),
			.Igual(),
			.Maior(),
			.Menor()
			);


endmodule:Up