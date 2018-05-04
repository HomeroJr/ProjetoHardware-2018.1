module Multiplex3bit (output logic [31:0] g,
			input logic [31:0] a,b,c,d,e,f,
			input logic [2:0] sel);
			
			
		always @ (sel)
		begin
			case(sel)
			3'b000:begin
			g = a;
			end
			3'b001:begin
			g = b;
			end
			3'b010:begin
			g = c;
			end
			3'b011:begin
			g = d;
			end
			3'b100:begin
			g = e;
			end
			3'b101:begin
			g = f;
			end
			default: g = a;
		endcase
		end
			endmodule:Multiplex3bit