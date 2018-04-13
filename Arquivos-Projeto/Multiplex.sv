module Multiplex (output logic f,
			input logic a,b,sel);
			
			and #2 g1(fl,a,n_sel),
				   g2(f2,b,sel);
		    or #2	g3(f,fl,f2);
		    not		g4(n_sel,sel);
		    endmodule:Multiplex