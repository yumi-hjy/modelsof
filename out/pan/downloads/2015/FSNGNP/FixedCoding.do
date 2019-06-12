*======================================================================================================*
*------------------------------------------------------------------------------------------------------*
*======================================================================================================*
*DATE CREATED: 10.06.2014
*DATES MODIFIED: 
*AUTHOR: Allyson L. Pellissier
*PROJECT: GQ Replication
*PURPOSE: This file replicates the Glynn-Quinn analysis for the 2004 cross-section but fixes the error in EDR coding.
*======================================================================================================*
*------------------------------------------------------------------------------------------------------*
*======================================================================================================*



clear
clear matrix
set more off
# delimit ;

*------------------------------------------------------------------------------------------------------*
// DATASET;
*------------------------------------------------------------------------------------------------------*

	clear;
	use CPS_04.dta;
	keep HUFAMINC GESTCEN PRTAGE PESEX PEEDUCA PTDTRACE PES1 PES2 ;

	
	// Restricting the Sample ;
		drop if GESTCEN == 44 				/* North Dakota does not require voter registration */;

		keep if PES1 == 1 | PES1 == 2 			/* GQ drop those who do not answer the turnout question */;
			replace PES1 = 0 if PES1 == 2 		/* changing the value of "no" from 2 to 0 */ ;
			replace PES2 = 1 if PES1 == 1 		/* coding voters as registered */;
	
		keep if PES2 == 1 | PES2 == 2 			/* GQ drop those who do not answer the registration question */;
			replace PES2 = 0 if PES2 == 2 		/* changing the value of "no" from 2 to 0 */;

		keep if PTDTRACE == 2 				/* restricting the sample to black voters */;	

		replace PRTAGE =. if PRTAGE > 80 		/* GQ code age as missing when age >80, the highest value in the codebook */;
		replace HUFAMINC =. if HUFAMINC < 1 		/* GQ code income as missing when income < 1, the lowest value in the codebook */;


	// Creating a Variable for Election Day Registration ;
		gen EDR = 0.;
			replace EDR = 1 if GESTCEN == 35				/* WI */;
			replace EDR = 1 if GESTCEN == 41				/* MN */;
			replace EDR = 1 if GESTCEN == 11				/* ME */;
			replace EDR = 1 if GESTCEN == 12				/* NH */;
			replace EDR = 1 if GESTCEN == 83				/* WY */;
			replace EDR = 1 if GESTCEN == 82				/* ID */;

	// Interaction Terms ;
		gen EDR_HUFAMINC = EDR*HUFAMINC ;
		gen EDR_PESEX = EDR*PESEX ;
		gen HUFAMINC_PESEX = HUFAMINC*PESEX ;
		gen EDR_PRTAGE = EDR*PRTAGE ;
		gen PESEX_PRTAGE = PESEX*PRTAGE ;
		gen EDR_PEEDUCA = EDR*PEEDUCA ;
		gen PESEX_PEEDUCA = PESEX*PEEDUCA ;
		gen EDR_HUFAMINC_PESEX = EDR*HUFAMINC*PESEX ;
		gen EDR_PESEX_PRTAGE = EDR*PESEX*PRTAGE ;
		gen EDR_PESEX_PEEDUCA = EDR*PESEX*PEEDUCA ;


	
	
	
	save GlynnQuinn_A.dta, replace ;

	

	clear ;
	gen ATC =. ;
	save ATC1_A.dta, replace ;
	save ATC2_A.dta, replace ;
	save ATC3_A.dta, replace ;
	save ATC4_A.dta, replace ;
	save ATC5_A.dta, replace ;
	save ATC6_A.dta, replace ;
	save ATC7_A.dta, replace ;
	save ATC8_A.dta, replace ;
	save ATC9_A.dta, replace ;



log using GQ_A.log, replace ;




*------------------------------------------------------------------------------------------------------*
// MODEL 1 ;
*------------------------------------------------------------------------------------------------------*
;
	use GlynnQuinn_A.dta, clear ;

	// Estimate model and ATC ;
		logit PES1 EDR HUFAMINC PESEX PRTAGE PEEDUCA EDR_HUFAMINC EDR_PESEX EDR_PRTAGE EDR_PEEDUCA HUFAMINC_PESEX PESEX_PRTAGE PESEX_PEEDUCA EDR_HUFAMINC_PESEX EDR_PESEX_PRTAGE EDR_PESEX_PEEDUCA ;
			keep if e(sample) ;
				predict y0 if EDR == 0 									/* fitted probability for each control unit */;
				predict yxb if EDR == 0, xb 								/* linear prediction for each control unit */;
				gen y1 = invlogit(yxb + _b[EDR] + _b[EDR_HUFAMINC]*HUFAMINC + _b[EDR_PESEX]*PESEX + _b[EDR_PRTAGE]*PRTAGE + _b[EDR_PEEDUCA]*PEEDUCA + _b[EDR_HUFAMINC_PESEX]*HUFAMINC_PESEX + _b[EDR_PESEX_PRTAGE]*PESEX_PRTAGE + _b[EDR_PESEX_PEEDUCA]*PESEX_PEEDUCA) if EDR == 0		/* imputed counterfactual for each control unit */;
				gen ATC = y1 - y0 if EDR == 0								/* estimated TE for each control unit */;
				su ATC 											/* mean is the ATC from the fitted model */;
				drop y0 yxb y1 ATC ;
				
		save model1_A, replace ;

log close ;		
	// Estimate bootstrapped standard errors for ATC ;
		forvalues i = 1/1100 { ;
			use model1_A, clear	 ;
			bsample	;
			quietly: logit PES1 EDR HUFAMINC PESEX PRTAGE PEEDUCA EDR_HUFAMINC EDR_PESEX EDR_PRTAGE EDR_PEEDUCA HUFAMINC_PESEX PESEX_PRTAGE PESEX_PEEDUCA EDR_HUFAMINC_PESEX EDR_PESEX_PRTAGE EDR_PESEX_PEEDUCA, iterate(20) ;
				keep if e(sample) ;
				predict y0 if EDR == 0 & _se[EDR] != 0 ;
				predict yxb if EDR == 0 & _se[EDR] != 0, xb ;
				generate y1 = invlogit(yxb + _b[EDR] + _b[EDR_HUFAMINC]*HUFAMINC + _b[EDR_PESEX]*PESEX + _b[EDR_PRTAGE]*PRTAGE + _b[EDR_PEEDUCA]*PEEDUCA + _b[EDR_HUFAMINC_PESEX]*HUFAMINC_PESEX + _b[EDR_PESEX_PRTAGE]*PESEX_PRTAGE + _b[EDR_PESEX_PEEDUCA]*PESEX_PEEDUCA) if EDR == 0 & _se[EDR] != 0	/* imputed counterfactual for each control unit */;
				generate delta = y1 - y0 if EDR == 0 & _se[EDR] != 0 ;
			egen ATC = mean(delta) if EDR == 0 & _se[EDR] != 0 ;
				drop if ATC ==. & _se[EDR] > 0 ;
				keep ATC ;
				duplicates drop ;
			append using ATC1_A.dta ;
				save ATC1_A.dta, replace ;
			} ;

log using GQ_A.log, append ;
		count if ATC ==. & _n <= 1000 ;
		drop if ATC ==. ;
		drop if _n > 1000 ;
		count ;
		
		_pctile ATC, p(2.5, 97.5) ;
		return list ;
		clear ;



*------------------------------------------------------------------------------------------------------*
// MODEL 2 ;
*------------------------------------------------------------------------------------------------------*
;
	use GlynnQuinn_A.dta, clear ;

	// Estimate model and ATC ;
		logit PES1 EDR HUFAMINC PESEX PRTAGE PEEDUCA EDR_HUFAMINC EDR_PESEX EDR_PRTAGE EDR_PEEDUCA HUFAMINC_PESEX PESEX_PRTAGE PESEX_PEEDUCA ;
			keep if e(sample) ;
				predict y0 if EDR == 0 									/* fitted probability for each control unit */;
				predict yxb if EDR == 0, xb 								/* linear prediction for each control unit */;
				generate y1 = invlogit(yxb + _b[EDR] + _b[EDR_HUFAMINC]*HUFAMINC + _b[EDR_PESEX]*PESEX + _b[EDR_PRTAGE]*PRTAGE + _b[EDR_PEEDUCA]*PEEDUCA) if EDR == 0						/* imputed counterfactual for each control unit */;
				generate ATC = y1 - y0 if EDR == 0								/* estimated TE for each control unit */;
				su ATC 											/* mean is the ATC from the fitted model */;
				drop y0 yxb y1 ATC ;
				
		save model2_A, replace ;

log close ;		
	// Estimate bootstrapped standard errors for ATC ;
		forvalues i = 1/1100 { ;
			use model2_A, clear	 ;
			bsample	;
			quietly: logit PES1 EDR HUFAMINC PESEX PRTAGE PEEDUCA EDR_HUFAMINC EDR_PESEX EDR_PRTAGE EDR_PEEDUCA HUFAMINC_PESEX PESEX_PRTAGE PESEX_PEEDUCA, iterate(20) ;
				keep if e(sample) ;
				predict y0 if EDR == 0 & _se[EDR] != 0 ;
				predict yxb if EDR == 0 & _se[EDR] != 0, xb ;
				generate y1 = invlogit(yxb + _b[EDR] + _b[EDR_HUFAMINC]*HUFAMINC + _b[EDR_PESEX]*PESEX + _b[EDR_PRTAGE]*PRTAGE + _b[EDR_PEEDUCA]*PEEDUCA) if EDR == 0 & _se[EDR] != 0				/* imputed counterfactual for each control unit */;
				generate delta = y1 - y0 if EDR == 0 & _se[EDR] != 0 ;
			egen ATC = mean(delta) if EDR == 0 & _se[EDR] != 0 ;
				drop if ATC ==. & _se[EDR] > 0 ;
				keep ATC ;
				duplicates drop ;
			append using ATC2_A.dta ;
				save ATC2_A.dta, replace ;
			} ;

log using GQ_A.log, append ;
		count if ATC ==. & _n <= 1000 ;
		drop if ATC ==. ;
		drop if _n > 1000 ;
		count ;
		
		_pctile ATC, p(2.5, 97.5) ;
		return list ;
		clear ;


*------------------------------------------------------------------------------------------------------*
// MODEL 3 ;
*------------------------------------------------------------------------------------------------------*
;
	use GlynnQuinn_A.dta, clear ;

	// Estimate model and ATC ;
		logit PES1 EDR HUFAMINC PESEX PRTAGE PEEDUCA EDR_HUFAMINC EDR_PESEX EDR_PRTAGE EDR_PEEDUCA ;
			keep if e(sample) ;
				predict y0 if EDR == 0 									/* fitted probability for each control unit */;
				predict yxb if EDR == 0, xb 								/* linear prediction for each control unit */;
				gen y1 = invlogit(yxb + _b[EDR] + _b[EDR_HUFAMINC]*HUFAMINC + _b[EDR_PESEX]*PESEX + _b[EDR_PRTAGE]*PRTAGE + _b[EDR_PEEDUCA]*PEEDUCA) if EDR == 0						/* imputed counterfactual for each control unit */;
				gen ATC = y1 - y0 if EDR == 0								/* estimated TE for each control unit */;
				su ATC 											/* mean is the ATC from the fitted model */;
				drop y0 yxb y1 ATC ;
				
		save model3_A, replace ;

log close ;		
	// Estimate bootstrapped standard errors for ATC ;
		forvalues i = 1/1100 { ;
			use model3_A, clear	 ;
			bsample	;
			quietly: logit PES1 EDR HUFAMINC PESEX PRTAGE PEEDUCA EDR_HUFAMINC EDR_PESEX EDR_PRTAGE EDR_PEEDUCA, iterate(20) ;
				keep if e(sample) ;
				predict y0 if EDR == 0 & _se[EDR] != 0 ;
				predict yxb if EDR == 0 & _se[EDR] != 0, xb ;
				gen y1 = invlogit(yxb + _b[EDR] + _b[EDR_HUFAMINC]*HUFAMINC + _b[EDR_PESEX]*PESEX + _b[EDR_PRTAGE]*PRTAGE + _b[EDR_PEEDUCA]*PEEDUCA) if EDR == 0 & _se[EDR] != 0						/* imputed counterfactual for each control unit */;
				generate delta = y1 - y0 if EDR == 0 & _se[EDR] != 0 ;
			egen ATC = mean(delta) if EDR == 0 & _se[EDR] != 0 ;
				drop if ATC ==. & _se[EDR] > 0 ;
				keep ATC ;
				duplicates drop ;
			append using ATC3_A.dta ;
				save ATC3_A.dta, replace ;
			} ;

log using GQ_A.log, append ;
		count if ATC ==. & _n <= 1000 ;
		drop if ATC ==. ;
		drop if _n > 1000 ;
		count ;
		
		_pctile ATC, p(2.5, 97.5) ;
		return list ;
		clear ;



*------------------------------------------------------------------------------------------------------*
// MODEL 4 ;
*------------------------------------------------------------------------------------------------------*
;
	use GlynnQuinn_A.dta, clear ;

	// Estimate model and ATC ;
		logit PES1 EDR HUFAMINC PESEX PRTAGE PEEDUCA ;
			keep if e(sample) ;
				predict y0 if EDR == 0 									/* fitted probability for each control unit */;
				predict yxb if EDR == 0, xb 								/* linear prediction for each control unit */;
				gen y1 = invlogit(yxb + _b[EDR]) if EDR == 0						/* imputed counterfactual for each control unit */;
				generate ATC = y1 - y0 if EDR == 0								/* estimated TE for each control unit */;
				su ATC 											/* mean is the ATC from the fitted model */;
				drop y0 yxb y1 ATC ;
				
		save model4_A, replace ;

log close ;		
	// Estimate bootstrapped standard errors for ATC ;
		forvalues i = 1/1100 { ;
			use model4_A, clear	 ;
			bsample	;
			quietly: logit PES1 EDR HUFAMINC PESEX PRTAGE PEEDUCA, iterate(20) ;
				keep if e(sample) ;
				predict y0 if EDR == 0 & _se[EDR] != 0 ;
				predict yxb if EDR == 0 & _se[EDR] != 0, xb ;
				gen y1 = invlogit(yxb + _b[EDR]) if EDR == 0 & _se[EDR] != 0						/* imputed counterfactual for each control unit */;
				generate delta = y1 - y0 if EDR == 0 & _se[EDR] != 0 ;
			egen ATC = mean(delta) if EDR == 0 & _se[EDR] != 0 ;
				drop if ATC ==. & _se[EDR] > 0 ;
				keep ATC ;
				duplicates drop ;
			append using ATC4_A.dta ;
				save ATC4_A.dta, replace ;
			} ;

log using GQ_A.log, append ;
		count if ATC ==. & _n <= 1000 ;
		drop if ATC ==. ;
		drop if _n > 1000 ;
		count ;
		
		_pctile ATC, p(2.5, 97.5) ;
		return list ;
		clear ;




*------------------------------------------------------------------------------------------------------*
// MODEL 5 ;
*------------------------------------------------------------------------------------------------------*
;
	use GlynnQuinn_A.dta, clear ;

	// Estimate model and ATC ;
		logit PES1 EDR HUFAMINC PESEX PRTAGE ;
			keep if e(sample) ;
				predict y0 if EDR == 0 									/* fitted probability for each control unit */;
				predict yxb if EDR == 0, xb 								/* linear prediction for each control unit */;
				gen y1 = invlogit(yxb + _b[EDR]) if EDR == 0						/* imputed counterfactual for each control unit */;
				generate ATC = y1 - y0 if EDR == 0								/* estimated TE for each control unit */;
				su ATC 											/* mean is the ATC from the fitted model */;
				drop y0 yxb y1 ATC ;
				
		save model5_A, replace ;
		
log close ;
	// Estimate bootstrapped standard errors for ATC ;
		forvalues i = 1/1100 { ;
			use model5_A, clear	 ;
			bsample	;
			quietly: logit PES1 EDR HUFAMINC PESEX PRTAGE, iterate(20) ;
				keep if e(sample) ;
				predict y0 if EDR == 0 & _se[EDR] != 0 ;
				predict yxb if EDR == 0 & _se[EDR] != 0, xb ;
				gen y1 = invlogit(yxb + _b[EDR]) if EDR == 0 & _se[EDR] != 0						/* imputed counterfactual for each control unit */;
				generate delta = y1 - y0 if EDR == 0 & _se[EDR] != 0 ;
			egen ATC = mean(delta) if EDR == 0 & _se[EDR] != 0 ;
				drop if ATC ==. & _se[EDR] > 0 ;
				keep ATC ;
				duplicates drop ;
			append using ATC5_A.dta ;
				save ATC5_A.dta, replace ;
			} ;

log using GQ_A.log, append ;
		count if ATC ==. & _n <= 1000 ;
		drop if ATC ==. ;
		drop if _n > 1000 ;
		count ;
		
		_pctile ATC, p(2.5, 97.5) ;
		return list ;
		clear ;
		
		


*------------------------------------------------------------------------------------------------------*
// MODEL 6 ;
*------------------------------------------------------------------------------------------------------*
;
	use GlynnQuinn_A.dta, clear ;

	// Estimate model and ATC ;
		logit PES1 EDR HUFAMINC PESEX PEEDUCA ;
			keep if e(sample) ;
				predict y0 if EDR == 0 									/* fitted probability for each control unit */;
				predict yxb if EDR == 0, xb 								/* linear prediction for each control unit */;
				gen y1 = invlogit(yxb + _b[EDR]) if EDR == 0						/* imputed counterfactual for each control unit */;
				generate ATC = y1 - y0 if EDR == 0								/* estimated TE for each control unit */;
				su ATC 											/* mean is the ATC from the fitted model */;
				drop y0 yxb y1 ATC ;
				
		save model6_A, replace ;

log close ;		
	// Estimate bootstrapped standard errors for ATC ;
		forvalues i = 1/1100 { ;
			use model6_A, clear	 ;
			bsample	;
			quietly: logit PES1 EDR HUFAMINC PESEX PEEDUCA, iterate(20) ;
				keep if e(sample) ;
				predict y0 if EDR == 0 & _se[EDR] != 0 ;
				predict yxb if EDR == 0 & _se[EDR] != 0, xb ;
				gen y1 = invlogit(yxb + _b[EDR]) if EDR == 0 & _se[EDR] != 0						/* imputed counterfactual for each control unit */;
				generate delta = y1 - y0 if EDR == 0 & _se[EDR] != 0 ;
			egen ATC = mean(delta) if EDR == 0 & _se[EDR] != 0 ;
				drop if ATC ==. & _se[EDR] > 0 ;
				keep ATC ;
				duplicates drop ;
			append using ATC6_A.dta ;
				save ATC6_A.dta, replace ;
			} ;

log using GQ_A.log, append ;
		count if ATC ==. & _n <= 1000 ;
		drop if ATC ==. ;
		drop if _n > 1000 ;
		count ;
		
		_pctile ATC, p(2.5, 97.5) ;
		return list ;
		clear ;




*------------------------------------------------------------------------------------------------------*
// MODEL 7 ;
*------------------------------------------------------------------------------------------------------*
;
	use GlynnQuinn_A.dta, clear ;

	// Estimate model and ATC ;
		logit PES1 EDR HUFAMINC PRTAGE PEEDUCA ;
			keep if e(sample) ;
				predict y0 if EDR == 0 									/* fitted probability for each control unit */;
				predict yxb if EDR == 0, xb 								/* linear prediction for each control unit */;
				gen y1 = invlogit(yxb + _b[EDR]) if EDR == 0						/* imputed counterfactual for each control unit */;
				generate ATC = y1 - y0 if EDR == 0								/* estimated TE for each control unit */;
				su ATC 											/* mean is the ATC from the fitted model */;
				drop y0 yxb y1 ATC ;
				
		save model7_A, replace ;

log close ;		
	// Estimate bootstrapped standard errors for ATC ;
		forvalues i = 1/1100 { ;
			use model7_A, clear	 ;
			bsample	;
			quietly: logit PES1 EDR HUFAMINC PRTAGE PEEDUCA, iterate(20) ;
				keep if e(sample) ;
				predict y0 if EDR == 0 & _se[EDR] != 0 ;
				predict yxb if EDR == 0 & _se[EDR] != 0, xb ;
				gen y1 = invlogit(yxb + _b[EDR]) if EDR == 0 & _se[EDR] != 0						/* imputed counterfactual for each control unit */;
				generate delta = y1 - y0 if EDR == 0 & _se[EDR] != 0 ;
			egen ATC = mean(delta) if EDR == 0 & _se[EDR] != 0 ;
				drop if ATC ==. & _se[EDR] > 0 ;
				keep ATC ;
				duplicates drop ;
			append using ATC7_A.dta ;
				save ATC7_A.dta, replace ;
			} ;

log using GQ_A.log, append ;
		count if ATC ==. & _n <= 1000 ;
		drop if ATC ==. ;
		drop if _n > 1000 ;
		count ;
		
		_pctile ATC, p(2.5, 97.5) ;
		return list ;
		clear ;






*------------------------------------------------------------------------------------------------------*
// MODEL 8 ;
*------------------------------------------------------------------------------------------------------*
;
	use GlynnQuinn_A.dta, clear ;

	// Estimate model and ATC ;
		logit PES1 EDR PESEX PRTAGE PEEDUCA ;
			keep if e(sample) ;
				predict y0 if EDR == 0 									/* fitted probability for each control unit */;
				predict yxb if EDR == 0, xb 								/* linear prediction for each control unit */;
				gen y1 = invlogit(yxb + _b[EDR]) if EDR == 0						/* imputed counterfactual for each control unit */;
				generate ATC = y1 - y0 if EDR == 0								/* estimated TE for each control unit */;
				su ATC 											/* mean is the ATC from the fitted model */;
				drop y0 yxb y1 ATC ;
				
		save model8_A, replace ;
		
log close ;
	// Estimate bootstrapped standard errors for ATC ;
		forvalues i = 1/1100 { ;
			use model8_A, clear	 ;
			bsample	;
			quietly: logit PES1 EDR PESEX PRTAGE PEEDUCA, iterate(20) ;
				keep if e(sample) ;
				predict y0 if EDR == 0 & _se[EDR] != 0 ;
				predict yxb if EDR == 0 & _se[EDR] != 0, xb ;
				gen y1 = invlogit(yxb + _b[EDR]) if EDR == 0 & _se[EDR] != 0						/* imputed counterfactual for each control unit */;
				generate delta = y1 - y0 if EDR == 0 & _se[EDR] != 0 ;
			egen ATC = mean(delta) if EDR == 0 & _se[EDR] != 0 ;
				drop if ATC ==. & _se[EDR] > 0 ;
				keep ATC ;
				duplicates drop ;
			append using ATC8_A.dta ;
				save ATC8_A.dta, replace ;
			} ;

log using GQ_A.log, append ;
		count if ATC ==. & _n <= 1000 ;
		drop if ATC ==. ;
		drop if _n > 1000 ;
		count ;
		
		_pctile ATC, p(2.5, 97.5) ;
		return list ;
		clear ;		



*------------------------------------------------------------------------------------------------------*
// MODEL 9 ;
*------------------------------------------------------------------------------------------------------*
;
	use GlynnQuinn_A.dta, clear ;

	// Estimate model and ATC ;
		logit PES1 EDR ;
			keep if e(sample) ;
				predict y0 if EDR == 0 									/* fitted probability for each control unit */;
				predict yxb if EDR == 0, xb 								/* linear prediction for each control unit */;
				gen y1 = invlogit(yxb + _b[EDR]) if EDR == 0						/* imputed counterfactual for each control unit */;
				generate ATC = y1 - y0 if EDR == 0								/* estimated TE for each control unit */;
				su ATC 											/* mean is the ATC from the fitted model */;
				drop y0 yxb y1 ATC ;
				
		save model9_A, replace ;

log close ;		
	// Estimate bootstrapped standard errors for ATC ;
		forvalues i = 1/1100 { ;
			use model9_A, clear	 ;
			bsample	;
			quietly: logit PES1 EDR, iterate(20) ;
				keep if e(sample) ;
				predict y0 if EDR == 0 & _se[EDR] != 0 ;
				predict yxb if EDR == 0 & _se[EDR] != 0, xb ;
				gen y1 = invlogit(yxb + _b[EDR]) if EDR == 0 & _se[EDR] != 0						/* imputed counterfactual for each control unit */;
				generate delta = y1 - y0 if EDR == 0 & _se[EDR] != 0 ;
			egen ATC = mean(delta) if EDR == 0 & _se[EDR] != 0 ;
				drop if ATC ==. & _se[EDR] > 0 ;
				keep ATC ;
				duplicates drop ;
			append using ATC9_A.dta ;
				save ATC9_A.dta, replace ;
			} ;

log using GQ_A.log, append ;
		count if ATC ==. & _n <= 1000 ;
		drop if ATC ==. ;
		drop if _n > 1000 ;
		count ;
		
		_pctile ATC, p(2.5, 97.5) ;
		return list ;
		clear ;





log close ;
