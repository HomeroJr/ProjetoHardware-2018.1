module AdderMem16 (output logic [31:0] MemHalf,
			input logic [31:0] MDRrs,
			input logic [31:0] rt
			);
		
always@(MDRrs)
	begin
	MemHalf[31:16] = MDRrs[31:16];
	MemHalf[15:0] = rt[15:0];
	end
	
endmodule:AdderMem16