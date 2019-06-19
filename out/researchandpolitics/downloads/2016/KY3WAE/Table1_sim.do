/*This STATA code replicates results for Table 1*/

#d ;
global sim "Change Directory Here" ;
cap mkdir "$sim\ECM\" ;
cap mkdir "$sim\ECM\BI\" ;
cap mkdir "$sim\ECM\MV\" ;

/*bivariate*/
#d ;
cd "$sim\ECM\BI\" ;
clear all ;
foreach b of numlist 1 2 { ;
foreach t of numlist 60 100 150 { ;
foreach v of numlist 1 2 3 { ;
clear ;
global nobs = `t' ;
global nmc = 10000 ;
gen id = _n ;
local obs_df =`t'-4 ;
if (`v'==1 & `b'==1) { ;
gen dv1 = (99-1)*runiform()+1 ; 
} ;

if (`v'==2 & `b'==1) { ;
gen dv1 = (99-1)*runiform()+1 ; 
} ;

if (`v'==3 & `b'==1) { ;
gen dv1 = (99-1)*runiform()+1 ; 
} ;

if (`v'==1 & `b'==2) { ;
gen dv1 = (59-50)*runiform()+50 ; 
} ;

if (`v'==2 & `b'==2) { ;
gen dv1 = (59-50)*runiform()+50 ; 
} ;

if (`v'==3 & `b'==2) { ;
gen dv1 = (59-50)*runiform()+50 ;
} ;


/*dicky-fuller test*/
		/*Identify appropriate lags for the Dicky-Fuller test (y). */ 
		reg d.dv1 l.dv1 ; 
		predict resid_dv1, r ;
		wntestq resid_dv1 ;
		local i=r(p) ; 
		drop resid_dv1 ;
		local j = 0 ;
		while `i'<0.05 { ; /*The "while" command allows us to keep running the set of stata commands 
		                   enclosed in the braces until the p-value from the White noise Q test becomes 
		                   greater than 0.05. */
		local j =`j'+ 1 ; /*If the p-value is lower than 0.05, which is a sign of the presence of serial correlation, 
							`j' increases by one unit such that one more lag of ld.y is added in the equation below.*/
		reg d.dv1 l.dv1 l(1/`j')d.dv1 ; 
		predict resid_dv1, r ;
		wntestq resid_dv1 ;
		local i=r(p) ; 
		drop resid_dv1 ;
		} ;
		
		/*Augmented Dicky-Fuller test */
		dfuller dv1, lags(`j') ; /*dfuller: dfuller=Dickey-Fuller (DF) Test
					H0: I(1) or y is unit root.
					H1: (p-1)<0 or y is stationary.
					The appropriate lags `j' is imputed so as to address 
					the issues of serial correlation.
					If p-value is greater than 0.05, it indicates that y
					has a unit root.
					Note that rejecting the null hypothesis does not mean
					we can accept H0 (Woodridge 2009, 633)!
					dfuller by default regresses d.y on l.y. 
					How many lags to be included often depends on 
					the frequency of the data.*/
					
		scalar p_value_df_dv1=r(p) ; /*Save p-value to see if the 
										estimated coefficient on l.y is 
										statistically significant at the .05 level 
										given the Dicket-Fuller Distribution.*/
										
scalar m1asig = m1ta1<ecmsig ;
scalar m1asigMCV_df = (m1ta1<=ecmMCVm1 & p_value_df_dv1>0.05) ;
} ;
} ;
#d ;
cd "$sim\ECM\MV\" ;
foreach b of numlist 1 2 { ;
foreach t of numlist 60 100 150 { ;
foreach v of numlist 1 2 3 { ;
#d ;
clear ;
global nobs = `t' ;
global nmc = 10000 ;
gen id = _n ;
local obs_df =`t'-6 ;
#d ;
if (`v'==1 & `b'==1) { ;
#d ;
gen dv1 = (99-1)*runiform()+1 ; 
} ;

#d ;
if (`v'==2 & `b'==1) { ;
#d ;
gen dv1 = (99-1)*runiform()+1 ; 
} ;

#d ;
if (`v'==3 & `b'==1) { ;
#d ;
gen dv1 = (99-1)*runiform()+1 ; 
} ;

#d ;
if (`v'==1 & `b'==2) { ;
#d ;
gen dv1 = (59-50)*runiform()+50 ; 
} ;

#d ;
if (`v'==2 & `b'==2) { ;
#d ;
gen dv1 = (59-50)*runiform()+50 ; 
} ;

#d ;
if (`v'==3 & `b'==2) { ;
#d ;
gen dv1 = (59-50)*runiform()+50 ; 
} ;

/* Generating starting values for DV*/
#d ;
#d ;
#d ;
#d ;

/*dicky-fuller test*/
		/*Identify appropriate lags for the Dicky-Fuller test (y). */ 
		reg d.dv1 l.dv1 ; 
		predict resid_dv1, r ;
		wntestq resid_dv1 ;
		local i=r(p) ; 
		drop resid_dv1 ;
		local j = 0 ;
		while `i'<0.05 { ; /*The "while" command allows us to keep running the set of stata commands 
		                   enclosed in the braces until the p-value from the White noise Q test becomes 
		                   greater than 0.05. */
		local j =`j'+ 1 ; /*If the p-value is lower than 0.05, which is a sign of the presence of serial correlation, 
							`j' increases by one unit such that one more lag of ld.y is added in the equation below.*/
		reg d.dv1 l.dv1 l(1/`j')d.dv1 ; 
		predict resid_dv1, r ;
		wntestq resid_dv1 ;
		local i=r(p) ; 
		drop resid_dv1 ;
		} ;
		
		/*Augmented Dicky-Fuller test */
		dfuller dv1, lags(`j') ; /*dfuller: dfuller=Dickey-Fuller (DF) Test
					H0: I(1) or y is unit root.
					H1: (p-1)<0 or y is stationary.
					The appropriate lags `j' is imputed so as to address 
					the issues of serial correlation.
					If p-value is greater than 0.05, it indicates that y
					has a unit root.
					Note that rejecting the null hypothesis does not mean
					we can accept H0 (Woodridge 2009, 633)!
					dfuller by default regresses d.y on l.y. 
					How many lags to be included often depends on 
					the frequency of the data.*/
					
		scalar p_value_df_dv1=r(p) ; /*Save p-value to see if the 
										estimated coefficient on l.y is 
										statistically significant at the .05 level 
										given the Dicket-Fuller Distribution.*/
										
} ;
} ;