clear
# delimit;
hetprob init gov d_un d_inf d_gro du_gov di_gov dg_gov cap_1 ipeace, het(gov d_inf di_gov d_un du_gov d_gro dg_gov cap_1) robust cluster(dyad);

***generate figure with CI intervals***;
scalar h_dg_gov=0;
scalar h_cap_1=.0068737;
scalar g_gov=1;
scalar g_d_inf=0;
scalar g_di_gov=0;
scalar g_d_un=0;
scalar g_du_gov=0;
scalar g_d_gro=0;
scalar g_dg_gov=0;
scalar g_cap_1=.0068737;
					+ MG_b4*h_d_gro 

generate z_gammalo = MG_b11*(`a')
					+ MG_b12*g_d_inf
					+ MG_b13*g_di_gov
					+ MG_b14*g_d_un
					+ MG_b15*g_du_gov*(`a')
					+ MG_b16*g_d_gro
					+ MG_b17*g_dg_gov
					+ MG_b18*g_cap_1;

generate z_gammahi = MG_b11*(`a')
					+ MG_b12*g_d_inf
					+ MG_b13*g_di_gov
					+ MG_b14*(g_d_un+0.14)
					+ MG_b15*(g_du_gov+0.14)*(`a')
					+ MG_b16*g_d_gro
					+ MG_b17*g_dg_gov
					+ MG_b18*g_cap_1;

gen prob0=normprob(x_betahatlo/(exp(z_gammalo)));
replace	MV	=	-50	if	_n	==	1	;
replace	MV	=	-49	if	_n	==	2	;
replace	MV	=	-48	if	_n	==	3	;
replace	MV	=	-47	if	_n	==	4	;
replace	MV	=	-46	if	_n	==	5	;
replace	MV	=	-45	if	_n	==	6	;
replace	MV	=	-44	if	_n	==	7	;
replace	MV	=	-43	if	_n	==	8	;
replace	MV	=	-42	if	_n	==	9	;
replace	MV	=	-41	if	_n	==	10	;
replace	MV	=	-40	if	_n	==	11	;
replace	MV	=	-39	if	_n	==	12	;
replace	MV	=	-38	if	_n	==	13	;
replace	MV	=	-37	if	_n	==	14	;
replace	MV	=	-36	if	_n	==	15	;
replace	MV	=	-35	if	_n	==	16	;
replace	MV	=	-34	if	_n	==	17	;
replace	MV	=	-33	if	_n	==	18	;
replace	MV	=	-32	if	_n	==	19	;
replace	MV	=	-31	if	_n	==	20	;
replace	MV	=	-30	if	_n	==	21	;
replace	MV	=	-29	if	_n	==	22	;
replace	MV	=	-28	if	_n	==	23	;
replace	MV	=	-27	if	_n	==	24	;
replace	MV	=	-26	if	_n	==	25	;
replace	MV	=	-25	if	_n	==	26	;
replace	MV	=	-24	if	_n	==	27	;
replace	MV	=	-23	if	_n	==	28	;
replace	MV	=	-22	if	_n	==	29	;
replace	MV	=	-21	if	_n	==	30	;
replace	MV	=	-20	if	_n	==	31	;
replace	MV	=	-19	if	_n	==	32	;
replace	MV	=	-18	if	_n	==	33	;
replace	MV	=	-17	if	_n	==	34	;
replace	MV	=	-16	if	_n	==	35	;
replace	MV	=	-15	if	_n	==	36	;
replace	MV	=	-14	if	_n	==	37	;
replace	MV	=	-13	if	_n	==	38	;
replace	MV	=	-12	if	_n	==	39	;
replace	MV	=	-11	if	_n	==	40	;
replace	MV	=	-10	if	_n	==	41	;
replace	MV	=	-9	if	_n	==	43	;
replace	MV	=	-8	if	_n	==	44	;
replace	MV	=	-7	if	_n	==	45	;
replace	MV	=	-6	if	_n	==	46	;
replace	MV	=	-5	if	_n	==	47	;
replace	MV	=	-4	if	_n	==	48	;
replace	MV	=	-3	if	_n	==	49	;
replace	MV	=	-2	if	_n	==	50	;
replace	MV	=	-1	if	_n	==	51	;
replace	MV	=	0	if	_n	==	52	;
replace	MV	=	1	if	_n	==	53	;
replace	MV	=	2	if	_n	==	54	;
replace	MV	=	3	if	_n	==	55	;
replace	MV	=	4	if	_n	==	56	;
replace	MV	=	5	if	_n	==	57	;
replace	MV	=	6	if	_n	==	58	;
replace	MV	=	7	if	_n	==	59	;
replace	MV	=	8	if	_n	==	60	;
replace	MV	=	9	if	_n	==	61	;
replace	MV	=	10	if	_n	==	62	;
replace	MV	=	11	if	_n	==	63	;
replace	MV	=	12	if	_n	==	64	;
replace	MV	=	13	if	_n	==	65	;
replace	MV	=	14	if	_n	==	66	;
replace	MV	=	15	if	_n	==	67	;
replace	MV	=	16	if	_n	==	68	;
replace	MV	=	17	if	_n	==	69	;
replace	MV	=	18	if	_n	==	70	;
replace	MV	=	19	if	_n	==	71	;
replace	MV	=	20	if	_n	==	72	;
replace	MV	=	21	if	_n	==	73	;
replace	MV	=	22	if	_n	==	74	;
replace	MV	=	23	if	_n	==	75	;
replace	MV	=	24	if	_n	==	76	;
replace	MV	=	25	if	_n	==	77	;
replace	MV	=	26	if	_n	==	78	;
replace	MV	=	27	if	_n	==	79	;
replace	MV	=	28	if	_n	==	80	;
replace	MV	=	29	if	_n	==	81	;
replace	MV	=	30	if	_n	==	82	;
replace	MV	=	31	if	_n	==	83	;
replace	MV	=	32	if	_n	==	84	;
replace	MV	=	33	if	_n	==	85	;
replace	MV	=	34	if	_n	==	86	;
replace	MV	=	35	if	_n	==	87	;
replace	MV	=	36	if	_n	==	88	;
replace	MV	=	37	if	_n	==	89	;
replace	MV	=	38	if	_n	==	90	;
replace	MV	=	39	if	_n	==	91	;
replace	MV	=	40	if	_n	==	92	;
replace	MV	=	41	if	_n	==	93	;
replace	MV	=	42	if	_n	==	94	;
replace	MV	=	43	if	_n	==	95	;
replace	MV	=	44	if	_n	==	96	;
replace	MV	=	45	if	_n	==	97	;
replace	MV	=	46	if	_n	==	98	;
replace	MV	=	47	if	_n	==	99	;
replace	MV	=	48	if	_n	==	100	;
replace	MV	=	49	if	_n	==	101	;
replace	MV	=	50	if	_n	==	102	;



