module UnidadeControle(input logic clock,
			input logic reset,
			input logic [5:0] OPcode,
			output logic [1:0] SrcPC,
			output logic ULASrcA,
			output logic [1:0] ULASrcB,
			output logic EscReg,
			output logic RegDst,
			output logic IREsc,
			output logic Mem2Reg,
			output logic WriteMem,
			output logic StoreMem,
			output logic [2:0] ULAOp,
			output logic IorD,
			output logic PCWri,
			output logic PCWriCond
			);
			//output logic stateout);
			
			
			enum logic [1:0] {RESET , BUSCA, WAIT, WRITE} state, nextState; 
			//assign stateout = state;
			
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
	Mem2Reg = 1'b0;
	WriteMem = 1'b0;
	StoreMem = 1'b0;
	ULAOp = 3'b001;
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	nextState = BUSCA;
	end
	BUSCA:begin
	SrcPC = 2'b00;
	ULASrcA = 1'b0;
	ULASrcB = 2'b01; // carrega o 4 
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 1'b0;
	WriteMem = 1'b0; //sempre leia a memoria quando = 0
	StoreMem = 1'b0;
	ULAOp = 3'b001;
	IorD = 1'b0;
	PCWri = 1'b1;
	PCWriCond = 1'b0;
	nextState = WAIT;
	end
	WAIT:begin
	SrcPC = 2'b00;
	ULASrcA = 1'b0;
	ULASrcB = 2'b01;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b0;
	Mem2Reg = 1'b0;
	WriteMem = 1'b0;
	StoreMem = 1'b0;
	ULAOp = 3'b001;
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	nextState = WRITE;
	end
	WRITE:begin
	SrcPC = 2'b00;
	ULASrcA = 1'b0;
	ULASrcB = 2'b01;
	EscReg = 1'b0;
	RegDst = 1'b0;
	IREsc = 1'b1;
	Mem2Reg = 1'b0;
	WriteMem = 1'b0;
	StoreMem = 1'b0;
	ULAOp = 3'b001;
	IorD = 1'b0;
	PCWri = 1'b0;
	PCWriCond = 1'b0;
	nextState = BUSCA;
	end
	//DECODE:
	//begin
	//	case(opcode)
	//	ADD:
	//	begin
	//
	//	end
	//	ADDI:
	//	begin
	//	end
	//	default://excecao opcode inexistente
	//end
endcase
endmodule:UnidadeControle