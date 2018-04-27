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
			output logic [1:0] Mem2Reg,
			output logic WriteMem,
			output logic StoreMem,
			output logic [2:0] ULAOp,
			output logic IorD,
			output logic PCWri,
			output logic PCWriCond,
			output logic ALUOutCtrl,
			output logic [4:0]stateout
			);
			//output logic stateout);
			
			
			enum logic [4:0] {RESET, 
			BUSCA, WAIT, WRITE, DECODE, LWorSW, 
			LW, SW, WBS, ADD, AND, 
			SUB, ADDComp, XOR, BREAK, NOP, 
			STOPPC, JUMP, BNE, BEQ, LUI,
			WAITLW} state, nextState;
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
	Mem2Reg = 2'b00;
	WriteMem = 1'b0;
	StoreMem = 1'b0;
	ULAOp = 3'b000;
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	nextState = BUSCA;
	end
	BUSCA:begin
	SrcPC = 2'b00;
	ULASrcA = 1'b0;
	ULASrcB = 2'b01; // carrega o 4 
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 2'b00;
	WriteMem = 1'b0; //sempre leia a memoria quando = 0, escrever quando = 1
	StoreMem = 1'b0;
	ULAOp = 3'b001; //ADD
	IorD = 1'b0;
	PCWri = 1'b1;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	nextState = WAIT;
	end
	WAIT:begin
	SrcPC = 2'b00;
	ULASrcA = 1'b0;
	ULASrcB = 2'b01;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 2'b00;
	WriteMem = 1'b0;
	StoreMem = 1'b0;
	ULAOp = 3'b000;
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	nextState = WRITE;
	end
	WRITE:begin
	SrcPC = 2'b00;
	ULASrcA = 1'b0;
	ULASrcB = 2'b01;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b1;
	Mem2Reg = 2'b00;
	WriteMem = 1'b0;
	StoreMem = 1'b0;
	ULAOp = 3'b001;
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	nextState = DECODE;
	end
	DECODE:begin
	SrcPC = 2'b00;
	ULASrcA = 1'b0;
	ULASrcB = 2'b11;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 2'b00;
	WriteMem = 1'b0;
	StoreMem = 1'b0;
	ULAOp = 3'b001;  //ADD
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b1;
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
		
		//Operacoes do tipo R
		
		6'b000000:begin // rever depois big endian etc
		 
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
	Mem2Reg = 2'b00;
	WriteMem = 1'b0;
	StoreMem = 1'b0;
	ULAOp = 3'b001;  //ADD
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b1;
	if (OPcode == 6'b101011)
	nextState = SW;
	else
	nextState = LW;
	end
	
	LW:begin
	SrcPC = 2'b00;
	ULASrcA = 1'b1;
	ULASrcB = 2'b10;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 2'b00;
	WriteMem = 1'b0;
	StoreMem = 1'b0;
	ULAOp = 3'b001;  //ADD
	IorD = 1'b1;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b1;
	nextState = WAITLW;
	end
	
	WAITLW:begin
	SrcPC = 2'b00;
	ULASrcA = 1'b1;
	ULASrcB = 2'b10;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 2'b00;
	WriteMem = 1'b0;
	StoreMem = 1'b0;
	ULAOp = 3'b001;  //ADD
	IorD = 1'b1;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b1;
	nextState = WBS;
	end
	
	WBS:begin
	SrcPC = 2'b00;
	ULASrcA = 1'b1;
	ULASrcB = 2'b10;
	EscReg = 1'b1;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 2'b01;
	WriteMem = 1'b0;
	StoreMem = 1'b1;
	ULAOp = 3'b001;  //ADD
	IorD = 1'b1;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	nextState = BUSCA;
	end
	
	SW:begin
    SrcPC = 2'b00;
	ULASrcA = 1'b1;
	ULASrcB = 2'b00;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b1;
	Mem2Reg = 2'b00;
	WriteMem = 1'b1;
	StoreMem = 1'b0;
	ULAOp = 3'b001;  //ADD
	IorD = 1'b1;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	nextState = BUSCA;
	end
	
	ADD:begin
    SrcPC = 2'b00;
	ULASrcA = 1'b1;
	ULASrcB = 2'b00;
	EscReg = 1'b0;
	RegDst = 1'b1;
	IREsc = 1'b0;
	Mem2Reg = 2'b01;
	WriteMem = 1'b0;
	StoreMem = 1'b0;
	ULAOp = 3'b001;  //ADD
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b1;
	nextState = ADDComp;
	end
	
	SUB:begin
	SrcPC = 2'b00;
	ULASrcA = 1'b1;
	ULASrcB = 2'b00;
	EscReg = 1'b0;
	RegDst = 1'b1;
	IREsc = 1'b0;
	Mem2Reg = 2'b01;
	WriteMem = 1'b0;
	StoreMem = 1'b0;
	ULAOp = 3'b010;  //SUB
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b1;
	nextState = ADDComp;
	end
	
	AND: begin
    SrcPC = 2'b00;
	ULASrcA = 1'b1;
	ULASrcB = 2'b00;
	EscReg = 1'b0;
	RegDst = 1'b1;
	IREsc = 1'b0;
	Mem2Reg = 2'b01;
	WriteMem = 1'b0;
	StoreMem = 1'b0;
	ULAOp = 3'b011;  //AND
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b1;
	nextState = ADDComp;
	end
	
	ADDComp: begin
    SrcPC = 2'b00;
	ULASrcA = 1'b1;
	ULASrcB = 2'b00;
	EscReg = 1'b1;
	RegDst = 1'b1;
	IREsc = 1'b0;
	Mem2Reg = 2'b01;
	WriteMem = 1'b0;
	StoreMem = 1'b0;
	ULAOp = 3'b001;  //ADD
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	nextState = BUSCA;
	end
	XOR: begin
	SrcPC = 2'b00;
	ULASrcA = 1'b1;
	ULASrcB = 2'b00;
	EscReg = 1'b0;
	RegDst = 1'b1;
	IREsc = 1'b0;
	Mem2Reg = 2'b01;
	WriteMem = 1'b0;
	StoreMem = 1'b0;
	ULAOp = 3'b110;  //XOR
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b1;
	nextState = ADDComp;
	end
	BREAK:begin
	SrcPC = 2'b00;
	ULASrcA = 1'b0;
	ULASrcB = 2'b01;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 2'b00;
	WriteMem = 1'b0;
	StoreMem = 1'b0;
	ULAOp = 3'b010;  //SUB
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0; //precisa de EPC?
	nextState = BREAK;
	end
	NOP:begin
	SrcPC = 2'b00;
	ULASrcA = 1'b0;
	ULASrcB = 2'b00;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 2'b00;
	WriteMem = 1'b0;
	StoreMem = 1'b0;
	ULAOp = 3'b010;  //SUB
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0; //precisa de EPC?
	nextState = BUSCA;
	end
	STOPPC:begin
	SrcPC = 2'b00;
	ULASrcA = 1'b0;
	ULASrcB = 2'b01;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 2'b00;
	WriteMem = 1'b0;
	StoreMem = 1'b0;
	ULAOp = 3'b000;  //LOAD
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0; //precisa de EPC?
	nextState = BUSCA;
	end
	
	JUMP:begin
	SrcPC = 2'b10;
	ULASrcA = 1'b0;
	ULASrcB = 2'b01;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 2'b00;
	WriteMem = 1'b0;
	StoreMem = 1'b0;
	ULAOp = 3'b000;  //LOAD
	IorD = 1'b0;
	PCWri = 1'b1;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b1; //precisa de EPC?
	nextState = BUSCA;
	end
	BEQ:begin
	SrcPC = 2'b01;
	ULASrcA = 1'b1;
	ULASrcB = 2'b00;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 2'b00;
	WriteMem = 1'b0;
	StoreMem = 1'b0;
	ULAOp = 3'b010;  //SUB
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b1;
	ALUOutCtrl = 1'b0; //precisa de EPC?
	nextState = BUSCA;
	end
	BNE:begin
	SrcPC = 2'b01;
	ULASrcA = 1'b1;
	ULASrcB = 2'b00;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 2'b00;
	WriteMem = 1'b0;
	StoreMem = 1'b0;
	ULAOp = 3'b010;  //SUB
	IorD = 1'b0;
	PCWri = 1'b1;
	PCWriCond = 1'b1;
	ALUOutCtrl = 1'b0; //precisa de EPC?
	nextState = BUSCA;
	end
	LUI:begin
	SrcPC = 2'b00;
	ULASrcA = 1'b0;
	ULASrcB = 2'b01;
	EscReg = 1'b1;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 2'b10;
	WriteMem = 1'b0;
	StoreMem = 1'b1;
	ULAOp = 3'b001; //ADD
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	ALUOutCtrl = 1'b0;
	nextState = BUSCA;
	end
endcase
endmodule:UnidadeControle