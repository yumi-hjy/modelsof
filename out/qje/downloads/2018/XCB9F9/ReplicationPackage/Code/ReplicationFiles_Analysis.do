/*******************************************************************************
This file: This file replicates Tables and Figures presented in the paper and online appendix
		   of `Moral Hazard: Experimental Evidence from Tenancy Contracts', published in 
		   The Quarterly Journal of Economics. 

This version: 21st of September 2018

Note:  	   Set in line 33 the path to the folder in which this file is stored.
		   This .do file draws on additional .do and .ado which are stored in subfolders called `do files' and `ado files'.
		   This .do file draws on data which is stored in a subfolder called `input'.
		   All tables and figures generated by this .do file are saved in a subfolder `output'. 
		   
		   Please select any table or figure you would like to replicate by setting the respective 
		   local to 1 in the section `Select Tables/Figures' below.
		   		   
*******************************************************************************/

#delimit;
version 13;
capture clear;
clear matrix;
clear mata;
set maxvar   32600;
capture log close;
set more off;
/* set scheme lean2; */

/*****************
*** SET PATHS ***
*****************/;

/* Set the path */ ;
global researchpath = ".../ReplicationPackage";

cd "$researchpath";

/****************************
*** Select Tables/Figures ***
*****************************/;

/* Indicate (with 1) which tables to produce; */

local TableIA = 1;
local TableIB = 1;
local TableII = 1;
local TableIII = 1;
local TableIV = 1;
local TableV = 1;
local TableVI = 1;
local TableVII = 1;
local TableVIII_col34 = 1;
local TableVIII_col12 = 1;

local FigureIII = 1;
local FigureIV = 1;
local FigureV = 1;
local FigureVI = 1;

local SupTableV = 1;
local SupTableVI = 1;
local SupTableVII = 1;
local SupTableVIII = 1;
local SupTableIX= 1;
local SupTableX = 1;
local SupTableXI_cols12 = 1;
local SupTableXI_cols34 = 1;
local SupTableXII_cols12 = 1;
local SupTableXII_cols34 = 1;
local SupTableXIII = 1;
local SupTableXIV = 1;
local SupTableXV = 1; 
local SupTableXVI = 1;
local SupTableXVII = 1;
local SupTableXVIII = 1;
local SupTableXIX = 1;
local SupTableXXA = 1;
local SupTableXXB = 1;
local SupTableXXIA = 1;
local SupTableXXIB = 1;
local SupTableXXII = 1;
local SupTableXXIII = 1;
local SupTableXXIV = 1;
local SupTableXXV = 1;
local SupTableXXVI = 1;
local SupTableXXVII = 1;
local SupTableXXVIII = 1;
local SupTableXXX = 1;
local SupTableXXIX = 1;

local SupFigureI = 1;
local SupFigureII = 1;

/********************
*** RI iterations ***
********************/;

/* Set the number of alternative random assignements to calculate randomizatino inference standard 
   errors. The maximum is 1000, which is what is used for the results in the paper. */

local ri_N = 1;

/***********************
*** Load .ado files  ***
************************/;

do "Code/ado files/tenancytable.ado";
do "Code/ado files/tenancytablebounds.ado";
do "Code/ado files/tenancyindextable.ado";
do "Code/ado files/makeindex.ado";

/* ---------------------------------------------------------------------------------- 
* -----------------------------------------------------------------------------------
* ---------------------------- CROP ASSESSMENT DATA ---------------------------------
* ----------------------------------------------------------------------------------- 
* -----------------------------------------------------------------------------------*/ ;

/* Load Crop Assessment Data */

use "Input/CropAssessment_Data.dta", clear;

/* ----- MAIN PAPER RESULTS ----- */;

/* Results reported in section III.E, Attrition */;
preserve;
	keep club_id farmer_id season attrition Y;
	sort club_id farmer_id season attrition Y;
	drop if (farmer_id[_n] == farmer_id[_n-1]) & (season[_n] == season[_n-1]) & Y == .;
	replace attrition = 1 if Y == .;
	
	duplicates drop club_id farmer_id season attrition, force;
	tab attrition season;
restore; 

/* TABLE I.B */;
if `TableIB' == 1 {;	
	include "Code/do files/TableIB.do";
};

/* TABLE II */;
if `TableII' == 1 {;
	tenancytable Y Y Ysqm Ysqm if attrition == 0, /// 
		digit1(7) digit2(3) filename("TableII") iterations(`ri_N') regp("0 1 0 1");
};

/* TABLE V */;
if `TableV' == 1 {; 
	/* TableVA */;
	tenancytable cpD1 cpD2 cpD3 cpD4 cpD5 if attrition == 0 ///
		, digit1(5) digit2(3) filename("TableVA") iterations(`ri_N') regp("0 0 0 0 0");

	/* TableVB */;
	tenancytable plnt1 plnt2 plnt3 plnt4 plnt5 if attrition == 0 ///
		, digit1(5) digit2(2) filename("TableVB") iterations(`ri_N') regp("0 0 0 0 0");

	/* TableVC */;
	tenancytable cp1 cp2 cp3 cp4 cp5 if attrition == 0 ///
		, digit1(5) digit2(2) filename("TableVC") iterations(`ri_N') regp("0 0 0 0 0");
};	

/* TABLE VIII, columns 3 and 4 */;
if `TableVIII_col34' == 1 {;
	tenancytable Logland LogY  if attrition==0 ///
					, digit1(5) digit2(2) filename("TableVIIIB_col34") iterations(`ri_N') regp("0 0");					
	tenancytable land Y  if attrition==0 ///
					, digit1(5) digit2(2) filename("TableVIIIA_col34") iterations(`ri_N') regp("0 0");
};

/* FIGURE III */;
if `FigureIII' == 1 {;
	label define tt_r_label 1 "Control" 2 "High s (T1)" 3 "High w (T2)";
	label values tt_r tt_r_label;
	distplot line Y if attrition == 0, by(tt_r) ytitle("Prob. <= Output, {it:y}") xtitle("Output, {it:y}") scheme(lean2) legend(cols(1) ring(0) pos(3)) ;
	graph export "Output/FigureIII.pdf", as(pdf) replace;
	graph export "Output/FigureIII.tif", as(tif) replace;	
};

/* FIGURE V*/;
if `FigureV' == 1 {;
	include "Code/do files/FigureV.do";
};

/* FIGURE VI, SUPPLEMENTARY TABLE IX and SUPPLEMENTARY TABLE X */;
if `FigureVI' == 1 | `SupTableIX' == 1 | `SupTableX' == 1 | `SupTableXXA' == 1 {;
		include   "Code/do files/FigureVI_Step1to4.do";
		/* RUN MATLAB CODE: Code/m files/FigureVI_Step5.m */
};

/* Results reported in section IV.D, Approach 2: Coefficient of Variation */;
areg Y i.treatment_type, absorb(superstrata) cl(club_id) allbaselevels;
foreach x of numlist 1/4 {;
	sum Y if e(sample) & treatment_type == `x';
	display `r(sd)'/`r(mean)';
};

/* ----- ONLINE APPENDIX RESULTS ----- */;

if `SupFigureI' == 1 {;
	include "Code/do files/SupFigureI.do";
};


if `SupTableXI_cols12' == 1 {; 
preserve; 
	keep club_id farmer_id season attrition Y treatment_type* tt_r* superstrata;
	sort club_id farmer_id season attrition Y;
	drop if (farmer_id[_n] == farmer_id[_n-1]) & (season[_n] == season[_n-1]) & Y == .;
	replace attrition = 1 if Y == .;
	duplicates drop club_id farmer_id season attrition, force;
	
	keep if season == 2;
	tab attrition; 
	tenancytable attrition attrition, /// 
		digit1(5) digit2(3) filename("SupTableXI_cols12") iterations(`ri_N') regp("0 1");
restore; 
};

if `SupTableXII_cols12' == 1 {; 
preserve; 
	keep club_id farmer_id season attrition Y treatment_type* tt_r* superstrata;
	sort club_id farmer_id season attrition Y;
	drop if (farmer_id[_n] == farmer_id[_n-1]) & (season[_n] == season[_n-1]) & Y == .;
	replace attrition = 1 if Y == .;
	duplicates drop club_id farmer_id season attrition, force;
		
	keep if season == 3;
	tab attrition; 
	tenancytable attrition attrition, /// 
		digit1(5) digit2(3) filename("SupTableXII_cols12") iterations(`ri_N') regp("0 1") ;
restore; 
};

if `SupTableXIV' == 1 {;	
	tenancytable E_yield E_yield E_yield_sqm E_yield_sqm if attrition == 0, /// 
		digit1(7) digit2(3) filename("SupTableXIV") iterations(`ri_N') regp("0 1 0 1");
};

if `SupTableXV' == 1 {; 
	include "Code/do files/SupTableXV.do" ;
};

if `SupTableXXIII' == 1 {; 
	tenancytable cpD1 cpD2 cpD3 cpD4 cpD5 if attrition == 0 ///
		, digit1(5) digit2(3) filename("SupTableXXIIIA") iterations(`ri_N') regp("1 1 1 1 1");
		
	tenancytable plnt1 plnt2 plnt3 plnt4 plnt5 if attrition == 0 ///
		, digit1(5) digit2(2) filename("SupTableXXIIIB") iterations(`ri_N') regp("1 1 1 1 1");	

	tenancytable cp1 cp2 cp3 cp4 cp5 if attrition == 0 ///
		, digit1(5) digit2(2) filename("SupTableXXIIIC") iterations(`ri_N') regp("1 1 1 1 1");
};	

if `SupTableXXIV' == 1 {;
	tenancytablebounds E_yield E_yield E_yield_sqm E_yield_sqm , /// 
		digit1(7) digit2(3) filename("SupTableXXIV") iterations(`ri_N') regp("0 1 0 1") trimming;
};	

if `SupTableXXVII' == 1 {; 
	tenancytablebounds cpD1 cpD2 cpD3 cpD4 cpD5  ///
		, digit1(5) digit2(3) filename("SupTableXXVIIA") iterations(`ri_N') regp("0 0 0 0 0");

	tenancytablebounds plnt1 plnt2 plnt3 plnt4 plnt5 ///
		, digit1(5) digit2(2) filename("SupTableXXVIIB") iterations(`ri_N') regp("0 0 0 0 0");

	tenancytablebounds cp1 cp2 cp3 cp4 cp5  ///
		, digit1(5) digit2(2) filename("SupTableXXVIIC") iterations(`ri_N') regp("0 0 0 0 0");	
};

if `SupFigureII' == 1 {;
	graph box Y if attrition == 0, over(tt_r, relabel(1 "C" 2 "T1" 3 "T2") gap(100) label(labsize(large))) nooutsides box(1,fcolor(gs8)) ///
		  graphregion(color(white)) aspectratio(2) ysize(8) xsize(5) ///
		  yscale(noline) ytitle("Output, {it:y}",size(large)) ytick(none) ///
		  ylabel(,labsize(medium) angle(0) glwidth(thin) glcolor(gs12) glpattern(dash)) ///
		  legend(off) note("",span);
	graph export "Output/SupFigureII.pdf", replace;
};

/* Demean variables used in heterogenetiy analysis */;
foreach y in Y {;
	foreach x in dimrkt days married Age educ plot {;
	
		areg `y' tt_r##c.`x' o1.tt_r, cl(club_id) a(superstrata);
		
		sum `x' 					if e(sample) == 1;
		gen `x'_`y' = `x' - r(mean) if e(sample) == 1;
		replace `x'_`y' = 0 		if `x'_`y'   == .;
		sum `x'_`y';
		
		};	
};  

if `SupTableV' == 1 {;
	label var Age_Y "Age";
	tenancytable Y Y Ysqm Ysqm, digit1(7) digit2(3) filename("SupTableV") iterations(`ri_N') regp("3 4 3 4") covariates(Age_Y Age_Y Age_Y Age_Y);
};

if `SupTableVI' == 1 {;
	label var married_Y "Married";
	tenancytable Y Y Ysqm Ysqm, digit1(7) digit2(3) filename("SupTableVI") iterations(`ri_N') regp("3 4 3 4") covariates(married_Y married_Y married_Y married_Y);
};

if `SupTableVII' == 1 {;
	label var educ_Y "Schooling (years)";
	tenancytable Y Y Ysqm Ysqm , digit1(7) digit2(3) filename("SupTableVII") iterations(`ri_N') regp("3 4 3 4") covariates(educ_Y educ_Y educ_Y educ_Y);
	};
	
if `SupTableVIII' == 1 {;
	label var plot_Y "Plot size";
	tenancytable Y Y Ysqm Ysqm, digit1(7) digit2(3) filename("SupTableVIII") iterations(`ri_N') regp("3 4 3 4") covariates(plot_Y plot_Y plot_Y plot_Y);
};
	
if `SupTableXIX' == 1 {;
	label var s2 "Season 2";
	tenancytable Y Ysqm if attrition==0, digit1(7) digit2(3) filename("SupTableXIX") iterations(`ri_N') regp("3 3") covariates(s2 s2);
};

if `SupTableXVI' == 1 {;
	label var days_Y "Survey Day";
	tenancytable Y Y Ysqm Ysqm, digit1(7) digit2(3) filename("SupTableXVI") iterations(`ri_N') regp("3 4 3 4") covariates(days_Y days_Y days_Y days_Y);
};

if `SupTableXVII' == 1 {;
	label var dimrkt_Y "Distance to Market";
	tenancytable Y Y Ysqm Ysqm , digit1(7) digit2(3) filename("SupTableXVII") iterations(`ri_N') regp("3 4 3 4") covariates(dimrkt_Y dimrkt_Y dimrkt_Y dimrkt_Y);
};

if `SupTableXVIII' == 1 {;
	tenancytable harvest_some harvest_some harvest_someV harvest_someV if attrition == 0, digit1(7) digit2(3) filename("SupTableXVIII") iterations(`ri_N') regp("0 1 0 1");
};

if `SupTableXXII' == 1 {;
	label var cp1 "Maize";
	label var cp2 "Beans";
	label var cp3 "Peanuts";

	areg cp1 cp2 if tt_r==1, a(superstrata) cl(club_id);
	estimates store crop12, title (" ");
	areg cp1 cp3 if tt_r==1, a(superstrata) cl(club_id);
	estimates store crop13, title (" ");
	areg cp2 cp3 if tt_r==1, a(superstrata) cl(club_id);
	estimates store crop23, title (" ");

	estout crop12 crop13 crop23
	using "Output/SupTableXXII.tex",  replace style (tex) collabels(, none) label cells(b(star fmt(%9.3f)) se(par)) 
	keep(cp2 cp3)  mlabels(, none) starlevels(* 0.10 ** 0.05 *** 0.01) stats(N, fmt(%9.0g) layout(@ )  labels("Observations") );	
};


/* ----------------------------------------------------------------------------------- 
* -----------------------------------------------------------------------------------
* ---------------------------- SOIL QUALITY SURVEY ----------------------------------
* ----------------------------------------------------------------------------------- 
* -----------------------------------------------------------------------------------*/ ;

use "Input/SoilTests_Data.dta", clear;

/* TABLE VII */;
if `TableVII' == 1 {;
	tenancyindextable nitrogen potassium phosphorus organic soilph , ///
		     digit1(7) digit2(2) filename("TableVII") iterations(`ri_N');		 
};



/* ----------------------------------------------------------------------------------- 
* -----------------------------------------------------------------------------------
* ---------------------------- TENANT SURVEY ----------------------------------------
* ----------------------------------------------------------------------------------- 
* -----------------------------------------------------------------------------------*/ ;

/* ----- MAIN PAPER RESULTS ----- */;

use "Input/TenantSurvey_Data.dta", clear ;

/* Drop baseline season */;
drop if season == 1;

/* Results reported in Section III.E, Attrition. */;
preserve;
	duplicates drop club_id farmer_id season, force;
	tab attrition season;
restore;

/* TABLE I.A */;
if `TableIA' == 1 {;
	include "Code/do files/TableIA.do";
};	
 
/* TABLE III */; 
if `TableIII' == 1 {;
	tenancyindextable ELA_Fertil_D  ELA_Insect_D  invest_toolD if attrition == 0 ///
					, digit1(7) digit2(3) filename("TableIIIA") iterations(`ri_N');					
	tenancyindextable  ELA_Fertil_V_tr  ELA_Insect_V_tr  hha_tools_tr if attrition == 0 ///
					, digit1(7) digit2(3) filename("TableIIIB") iterations(`ri_N');					
}; 
 
/* TABLE IV */; 
if `TableIV' == 1 {;
	tenancyindextable  labor_hrs_ELA  wd_paid_ELA  wd_unpaid_ELA if attrition == 0 ///
					, digit1(5) digit2(2) filename("TableIV") iterations(`ri_N');
};

/* TABLE VI */;
if `TableVI' == 1 {;
	tenancytable  Linc_tot_tr totalexp_tr  saving_tot_tr  hhincome_tr  hhasset_tot_tr if attrition == 0 ///
					, digit1(7) digit2(2) filename("TableVI") iterations(`ri_N') regp("0 0 0 0 0");
};

/* TABLE VIII */;
if `TableVIII_col12' == 1 {;
	egen capital= rowtotal ( ELA_Fertil_V_tr   ELA_Insect_V_tr   hha_tools_tr  ), missing  ;   
	gen totalhrs= (3*4*labor_hrs_ELA) + 8*(wd_paid_ELA+wd_unpaid_ELA) ;   /* this is the total hours of labor used on the plot per month, assuming a worker spends 8 hrs per day on the plot, and assuming a season is 3 months long  */
	gen Lhours=log(totalhrs+1);
	gen Lcapital=log(capital+1);

	tenancytable Lcapital Lhours  if attrition==0 ///
					, digit1(5) digit2(2) filename("TableVIIIB_col12") iterations(`ri_N') regp("0 0");
					
	tenancytable capital totalhrs   if attrition==0 ///
					, digit1(5) digit2(2) filename("TableVIIIA_col12") iterations(`ri_N') regp("0 0");
};

/* FIGURE IV */;
if `FigureIV' == 1 {;
	include "Code/do files/FigureIV.do";
};

/* ----- ONLINE APPENDIX RESULTS ----- */;

use "Input/TenantSurvey_Data.dta", clear ;

if `SupTableXI_cols34' == 1 {;
preserve; 
	/* Drop duplictates: these are cases where we have several Farmer Surveys for a farmer and season. */;
	keep club_id farmer_id season attrition treatment_type* tt_r* superstrata  ELA_Fertil_D   worker_dys_ELA  invest_toolD;
	duplicates drop club_id farmer_id season, force;
	
	keep if season == 2;
	tab attrition;
	tenancytable attrition attrition, /// 
		digit1(5) digit2(3) filename("SupTableXI_cols34") iterations(`ri_N') regp("0 1");
restore; 
};

if `SupTableXII_cols34' == 1 {;
preserve;  
	/* Drop duplictates: these are cases where we have several Farmer Surveys for a farmer and season. */;
	keep club_id farmer_id season attrition treatment_type* tt_r* superstrata  ELA_Fertil_D   worker_dys_ELA  invest_toolD;
	duplicates drop club_id farmer_id season, force;
	
	keep if season == 3;
	tab attrition;
	tenancytable attrition attrition, /// 
		digit1(5) digit2(3) filename("SupTableXII_cols34") iterations(`ri_N') regp("0 1");
restore;  
};

/* Drop baseline season */;
drop if season == 1;

if `SupTableXXVI' == 1 {;
	tenancytablebounds labor_hrs_ELA wd_paid_ELA wd_unpaid_ELA ///
					, digit1(5) digit2(2) filename("SupTableXXVI") iterations(`ri_N') regp("0 0 0");
};

if `SupTableXXV' == 1 {;
	tenancytablebounds ELA_Fertil_D ELA_Insect_D invest_toolD  ///
					, digit1(7) digit2(3) filename("SupTableXXVA") iterations(`ri_N') regp("0 0 0");
	tenancytablebounds ELA_Fertil_V ELA_Insect_V hha_tools  ///
					, digit1(7) digit2(3) filename("SupTableXXVB") iterations(`ri_N') regp("0 0 0") trimming;					
};

if `SupTableXXVIII' == 1 {;
	tenancytablebounds  Linc_tot totalexp saving_tot hhincome hhasset_tot  ///
					, digit1(7) digit2(2) filename("SupTableXXVIII") iterations(`ri_N') regp("0 0 0 0 0") trimming;
};

if `SupTableXIII' == 1 {;		
	tenancytable R_yield_ELA R_yield_ELA R_yield_ELA_sqm R_yield_ELA_sqm if attrition == 0 ///
					, digit1(7) digit2(2) filename("SupTableXIII") iterations(`ri_N') regp("0 1 0 1");
};	
	
if `SupTableXXX' == 1 {;
	tenancytable  Cbor_friends  Cbor_mfingo  Cbor_comcoop  Cbor_lender if attrition == 0 ///
		, digit1(5) digit2(3) filename("SupTableXXXA") iterations(`ri_N') regp("0 0 0 0");
	tenancytable  Ebor_friends  Ebor_mfingo  Ebor_comcoop  Ebor_lender if attrition == 0 ///
		, digit1(5) digit2(3) filename("SupTableXXXB") iterations(`ri_N') regp("0 0 0 0");
};
		
if `SupTableXXIX' == 1 {;
	tenancyindextable  loan_now_valD  loan_now_val_tr  sec7_q9 sec7_q12 if attrition == 0 ///
					, digit1(7) digit2(3) filename("SupTableXXIX") iterations(`ri_N');
};	
		


/* ----------------------------------------------------------------------------------- 
* -----------------------------------------------------------------------------------
* ---------------------------- FAO DATA ON CROPS IN SSA -------------------------------
* ----------------------------------------------------------------------------------- 
* -----------------------------------------------------------------------------------*/ ;

if `SupTableXXB' == 1 {;

	use "Input/FAOCropData.dta", clear;

	foreach x in yield {;
	/* Maize */
	xi: areg `x' totrain i.year if itemcode==56, a(areacode) cl(areacode);
	estimates store crop1_`x', title (" ");
	/* Beans */
	xi: areg `x' totrain i.year if itemcode==414, a(areacode) cl(areacode);
	estimates store crop2_`x', title (" ");
	/* Gnuts*/
	xi: areg `x' totrain i.year if itemcode==242, a(areacode) cl(areacode);
	estimates store crop3_`x', title (" ");
	/* Tomatoes */
	xi: areg `x' totrain i.year if itemcode==388, a(areacode) cl(areacode);
	estimates store crop4_`x', title (" ");
	/* Potatoes */
	xi: areg `x' totrain i.year if itemcode==116, a(areacode) cl(areacode);
	estimates store crop5_`x', title (" ");
	};

	estout crop1_yield crop2_yield crop3_yield crop4_yield crop5_yield 
	using "Output/SupTableXXB.tex",  replace style (tex) collabels(, none) label cells(b(star fmt(%9.3f)) se(par)) 
	keep(totrain )  mlabels(, none) starlevels(* 0.10 ** 0.05 *** 0.01) stats( N, fmt( %9.0g) layout( @)  labels( "Observations") );

};	

if `SupTableXXIA' == 1 {;

	use "Input/FAOCropData.dta", clear;

	/* calculate coefficient of variation of yield per hectare by crop, using time variation within a country, or using cross-sectional variation within a given year, or both */
	foreach x in yield  {;
	replace `x'=exp(`x')-1;   /* convert log units back to levels */
	bys itemcode year: egen sd_cs_`x'=sd(`x');
	bys itemcode year: egen m_cs_`x'=mean(`x');
	bys itemcode areacode: egen sd_ts_`x'=sd(`x');
	bys itemcode areacode: egen m_ts_`x'=mean(`x');
	bys itemcode : egen sd_p_`x'=sd(`x');
	bys itemcode : egen m_p_`x'=mean(`x');
	gen cv_cs_`x'=sd_cs_`x'/m_cs_`x';
	gen cv_ts_`x'=sd_ts_`x'/m_ts_`x';
	gen cv_p_`x'=sd_p_`x'/m_p_`x';
	};
	egen tag_area=tag(areacode itemcode);
	egen tag_year=tag(year itemcode);
	for var cv_ts_yield  : replace X=. if tag_area!=1;
	for var cv_cs_yield  : replace X=. if tag_year!=1;

	/*maize*/
	su cv_cs_yield cv_ts_yield cv_p_yield  if itemcode==56;

	/*beans*/
	su cv_cs_yield cv_ts_yield cv_p_yield  if itemcode==414;

	/*gnuts*/
	su cv_cs_yield cv_ts_yield cv_p_yield  if itemcode==242;

	/*tomatoes*/
	su cv_cs_yield cv_ts_yield cv_p_yield  if itemcode==388;

	/*potatoes*/
	su cv_cs_yield cv_ts_yield cv_p_yield  if itemcode==116;

};


if `SupTableXXIB' == 1 {;

	use "Input/FAOCropPriceData.dta", clear;

	/*maize*/
	su price_cv  if itemcode==56&unit=="LCU";
	/*beans*/
	su price_cv if itemcode==414&unit=="LCU";
	/*gnuts*/
	su price_cv  if itemcode==242&unit=="LCU";
	/*tomatoes*/
	su price_cv  if itemcode==388&unit=="LCU";
	/*potatoes*/
	su price_cv  if itemcode==116&unit=="LCU";

};
