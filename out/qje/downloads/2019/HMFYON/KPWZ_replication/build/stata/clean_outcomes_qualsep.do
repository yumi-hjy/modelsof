
*******************************************************************************
*******************************************************************************
* BUILD WAGE OUTCOMES
*******************************************************************************
*******************************************************************************
set more off
clear 
set maxvar 8000


*******************************************************************************
*1.0 LOAD WAGE DATA COMPONENTS
*******************************************************************************

use $dumpdir/outcomes_patent_eins_w2_qualsep.dta, clear

*******************************************************************************
*1.1 LOAD WAGE DATA
*******************************************************************************

duplicates drop
keep unmasked_tin year  ///
abv* w2* num*
destring unmasked_tin, replace 
drop if unmasked_tin==.

*******************************************************************************
* 2. Reshape
*******************************************************************************
rename abv_med_qual_bln q
rename abv_med_sep_bln s

g hqhs=(q==1 & s==1)
g hqls=(q==1 & s==0)
g lqhs=(q==0 & s==1)
g lqls=(q==0 & s==0)

tempfile data
save `data'

foreach case in hqhs hqls lqhs lqls {
use `data', clear
keep if `case'==1

rename w2_bln_qual_sep wage_`case'
rename num_bln_qual_sep emp_`case'

*******************************************************************************
* 3. Adjust for Inflation
*******************************************************************************
usd2014, var(wage_`case') yr(year) 

*******************************************************************************
* 4.1 clean up here to avoid carrying around emp
*******************************************************************************

replace wage_`case'    =. if emp_`case'==0
*******************************************************************************
* 4.2 SAVE Data
*******************************************************************************
drop q s h* l*

g form="w2"
sort unmasked_tin year
save $dtadir/outcomes_patent_qualsep_`case'.dta, replace
}

