/*
** last changes: January 2018  by: J. Spenkuch (j-spenkuch@kellogg.northwestern.edu)
*/
if c(os) == "Unix" {
	global PATH "/projects/p30061"
	global PATHdata "/projects/p30061/data"
	global PATHcode "/projects/p30061/code"
	global PATHlogs "/projects/p30061/logs"
	
	cd $PATH
}
else if c(os) == "Windows" {
	global PATH "R:/Dropbox/research/advertising_paper/analysis"
	global PATHdata "R:/Dropbox/research/advertising_paper/analysis/input"
	global PATHcode "R:/Dropbox/research/advertising_paper/analysis/code"
	global PATHlogs "R:/Dropbox/research/advertising_paper/analysis/output"
	
	cd $PATH
}
else {
    display "unable to recognize OS -> abort!"
    exit
}


include code/preamble.do


log using output/log_tableA9.txt, replace text



include code/set_globals.do

*-------------------------------------------------------
* table A9: sensitivity_turnout
*-------------------------------------------------------

global spec1  "turnout cmag_prez_ptya_base lag_turnout_pres $extra_controls_ptya $demo_controls, absorb(state_pair_year); baseline"
global spec2  "turnout cmag_prez_ptya_base lag_turnout_pres $extra_controls_ptya $demo_controls [aw=weight], absorb(state_pair_year); county_weight"
global spec3  "turnout cmag_prez_ptya_base lag_turnout_pres $extra_controls_ptya $demo_controls if pct_pair_pop <= 0.15, absorb(state_pair_year); pop_share15"
global spec4  "turnout cmag_prez_ptya_base lag_turnout_pres $extra_controls_ptya $demo_controls if pct_pair_pop <= 0.10, absorb(state_pair_year); pop_share10"
global spec5  "turnout cmag_prez_ptya_base lag_turnout_pres $extra_controls_ptya $demo_controls if pct_pair_pop <= 0.05, absorb(state_pair_year); pop_share5"
global spec6  "turnout cmag_prez_ptya_base lag_turnout_pres $extra_controls_ptya $demo_controls if pct_pair_pop <= 0.02, absorb(state_pair_year); pop_share2"
global spec7  "turnout cmag_prez_ptya_1knads lag_turnout_pres cand_visits cmag_oth_ptya_1knads $media_controls $demo_controls, absorb(state_pair_year); nads"
global spec8  "turnout cmag_prez_ptya_grp lag_turnout_pres cand_visits cmag_oth_ptya_grp $media_controls $demo_controls, absorb(state_pair_year); grps"
global spec9  "turnout cmag_prez_ptya_180days lag_turnout_pres cand_visits cmag_oth_ptya_180days $media_controls $demo_controls, absorb(state_pair_year); within_180days"
global spec10 "turnout cmag_prez_ptya_120days lag_turnout_pres cand_visits cmag_oth_ptya_120days $media_controls $demo_controls, absorb(state_pair_year); within_120days"
global spec11 "turnout cmag_prez_ptya_30days lag_turnout_pres cand_visits cmag_oth_ptya_30days $media_controls $demo_controls, absorb(state_pair_year); within_30days"
global spec12 "turnout cmag_prez_ptya_2plus lag_turnout_pres cand_visits cmag_oth_ptya_2plus $media_controls $demo_controls, absorb(state_pair_year); 2_plus_grp"
global spec13 "turnout cmag_prez_ptya_natl lag_turnout_pres cand_visits cmag_oth_ptya_natl $media_controls $demo_controls, absorb(state_pair_year); include_natl"
global spec14 "turnout cmag_prez_ptya_base lag_turnout_pres $extra_controls_ptya $demo_controls if battleground == 1, absorb(state_pair_year); battleground"
global spec15 "turnout cmag_prez_ptya_base lag_turnout_pres $extra_controls_ptya $demo_controls if battleground == 0, absorb(state_pair_year); non_battleground"
global spec16 "turnout cmag_prez_ptya_uniq lag_turnout_pres cand_visits cmag_oth_ptya_uniq $media_controls $demo_controls, absorb(state_pair_year); unique_ads"
global spec17 "turnout cmag_prez_ptya_base lag_turnout_pres $extra_controls_ptya $demo_controls if pair_cd_match & cd_pct_max >= 0.80, absorb(state_pair_year); cd_match_80"
global spec18 "turnout cmag_prez_ptya_base lag_turnout_pres $extra_controls_ptya $demo_controls if pair_cd_match & cd_pct_max >= 0.90, absorb(state_pair_year); cd_match_90"
global spec19 "turnout cmag_prez_ptya_base lag_turnout_pres $extra_controls_ptya $demo_controls if pair_cd_match & cd_pct_max >= 0.95, absorb(state_pair_year); cd_match_95"
global spec20 "turnout cmag_prez_ptya_base lag_turnout_pres $extra_controls_ptya $demo_controls if pair_cd_match & cd_pct_max >= 0.99, absorb(state_pair_year); cd_match_99"
global spec21 "turnout cmag_prez_ptya_base lag_turnout_pres $extra_controls_ptya $demo_controls if pop_share_minority < med_minorities, absorb(state_pair_year); lo_minorities"
global spec22 "turnout cmag_prez_ptya_base lag_turnout_pres $extra_controls_ptya $demo_controls if pop_share_minority >= med_minorities, absorb(state_pair_year); hi_minorities"
global spec23 "turnout cmag_prez_ptya_base lag_turnout_pres $extra_controls_ptya $demo_controls if edu_colplus < med_college, absorb(state_pair_year); lo_educ"
global spec24 "turnout cmag_prez_ptya_base lag_turnout_pres $extra_controls_ptya $demo_controls if edu_colplus >= med_college, absorb(state_pair_year); hi_educ"
global spec25 "turnout cmag_prez_ptya_base lag_turnout_pres $extra_controls_ptya $demo_controls if battleground_index>0, absorb(state_pair_year); democratic"
global spec26 "turnout cmag_prez_ptya_base lag_turnout_pres $extra_controls_ptya $demo_controls if battleground_index==0, absorb(state_pair_year); tossup"
global spec27 "turnout cmag_prez_ptya_base lag_turnout_pres $extra_controls_ptya $demo_controls if battleground_index<0, absorb(state_pair_year); republican"

use input/sample_countypairs, clear

*xtset state_pair_year

by year, sort: egen med_minorities = median(pop_share_minority)
by year, sort: egen med_college = median(edu_colplus)

by state_county year, sort: egen appearances=count(county)
gen weight = 1/appearances

foreach year in ALL 2004 2008 2012 {
    
    preserve
    if inlist("`year'","2004","2008","2012") keep if year == `year' 
    local matrix_rownames ""    
    capture matrix drop TABLE_`year'

    forvalues n = 1/27 {
	local spec_match = regexm("${spec`n'}","(.*);(.*)")
	local spec_reg = regexs(1)
	local spec_name = trim(regexs(2))
	tokenize "`spec_reg'"
	if `n'==2 {
	   	di "reghdfe `spec_reg' vce(cluster state segment)"
	    reghdfe `spec_reg' vce(cluster state segment)
	}
	else {
	    di "xtreg `spec_reg' vce(cluster state segment)"
	    reghdfe `spec_reg' vce(cluster state segment)
    }      
	test `2' = 0 
	matrix TABLE1 = ((_b[`2'] \ _se[`2']), (r(p) \ . ))
	matrix TABLE_`year' = (nullmat(TABLE_`year') \ (TABLE1))
	local matrix_rownames = "`matrix_rownames' b_`spec_name' se_`spec_name'"
    
    }
    restore
}

matrix TABLE_YEAR = (TABLE_ALL, TABLE_2004, TABLE_2008, TABLE_2012)
matrix list TABLE_YEAR
display "`matrix_rownames'"
matrix rownames TABLE_YEAR = `matrix_rownames'
matrix colnames TABLE_YEAR = coef_all pvalue_all coef_2004 pvalue_2004 coef_2008 pvalue_2008 coef_2012 pvalue_2012
putexcel set output/tables.xlsx, sheet("sensitivity_turnout", replace) modify
putexcel A1=matrix(TABLE_YEAR), names









log close