module Multiplex3op (output logic [31:0] f,
			input logic [31:0] a,b,c,
			input logic [1:0] sel);
			
			always @ (sel)
			begin
				case(sel)
				2'b00:begin
				f = a;
				end
				2'b01:begin
				f = b;
				end
				2'b10:begin
				f = c;
				end
				default: f = a;
				endcase
			end
endmodule:Multiplex3op