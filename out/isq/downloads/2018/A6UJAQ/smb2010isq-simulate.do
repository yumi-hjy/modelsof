version 9.2#delimit;set more off;clear;set mem 500m;  quietly log;  local logon = r(status);  if "`logon'" == "on" {; log close; };log using smb2010isq-simulate, text replace; /*	************************************************************	*//*     	File Name:	smb2010isq-simulate.do				*//*     	Date:   	July 12, 2011 					*//*      Author: 	Dan Morey and Frederick J. Boehmke		*//*      Purpose:	This file replicates the generation of Figure	*//*			1 for the duration with selection models of 	*//*			of conflict onset and duration. 		*//*      Input File: 	smb2010isq.dta					*//*      Output File:	smb2010isq-simulate.log,			*//*      		smb2010isq-simulate.dta				*//* 	Requires:	dursel.ado, durselgr.ado			*//*	Version:	Stata 9.2 or above.				*//*	************************************************************	*/	/****************************************************************/	/* This program generates the predicted survivor and hazard	*/	/* functions for a given data set. It does so at multiple 	*/	/* specific values of the variable of interest. It is designed	*/	/* to pass the imputation number to keep track of which data	*/	/* set is being used.						*/	/****************************************************************/capture program drop mipred;program define mipred;  version 9.2;  syntax varlist [if] [in] , indvar(varname) depvar(varname) impnum(integer);  tempname min max pctl;  marksample touse, novarlist;    quietly sum `indvar' if `touse', detail;	local io_p0   = r(min);	local io_p10  = r(p10);	local io_p25  = r(p25);	local io_p50  = r(p50);	local io_p75  = r(p75);	local io_p90  = r(p90);	local io_p100 = r(max);  quietly sum `depvar' if `touse';	local min=r(min);	local max=r(max);  quietly collapse (mean) COWIO_noneg jdemo2 totactor majdyad hihost pratio distance 	strtyr dur_peac _spline1 _spline2 _spline3 if `touse';	quietly expand 2;	quietly generat `depvar' = `min' if _n==1;	quietly replace `depvar' = `max' if _n==2;  foreach value of numlist 0 10 25 50 75 90 100 {;	local pctl io_p`value';  	quietly replace `indvar' = ``pctl'';  	quietly durselgr `depvar', saving(smb201isq-simulate-`impnum'_p`value', replace) nograph;	};  drop _all;		/* Create an empty data set to combine the results 	*/		/* for each value of the independent variable. 		*/  quietly save smb2010isq-simulate-imp`impnum', replace emptyok;  foreach value of numlist 0 10 25 50 75 90 100 {;		quietly use smb201isq-simulate-`impnum'_p`value', clear;	  local pctl io_p`value';	  quietly generat `indvar' = ``pctl'';	quietly append using smb2010isq-simulate-imp`impnum';  	quietly save smb2010isq-simulate-imp`impnum', replace;		/* Clean up the temporary data sets for each value of the independent variable. */		quietly erase smb201isq-simulate-`impnum'_p`value'.dta;	};end;	/****************************************************************/	/* This program combines the results from the imputed data 	*/	/* sets. The model is run once on each data set and the  	*/	/* resulting coefficient vectors and covariance matrices are 	*/	/* saved to combine according to the formula. -micombine- won't	*/	/* work since it's a user-written MLE.				*/	/****************************************************************/	capture program drop midisp;program define midisp;	local names: colnames(Q1);	matrix Q = (Q1 + Q2 + Q3 + Q4 + Q5)/5;		/* MI parameter vectors.*/	matrix W = (W1 + W2 + W3 + W4 + W5)/5;		/* MI covariances.     	*/	local  k = colsof(Q);				/* Number of parameters.*/	forvalues i=1/5 {;	  matrix QQ=Q`i'-Q;	  if `i'==1 {;		matrix B=(QQ)'*QQ;		};	  else matrix B = B + (QQ)'*QQ;	};	matrix B=B/(5-1);				/* Covariance adjustment with 5 imputations. */	matrix V=W+(1+1/5)*B;				/* Final covariance.   	*/	ereturn post Q V;				/* Display the results. */	ereturn display, plus neq(2);        _diparm Z_alpha, prob label("Z_alpha");	_diparm Z_alpha, prob label("rho") function(((exp(2*(@))-1)/(exp(2*(@))+1))/4)		derivative((4*exp(2*@)/(exp(2*@)+1)^2)/4);		        di in smcl in gr "{hline 13}{c BT}{hline 64}";	_diparm ln_p, level(`level') prob label("ln_p");	_diparm ln_p, level(`level') prob label("p") function(exp(@)) derivative(exp(@));		        di in smcl in gr "{hline 78}";end;	/****************************************************************/	/* Now open up the data set and for each imputation run the 	*/	/* model and generate the predicted survivor functions.		*/	/****************************************************************/forvalues id=1/5 {;  quietly use smb2010isq, clear;		/* Unscale the IO variable. */      quietly replace COWIO_noneg = COWIO_noneg*10;        		/* Create non-negative versions of IO variable for interpretation.	*/		/* Imputations may be negative, but that's okay for estimation.		*/    generat COWIO_noneg = max(COWIO,0);    display in yellow "Running model on dataset " `id';  quietly dursel cumdurat COWIO_noneg jdemo2 totactor majdyad hihost pratio distance strtyr if imputeid==`id', 	select(enter =  COWIO_noneg jdemo2 pratio majdyad distance dur_peac _spline1 _spline2 _spline3) 	dist(weibull) time cluster(dyadid);  matrix Q`id' = e(b);  matrix W`id' = e(V);    mipred cumdurat if e(sample), depvar(cumdurat) indvar(COWIO_noneg) impnum(`id');  };midisp;	/****************************************************************/	/* Combine the resulting data sets of predicted values.		*/	/****************************************************************/forvalues id=1/5 {;if `id' == 1 {;  use smb2010isq-simulate-imp1, clear;  };else {;  append using smb2010isq-simulate-imp`id';  };		/* Clean up the temporary data sets for each imputation. */  erase smb2010isq-simulate-imp`id'.dta;};save smb2010isq-simulate, replace;	/****************************************************************/	/* Collapse across imputations to get the average predictions,	*/	/* reshape to make one variable for each prediction, and then	*/	/* calculate the changes in the estimated survivor functions. 	*/	/****************************************************************/  collapse (mean) haz surv, by(_t COWIO_noneg);		/* This creates a variable number 1-7 for each value of COWIO_noneg. */	  	egen COWIO_noneg_sim = group(COWIO_noneg);		/* Go from long to wide format to have one variable for each value. */		reshape wide hazard survival COWIO_noneg, i(_t) j(COWIO_noneg_sim);	generat surv_diff_25_75 = survival5 - survival3;	generat surv_diff_10_90 = survival6 - survival2;	generat surv_diff_0_100 = survival7 - survival1;	save smb2010isq-simulate, replace;	/****************************************************************/	/* Open up the original data to calculate a density plot of 	*/	/* observed length of MIDs and merge with predictions.		*/	/****************************************************************/use smb2010isq, clear;  keep if cumdurat !=. & imputeid==1;  kdensity cumdurat, generate(days days_dens) n(100000);  keep days*;		/* Now append the predicted changes in the survivor function. */    append using smb2010isq-simulate;  	save smb2010isq-simulate, replace;	/****************************************************************/	/* Create the graph for Figure 01.				*/	/****************************************************************/twoway line surv_diff_25_75 surv_diff_10_90 surv_diff_0_100 _t if _t < 500, scheme(s1mono) sort 	lwidth(medthick medthick medthick) 	lpattern(solid longdash dash_dot) 	lcolor(black black black)	xtitle("Failure Time") 	yaxis(1) 	ytitle("Change in Survivor Function") 	ylabel(#5, grid axis(1))	legend(cols(2) rows(2) label(1 "From 25th to 75th Percentile") label(2 "From 10th to 90th Percentile")	  label(3 "From Minimum to Maximum") label(4 "Kernel Density Estimate of Durations") 	  size(small) symxsize(*.75))    ||  line days_dens days if days > 0.5 & days < 500, sort 	lwidth(medthin) 	lpattern(shortdash)	yaxis(2) 	ytitle("Density of Observed Durations", axis(2)) 	saving(smb2010isq-simulate-fig01, replace);log close;clear;exit, STATA;