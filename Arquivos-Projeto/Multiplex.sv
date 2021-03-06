module Multiplex (output logic [31:0] f,
			input logic [31:0] a,b,
			input logic sel);
			
			always @ (sel)
			begin
				case(sel)
				1'b0:begin
				f = a;
				end
				1'b1:begin
				f = b;
				end
				endcase
			end
endmodule:Multiplex