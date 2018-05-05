module UnidadeControle(input logic clock,
			input logic reset,
			input logic sinalOverflow,
			input logic [5:0] OPcode,
			input logic [5:0] Funct,
			output logic [1:0] SrcPC,
			output logic ULASrcA,
			output logic [2:0] ULASrcB,
			output logic EscReg,
			output logic RegDst,
			output logic IREsc,
			output logic [2:0] Mem2Reg,
			output logic WriteMem,
			output logic [1:0] SelMemWrite,
			output logic StoreMem,
			output logic [2:0] ULAOp,
			output logic IorD,
			output logic PCWri,
			output logic PCWriCond,
			output logic ALUOutCtrl,
			output logic [2:0] setShift,
			output logic [5:0] stateout,
			output logic RegAload,
			output logic RegBload,
			output logic EPCWrite
			);
			//output logic stateout);
			
			
			enum logic [5:0] {RESET /* 0 */, 
			BUSCA/*1*/, WAIT/*2*/, WRITE/*3*/, DECODE/*4*/, LORS/*5*/, //LORS = LOAD OR STORE (byte, halfword, word)
			LBU/*6*/, LBUMEM/*7*/, LBUWBS/*8*/, LHU/*9*/, LHUMEM/*10*/,
			LHUWBS/*11*/, LW/*12*/, SW/*13*/, WBS/*14*/, SB/*15*/,
			SBMEM/*16*/, SBWRITE/*17*/, SH/*18*/, SHMEM/*19*/, SHWRITE/*20*/, 
			ADDLOAD/*21*/, ADD/*22*/, ADDU/*23*/, AND/*24*/, SUB/*25*/,
			SUBU/*26*/, ADDComp/*27*/, XOR/*28*/, BREAK/*29*/, NOP/*30*/, 
			JUMP/*31*/, JR/*32*/, BNE/*33*/, BEQ/*34*/, LUI/*35*/, 
			WAITLW/*36*/, OVERFLOW/*37*/, SLL /*38*/, SLLEND /*39*/, SLLV /*40*/,
			SLLVEND/*41*/, SRA /*42*/, SRAEND /*43*/, SRAV/*44*/, SRAVEND /*45*/,
			SRL /*46*/, SRLEND /*47*/, SLT /*48*/, RTE /*49*/} state, nextState;
			assign stateout = state;
			
always_ff@(negedge clock, posedge reset)
  begin

   if (reset) begin
       state <= RESET;
   end

   else begin
     state <= nextState;

   end

  end

always_comb
case(state)
	RESET: begin
	SrcPC = 2'b000;
	ULASrcA = 1'b0;
	ULASrcB = 2'b00;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 3'b000;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b000;
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000; //setShift 000 = load
	EPCWrite = 1'b0;
	nextState = BUSCA;
	end
	BUSCA:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b0;
	ULASrcB = 2'b01; // carrega o 4 
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 3'b000;
	WriteMem = 1'b0; //sempre leia a memoria quando = 0, escrever quando = 1
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b001; //ADD
	IorD = 1'b0;
	PCWri = 1'b1;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
	nextState = WAIT;
	end
	WAIT:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b0;
	ULASrcB = 2'b01;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 3'b000;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b000;
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
	nextState = WRITE;
	end
	WRITE:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b0;
	ULASrcB = 2'b01;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b1;
	Mem2Reg = 3'b000;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b001;
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
	nextState = DECODE;
	end
	DECODE:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b0;
	ULASrcB = 2'b11;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 3'b000;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b001;  //ADD
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b1;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
		case(OPcode)
		6'b000010:begin
		 nextState = JUMP;
		end
		6'b000100:begin
		 nextState = BEQ;
		end
		6'b000101:begin
		 nextState = BNE;
		end
		6'b001111:begin
		 nextState = LUI;
		end
		6'b100011:begin // rever depois big endian etc
		 nextState = LORS;
		end
		6'b101011:begin // rever depois big endian etc
		 nextState = LORS;
		end
		6'b100100:begin
		nextState = LORS;
		end
		6'b100101:begin
		nextState = LORS;
		end
		6'b101000:begin
		nextState = LORS;
		end
		6'b101001:begin
		nextState = LORS;
		end
		
		//Operacoes do tipo R
		6'b000000:begin // rever depois big endian etc
		 nextState = ADDLOAD;
        end
		
		default: nextState = NOP; //excecao opcode inexistente
		endcase
	end
	
	LORS:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b10;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 3'b000;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b001;  //ADD
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b1;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
		case(OPcode)
		6'b101011:begin
		nextState = SW;
		end
		6'b100011:begin
		nextState = LW;
		end
		6'b100100:begin
		nextState = LBU;
		end
		6'b100101:begin
		nextState = LHU;
		end
		6'b101000:begin
		nextState = SB;
		end
		6'b101001:begin
		nextState = SH;
		end
		6'b00000:begin
		nextState = RTE;
		end
		default: nextState = NOP;
		endcase
	end
	
	LBU:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b10;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 3'b000;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b001;  //ADD
	IorD = 1'b1;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
	nextState = LBUMEM; 
	end
	LBUMEM:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b10;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 3'b000;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b1;
	ULAOp = 3'b001;  //ADD
	IorD = 1'b1;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
	nextState = LBUWBS;
	end
	LBUWBS:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b10;
	EscReg = 1'b1;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 3'b011; //MDRByte
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b1;
	ULAOp = 3'b001;  //ADD
	IorD = 1'b1;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
	nextState = BUSCA;
	end
	LHU:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b10;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 3'b000;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b001;  //ADD
	IorD = 1'b1;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
	nextState = LHUMEM; 
	end
	LHUMEM:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b10;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 3'b000;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b1;
	ULAOp = 3'b001;  //ADD
	IorD = 1'b1;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
	nextState = LHUWBS;
	end
	LHUWBS:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b10;
	EscReg = 1'b1;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 3'b100; //MDRHalf
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b1;
	ULAOp = 3'b001;  //ADD
	IorD = 1'b1;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
	nextState = BUSCA;
	end
	LW:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b10;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 3'b000;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b001;  //ADD
	IorD = 1'b1;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
	nextState = WAITLW;
	end
	
	WAITLW:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b10;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 3'b000;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b001;  //ADD
	IorD = 1'b1;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b1;
	RegAload = 1'b1;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
	nextState = WBS;
	end
	
	WBS:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b10;
	EscReg = 1'b1;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 3'b001;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b1;
	ULAOp = 3'b001;  //ADD
	IorD = 1'b1;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
	nextState = BUSCA;
	end
	SB:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b10;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 3'b000;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b001;  //ADD
	IorD = 1'b1;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
	nextState = SBMEM; 
	end
	SBMEM:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b10;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 3'b000;
	WriteMem = 1'b0;
	SelMemWrite = 2'b01;
	StoreMem = 1'b1;
	ULAOp = 3'b001;  //ADD
	IorD = 1'b1;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
	nextState = SBWRITE;
	end
	SBWRITE:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b10;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 3'b000;
	WriteMem = 1'b1;
	SelMemWrite = 2'b01; //addrByte
	StoreMem = 1'b0;
	ULAOp = 3'b001;  //ADD
	IorD = 1'b1;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
	nextState = BUSCA;
	end
	
	SH:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b10;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 3'b000;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b001;  //ADD
	IorD = 1'b1;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
	nextState = SHMEM; 
	end
	SHMEM:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b10;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 3'b000;
	WriteMem = 1'b0;
	SelMemWrite = 2'b01;
	StoreMem = 1'b1;
	ULAOp = 3'b001;  //ADD
	IorD = 1'b1;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
	nextState = SHWRITE;
	end
	SHWRITE:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b10;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 3'b000;
	WriteMem = 1'b1;
	SelMemWrite = 2'b10; //addrHalf
	StoreMem = 1'b0;
	ULAOp = 3'b001;  //ADD
	IorD = 1'b1;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
	nextState = BUSCA;
	end
	SW:begin
    SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b00;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b1;
	Mem2Reg = 3'b000;
	WriteMem = 1'b1;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b001;  //ADD
	IorD = 1'b1;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
	nextState = BUSCA;
	end
	
	ADDLOAD:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b00;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 3'b000;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b000;  //LOAD
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	RegAload = 1'b1;
	RegBload = 1'b1;
	setShift = 3'b000;
	EPCWrite = 1'b0;
	ALUOutCtrl = 1'b0;
	case(Funct)
			6'b100000:begin
			nextState = ADD;
			end
			6'b100010:begin
			nextState = SUB;
			end
			6'b100100:begin
			nextState = AND;
			end
			6'b100110:begin
			nextState = XOR;
			end
			6'b001101:begin
			nextState = BREAK;
			end
			6'b000000:begin
			nextState = SLL;
			end
			6'b000100:begin
			nextState = SLLV;
			end
			6'b000011:begin
			nextState = SRA;
			end
			6'b000111:begin
			nextState = SRAV;
			end
			6'b000010:begin
			nextState = SRL;
			end
			6'b001000:begin
			nextState = JR;
			end
			6'b101010:begin
			nextState = SLT;
			end
			default: nextState = NOP; //excecao opcode inexistente
			endcase
	end
	
	ADD:begin
    SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b00;
	EscReg = 1'b0;
	RegDst = 1'b1;
	IREsc = 1'b0;
	Mem2Reg = 3'b001;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b001;  //ADD
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b1;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
		case(sinalOverflow)
		1'b0:begin
		nextState = ADDComp;
		end
		1'b1:begin
		nextState = OVERFLOW;
		end
		endcase
	end
	
	ADDU:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b00;
	EscReg = 1'b0;
	RegDst = 1'b1;
	IREsc = 1'b0;
	Mem2Reg = 3'b001;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b001;  //ADD
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b1;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
	nextState = ADDComp;
	end
	
	SUB:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b00;
	EscReg = 1'b0;
	RegDst = 1'b1;
	IREsc = 1'b0;
	Mem2Reg = 3'b001;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b010;  //SUB
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b1;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
	case(sinalOverflow)
		1'b0:begin
		nextState = ADDComp;
		end
		1'b1:begin
		nextState = OVERFLOW;
		end
		endcase
	end
	
	SUBU:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b00;
	EscReg = 1'b0;
	RegDst = 1'b1;
	IREsc = 1'b0;
	Mem2Reg = 3'b001;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b010;  //SUB
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b1;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
	nextState = ADDComp;
	end
	
	AND: begin
    SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b00;
	EscReg = 1'b1;
	RegDst = 1'b1;
	IREsc = 1'b0;
	Mem2Reg = 3'b001;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b011;  //AND
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b1;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
	nextState = ADDComp;
	end
	
	ADDComp: begin
    SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b00;
	EscReg = 1'b1;
	RegDst = 1'b1;
	IREsc = 1'b0;
	Mem2Reg = 3'b001;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b001;  //ADD
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
	nextState = BUSCA;
	end
	XOR: begin
	SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b00;
	EscReg = 1'b1;
	RegDst = 1'b1;
	IREsc = 1'b0;
	Mem2Reg = 3'b101;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b110;  //XOR
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b1;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
	nextState = ADDComp;
	end
	SLL:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b00;
	EscReg = 1'b0;
	RegDst = 1'b1;
	IREsc = 1'b0;
	Mem2Reg = 3'b101;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b000;
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b001;  //carrega o registrador de deslocamento
	EPCWrite = 1'b0;
	nextState = SLLEND;
	end
	SLLEND:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b00;
	EscReg = 1'b1;
	RegDst = 1'b1;
	IREsc = 1'b0;
	Mem2Reg = 3'b101; //pega o resultado do shift
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b000;
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b010; //realiza deslocamento a esquerda logico
	EPCWrite = 1'b0;
	nextState = BUSCA;
	end
	SLLV:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b00;
	EscReg = 1'b0;
	RegDst = 1'b1;
	IREsc = 1'b0;
	Mem2Reg = 3'b101;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b000;
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b001;  //setShift 001 = LOAD B
	EPCWrite = 1'b0;
	nextState = SLLVEND;
	end
	SLLVEND:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b00;
	EscReg = 1'b1;
	RegDst = 1'b1;
	IREsc = 1'b0;
	Mem2Reg = 3'b101;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b000;
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b010;
	EPCWrite = 1'b0;
	nextState = BUSCA;
	end
	SRA:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b00;
	EscReg = 1'b0;
	RegDst = 1'b1;
	IREsc = 1'b0;
	Mem2Reg = 3'b101;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b000;
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b001; //carrega o registrador
	EPCWrite = 1'b0;
	nextState = SRAEND;
	end
	SRAEND:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b00;
	EscReg = 1'b1;
	RegDst = 1'b1;
	IREsc = 1'b0;
	Mem2Reg = 3'b101;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b000;
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b100; //shift a direita aritmetico 
	EPCWrite = 1'b0;
	nextState = BUSCA;
	end
	SRAV:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b00;
	EscReg = 1'b0;
	RegDst = 1'b1;
	IREsc = 1'b0;
	Mem2Reg = 3'b101;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b000;
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b001; //carrega o registrador
	EPCWrite = 1'b0;
	nextState = SRAVEND;
	end
	SRAVEND:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b00;
	EscReg = 1'b1;
	RegDst = 1'b1;
	IREsc = 1'b0;
	Mem2Reg = 3'b101;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b000;
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b100; //shift a direita aritmetico
	EPCWrite = 1'b0;
	nextState = BUSCA;
	end
	SRL:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b00;
	EscReg = 1'b0;
	RegDst = 1'b1;
	IREsc = 1'b0;
	Mem2Reg = 3'b101;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b000;
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b001; //carrega o registrador
	EPCWrite = 1'b0;
	nextState = SRLEND;
	end
	SRLEND:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b00;
	EscReg = 1'b1;
	RegDst = 1'b1;
	IREsc = 1'b0;
	Mem2Reg = 3'b101;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b000;
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b011;  //shift a direita logico
	EPCWrite = 1'b0;
	nextState = BUSCA;
	end
	SLT:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b00;
	EscReg = 1'b1;
	RegDst = 1'b1;
	IREsc = 1'b0;
	Mem2Reg = 3'b110; //pega o sinal de menor que sair da ula
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b001; //o teste booleano ocorre na ULA durante outras operações
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
	nextState = BUSCA;
	end
	BREAK:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b0;
	ULASrcB = 2'b01;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 3'b000;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b010;  //SUB
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0; //precisa de EPC?
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
	nextState = BREAK;
	end
	NOP:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b0;
	ULASrcB = 2'b00;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 3'b000;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b010;  //SUB
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0; //precisa de EPC?
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
	nextState = BUSCA;
	end
	
	JUMP:begin
	SrcPC = 2'b010;
	ULASrcA = 1'b0;
	ULASrcB = 2'b01;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 3'b000;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b000;  //LOAD
	IorD = 1'b0;
	PCWri = 1'b1;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b1; //precisa de EPC?
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
	nextState = BUSCA;
	end
	
	JR:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b1;
	ULASrcB = 2'b01;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 2'b00;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b000;  //LOAD, a função load simplemente passa o valor do MuxSrcA
	IorD = 1'b0;
	PCWri = 1'b1;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0; //precisa de EPC?
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
	nextState = BUSCA;
	end
	
	BEQ:begin
	SrcPC = 2'b001;
	ULASrcA = 1'b1;
	ULASrcB = 2'b00;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 3'b000;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b010;  //SUB
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b1;
	ALUOutCtrl = 1'b0; //precisa de EPC?
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
	nextState = BUSCA;
	end
	BNE:begin
	SrcPC = 2'b001;
	ULASrcA = 1'b1;
	ULASrcB = 2'b00;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 3'b000;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b010;  //SUB
	IorD = 1'b0;
	PCWri = 1'b1;
	PCWriCond = 1'b1;
	ALUOutCtrl = 1'b0; //precisa de EPC?
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
	nextState = BUSCA;
	end
	LUI:begin
	SrcPC = 2'b000;
	ULASrcA = 1'b0;
	ULASrcB = 2'b01;
	EscReg = 1'b1;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 3'b010;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b1;
	ULAOp = 3'b001; //ADD
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
	nextState = BUSCA;
	end
	OVERFLOW:begin
	SrcPC = 2'b011;
	ULASrcA = 1'b0;
	ULASrcB = 2'b01;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 3'b001;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b010; //SUB
	IorD = 1'b0;
	PCWri = 1'b1;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b1;
	nextState = BUSCA;
	end
	RTE:begin
	SrcPC = 2'b100;
	ULASrcA = 1'b0;
	ULASrcB = 2'b01;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 3'b000;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b000; //LOAD
	IorD = 1'b0;
	PCWri = 1'b1;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	RegAload = 1'b0;
	RegBload = 1'b0;
	setShift = 3'b000;
	EPCWrite = 1'b0;
	nextState = BUSCA;
	end
endcase
endmodule:UnidadeControle