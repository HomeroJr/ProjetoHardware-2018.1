module JALReg (output logic [31:0] PCSave,
			input logic [31:0] Aluresult,
			input logic [5:0] Opcode);

reg [31:0] PCnext;
			
		always @ (Opcode)
		begin
			case(Opcode)
			3'b000011:begin
			PCnext = Aluresult;
			end
		endcase
		PCSave = PCnext;
		end
			endmodule:JALReg