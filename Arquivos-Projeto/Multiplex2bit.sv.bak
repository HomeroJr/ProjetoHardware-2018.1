module Multiplex2bit (output logic [31:0] f,
			input logic [31:0] a,b,c,d,
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
			2'b11:begin
			f = d;
			end
		endcase
		end
			endmodule:Multiplex2bit
