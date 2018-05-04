module UnidadeControle(input logic clock,
			input logic reset,
			input logic sinalOverflow,
			input logic [5:0] OPcode,
			input logic [5:0] Funct,
			output logic [1:0] SrcPC,
			output logic ULASrcA,
			output logic [1:0] ULASrcB,
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
			output logic [4:0] stateout,
			output logic RegAload,
			output logic RegBload,
			output logic [2:0] shiftSel,
			output logic EPCWrite
			);
			//output logic stateout);
			
			
			enum logic [5:0] {RESET, 
			BUSCA, WAIT, WRITE, DECODE, LWorSW, 
			LBU, LBUMEM, LBUWBS, LHU, LHUMEM,
			LHUWBS, LW, SW, WBS, SB,
			SBMEM, SBWRITE, SH, SHMEM, SHWRITE, 
			ADDLOAD, ADD, ADDU, AND, SUB,
			ADDComp, XOR, BREAK, NOP, STOPPC,
			JUMP, JR, BNE, BEQ, LUI,
			WAITLW, OVERFLOW} state, nextState;
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
	SrcPC = 2'b00;
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
	shiftSel = 3'b000;
	EPCWrite = 1'b0;
	nextState = BUSCA;
	end
	BUSCA:begin
	SrcPC = 2'b00;
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
	shiftSel = 3'b000;
	EPCWrite = 1'b0;
	nextState = WAIT;
	end
	WAIT:begin
	SrcPC = 2'b00;
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
	shiftSel = 3'b000;
	EPCWrite = 1'b0;
	nextState = WRITE;
	end
	WRITE:begin
	SrcPC = 2'b00;
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
	shiftSel = 3'b000;
	EPCWrite = 1'b0;
	nextState = DECODE;
	end
	DECODE:begin
	SrcPC = 2'b00;
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
	shiftSel = 3'b000;
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
		 nextState = LWorSW;
		end
		6'b101011:begin // rever depois big endian etc
		 nextState = LWorSW;
		end
		6'b100100:begin
		nextState = LWorSW;
		end
		6'b100101:begin
		nextState = LWorSW;
		end
		6'b101000:begin
		nextState = LWorSW;
		end
		6'b101001:begin
		nextState = LWorSW;
		end
		
		//Operacoes do tipo R
		6'b000000:begin // rever depois big endian etc
		 nextState = ADDLOAD;
        end
		
		default: nextState = NOP; //excecao opcode inexistente
		endcase
	end
	
	LWorSW:begin
	SrcPC = 2'b00;
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
	shiftSel = 3'b000;
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
		default: nextState = NOP;
		endcase
	end
	
	LBU:begin
	SrcPC = 2'b00;
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
	shiftSel = 3'b000;
	EPCWrite = 1'b0;
	nextState = LBUMEM; 
	end
	LBUMEM:begin
	SrcPC = 2'b00;
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
	shiftSel = 3'b000;
	EPCWrite = 1'b0;
	nextState = LBUWBS;
	end
	LBUWBS:begin
	SrcPC = 2'b00;
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
	shiftSel = 3'b000;
	EPCWrite = 1'b0;
	nextState = BUSCA;
	end
	LHU:begin
	SrcPC = 2'b00;
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
	shiftSel = 3'b000;
	EPCWrite = 1'b0;
	nextState = LHUMEM; 
	end
	LHUMEM:begin
	SrcPC = 2'b00;
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
	shiftSel = 3'b000;
	EPCWrite = 1'b0;
	nextState = LHUWBS;
	end
	LHUWBS:begin
	SrcPC = 2'b00;
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
	shiftSel = 3'b000;
	EPCWrite = 1'b0;
	nextState = BUSCA;
	end
	LW:begin
	SrcPC = 2'b00;
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
	shiftSel = 3'b000;
	EPCWrite = 1'b0;
	nextState = WAITLW;
	end
	
	WAITLW:begin
	SrcPC = 2'b00;
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
	shiftSel = 3'b000;
	EPCWrite = 1'b0;
	nextState = WBS;
	end
	
	WBS:begin
	SrcPC = 2'b00;
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
	shiftSel = 3'b000;
	EPCWrite = 1'b0;
	nextState = BUSCA;
	end
	SB:begin
	SrcPC = 2'b00;
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
	shiftSel = 3'b000;
	EPCWrite = 1'b0;
	nextState = SBMEM; 
	end
	SBMEM:begin
	SrcPC = 2'b00;
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
	shiftSel = 3'b000;
	EPCWrite = 1'b0;
	nextState = SBWRITE;
	end
	SBWRITE:begin
	SrcPC = 2'b00;
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
	shiftSel = 3'b000;
	EPCWrite = 1'b0;
	nextState = BUSCA;
	end
	
	SH:begin
	SrcPC = 2'b00;
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
	shiftSel = 3'b000;
	EPCWrite = 1'b0;
	nextState = SHMEM; 
	end
	SHMEM:begin
	SrcPC = 2'b00;
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
	shiftSel = 3'b000;
	EPCWrite = 1'b0;
	nextState = SHWRITE;
	end
	SHWRITE:begin
	SrcPC = 2'b00;
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
	shiftSel = 3'b000;
	EPCWrite = 1'b0;
	nextState = BUSCA;
	end
	SW:begin
    SrcPC = 2'b00;
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
	shiftSel = 3'b000;
	EPCWrite = 1'b0;
	nextState = BUSCA;
	end
	
	ADDLOAD:begin
	SrcPC = 2'b00;
	ULASrcA = 1'b1;
	ULASrcB = 2'b00;
	EscReg = 1'b0;
	RegDst = 1'b1;
	IREsc = 1'b0;
	Mem2Reg = 3'b001;
	WriteMem = 1'b0;
	SelMemWrite = 2'b00;
	StoreMem = 1'b0;
	ULAOp = 3'b000;  //LOAD
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	RegAload = 1'b1;
	RegBload = 1'b1;
	shiftSel = 3'b000;
	EPCWrite = 1'b0;
	ALUOutCtrl = 1'b1;
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
			nextState = NOP;
			end
			default: nextState = NOP; //excecao opcode inexistente
			endcase
	end
	
	ADD:begin
    SrcPC = 2'b00;
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
	shiftSel = 3'b000;
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
	SrcPC = 2'b00;
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
	shiftSel = 3'b000;
	EPCWrite = 1'b0;
	nextState = ADDComp;
	end
	
	SUB:begin
	SrcPC = 2'b00;
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
	shiftSel = 3'b000;
	EPCWrite = 1'b0;
	nextState = ADDComp;
	end
	
	AND: begin
    SrcPC = 2'b00;
	ULASrcA = 1'b1;
	ULASrcB = 2'b00;
	EscReg = 1'b0;
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
	shiftSel = 3'b000;
	EPCWrite = 1'b0;
	nextState = ADDComp;
	end
	
	ADDComp: begin
    SrcPC = 2'b00;
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
	shiftSel = 3'b000;
	EPCWrite = 1'b0;
	nextState = BUSCA;
	end
	XOR: begin
	SrcPC = 2'b00;
	ULASrcA = 1'b1;
	ULASrcB = 2'b00;
	EscReg = 1'b0;
	RegDst = 1'b1;
	IREsc = 1'b0;
	Mem2Reg = 3'b001;
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
	shiftSel = 3'b000;
	EPCWrite = 1'b0;
	nextState = ADDComp;
	end
	BREAK:begin
	SrcPC = 2'b00;
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
	shiftSel = 3'b000;
	EPCWrite = 1'b0;
	nextState = BREAK;
	end
	NOP:begin
	SrcPC = 2'b00;
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
	shiftSel = 3'b000;
	EPCWrite = 1'b0;
	nextState = BUSCA;
	end
	STOPPC:begin
	SrcPC = 2'b00;
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
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0; //precisa de EPC?
	RegAload = 1'b0;
	RegBload = 1'b0;
	shiftSel = 3'b000;
	EPCWrite = 1'b0;
	nextState = BUSCA;
	end
	
	JUMP:begin
	SrcPC = 2'b10;
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
	shiftSel = 3'b000;
	EPCWrite = 1'b0;
	nextState = BUSCA;
	end
	JR:begin
	SrcPC = 2'b10;
	ULASrcA = 1'b0;
	ULASrcB = 2'b01;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 2'b00;
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
	shiftSel = 3'b000;
	EPCWrite = 1'b0;
	nextState = BUSCA;
	end
	
	BEQ:begin
	SrcPC = 2'b01;
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
	shiftSel = 3'b000;
	EPCWrite = 1'b0;
	nextState = BUSCA;
	end
	BNE:begin
	SrcPC = 2'b01;
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
	shiftSel = 3'b000;
	EPCWrite = 1'b0;
	nextState = BUSCA;
	end
	LUI:begin
	SrcPC = 2'b00;
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
	shiftSel = 3'b000;
	EPCWrite = 1'b0;
	nextState = BUSCA;
	end
	OVERFLOW:begin
	SrcPC = 2'b11;
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
	shiftSel = 3'b000;
	EPCWrite = 1'b1;
	nextState = BUSCA;
	end
	
endcase
endmodule:UnidadeControle