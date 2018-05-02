module AdderMem8 (output logic [31:0] MemByte,
			input logic [31:0] MDRrs,
			input logic [31:0] rt
			);
		
always@(MDRrs)
	begin
	MemByte[31:8] = MDRrs[31:8];
	MemByte[7:0] = rt[7:0];
	end
	
endmodule:AdderMem8