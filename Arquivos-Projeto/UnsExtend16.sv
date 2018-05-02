module UnsExtend16 (output logic [31:0] OutHalfWord,
			input logic [31:0] MemIn
			);
		
always@(MemIn)
	begin
	OutHalfWord[31:16] = 16'b0000000000000000;
	OutHalfWord[15:0] = MemIn[15:0];
	end
	
endmodule:UnsExtend16