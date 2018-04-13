module Multiplex2bit (output logic f,
			input logic a,b,c,d,
			input logic [1:0] sel);
			//recebe um valor seletor 'sel' de 00 a 11 e escolhe uma das 4 entradas de acordo com o valor
			not g0 (nsel0, sel[0]);
			not g1 (n_sel1, sel[1]);
			and g3 (a2, a, n_sel0);			//a = 00
			and g4 (a3, a2, n_sel1);
			and g5 (b2, b, sel[0]);			//b = 01
			and g6 (b3, b, n_sel1);
			and g7 (c2, c, n_sel0);			//c = 10
			and g8 (c3, c2, sel[1]);
			and g9 (d2, d, sel[0]);			//d = 11
			and g10 (d3, d2, sel[1]);
			or g11 (ab, a3, b3);
			or g12 (cd, c3, d3);
			or g13 (f, ab, cd);
			
			endmodule:Multiplex2bit