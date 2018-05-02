module UnsExtend8 (output logic [31:0] OutByte,
			input logic [31:0] MemIn
			);
		
always@(MemIn)
	begin
	OutByte[31:8] = 24'b000000000000000000000000;
	OutByte[7:0] = MemIn[7:0];
	end
	
endmodule:UnsExtend8  