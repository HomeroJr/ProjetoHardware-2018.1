module Multiplex3bit (output logic [31:0] f,
			input logic [31:0] a,b,c,d,e,
			input logic [2:0] sel);
			
			
		always @ (sel)
		begin
			case(sel)
			3'b000:begin
			f = a;
			end
			3'b001:begin
			f = b;
			end
			3'b010:begin
			f = c;
			end
			3'b011:begin
			f = d;
			end
			3'b100:begin
			f = e;
			end
			default: f = a;
		endcase
		end
			endmodule:Multiplex3bit
