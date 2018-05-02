module UnsignedExtend (output logic [31:0] OutNewInst,
			input logic [31:0] MemIn,
			input logic Overflow
			);
		
always@(MemIn)
	begin
		case(Overflow)
		1'b0:begin
		OutNewInst[31:8] = 24'b000000000000000000000000; //se não ocorrer erro de overflow, assume-se OPCode Inexistente
		OutNewInst[7:0] = MemIn[15:8];
		end
		1'b1:begin
		OutNewInst[31:8] = 24'b000000000000000000000000;
		OutNewInst[7:0] = MemIn[7:0];
		end
		endcase
	end
	
endmodule:UnsignedExtend  