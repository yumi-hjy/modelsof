clear
# delimit;
hetprob init gov d_un d_inf d_gro du_gov di_gov dg_gov cap_1 ipeace, het(gov d_inf di_gov d_un du_gov d_gro dg_gov cap_1) robust cluster(dyad);

***generate figure with CI intervals***;
scalar h_dg_gov=0;
scalar h_cap_1=.0068737;
scalar g_gov=(`a');
scalar g_d_inf=-0.015;
scalar g_di_gov=-0.015;
scalar g_d_un=0;
scalar g_du_gov=0;
scalar g_d_gro=0;
scalar g_dg_gov=0;
scalar g_cap_1=.0068737;

generate x_betahatz = MG_b1*(`a')

generate z_gammalo = MG_b11*(`a')
					+ MG_b12*g_d_inf
					+ MG_b13*g_di_gov*(`a')
					+ MG_b14*g_d_un
					+ MG_b15*g_du_gov
					+ MG_b16*g_d_gro
					+ MG_b17*g_dg_gov
					+ MG_b18*g_cap_1;

generate z_gammahi = MG_b11*(`a')
					+ MG_b12*(g_d_inf+0.03)
					+ MG_b13*(g_di_gov+0.03)*(`a')
					+ MG_b14*g_d_un
					+ MG_b15*g_du_gov
					+ MG_b16*g_d_gro
					+ MG_b17*g_dg_gov
					+ MG_b18*g_cap_1;

generate z_gammaz = MG_b11*(`a')
					+ MG_b12*(g_d_inf*0)
					+ MG_b13*(g_di_gov*0)*(`a')
					+ MG_b14*g_d_un
					+ MG_b15*g_du_gov
					+ MG_b16*g_d_gro
					+ MG_b17*g_dg_gov
					+ MG_b18*g_cap_1;

gen prob0=normprob(x_betahatlo/(exp(z_gammalo)));
gen probz=normprob(x_betahatz/(exp(z_gammaz)));