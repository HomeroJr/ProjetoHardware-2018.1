module MuxShiftAmount (output logic [4:0] shamt,
						input logic [31:0] regA,
						input logic [15:0] code15to0
						);
logic [5:0] functRead;
logic [4:0] shiftOver;
logic [4:0] nextShamt;


assign functRead = code15to0[5:0];
assign shiftOver = regA[31:5];
						
	always@(code15to0)
	begin
		case(functRead)
		6'b000000:begin
		nextShamt = code15to0[10:6];
		end
		6'b000100:begin
			case(shiftOver)
			27'b000000000000000000000000000:begin
			nextShamt = 5'b11111;
			end
			default: nextShamt = regA[5:0];
			endcase
		end
		6'b000011:begin
		nextShamt = code15to0[10:6];
		end
		6'b000111:begin
			case(shiftOver)
			27'b000000000000000000000000000:begin
			nextShamt = 5'b11111;
			end
			default: nextShamt = regA[5:0];
			endcase
		end
		6'b000010:begin
		nextShamt = code15to0[10:6];
		end
		endcase
		shamt = nextShamt;
	end
endmodule:MuxShiftAmount