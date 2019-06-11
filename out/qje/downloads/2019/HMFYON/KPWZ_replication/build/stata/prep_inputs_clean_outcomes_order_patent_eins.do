
*******************************************************************************
*******************************************************************************
* PREP input files for clean_outcomes
*******************************************************************************
*******************************************************************************
set more off
clear 
set maxvar 8000

*******************************************************************************
*1.0 LOAD CSV OF EIN-YEAR-worker quality index
*******************************************************************************
insheet using $rawdir/order.csv, clear	

*******************************************************************************
*2.0 CLEAN AND RENAME ELEMENTS
*******************************************************************************

rename payer_tin_w2_max tin
rename tax_yr year
rename mean_wages_by_order wage

*******************************************************************************
*3.0 SAVE
*******************************************************************************
compress
sort tin year
save $dumpdir/outcomes_patent_order.dta, replace

