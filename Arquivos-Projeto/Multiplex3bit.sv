module Multiplex3bit (output logic [31:0] i,
			input logic [31:0] a,b,c,d,e,f,g,h,
			input logic [2:0] sel);
			
			
		always @ (sel)
		begin
			case(sel)
			3'b000:begin
			i = a;
			end
			3'b001:begin
			i = b;
			end
			3'b010:begin
			i = c;
			end
			3'b011:begin
			i = d;
			end
			3'b100:begin
			i = e;
			end
			3'b101:begin
			i = f;
			end
			3'b110:begin
			i = g;
			end
			3'b111:begin
			i = h;
			end
			default: i = a;
		endcase
		end
			endmodule:Multiplex3bit