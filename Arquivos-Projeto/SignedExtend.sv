module SignedExtend (output logic [31:0] outsigned,
			input logic [15:0] codein);
			
always_comb
begin
if (codein[15] == 1'b0)
	outsigned[31:16] = 16'b0000000000000000;
	else
	outsigned[31:16] = 16'b1111111111111111;
	
	outsigned[15:0] = codein;
	end
	
endmodule:SignedExtend