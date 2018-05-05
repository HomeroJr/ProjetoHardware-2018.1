module Multiplex3bit (output logic [31:0] h,
			input logic [31:0] a,b,c,d,e,f,g,
			input logic [2:0] sel);
			
			
		always @ (sel)
		begin
			case(sel)
			3'b000:begin
			h = a;
			end
			3'b001:begin
			h = b;
			end
			3'b010:begin
			h = c;
			end
			3'b011:begin
			h = d;
			end
			3'b100:begin
			h = e;
			end
			3'b101:begin
			h = f;
			end
			3'b110:begin
			h = g;
			end
			default: h = a;
		endcase
		end
			endmodule:Multiplex3bit