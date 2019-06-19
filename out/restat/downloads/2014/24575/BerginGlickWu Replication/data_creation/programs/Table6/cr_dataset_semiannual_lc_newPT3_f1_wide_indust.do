 ** Traded goods in LOCAL currency, Semi-Annual observations

** Does not convert to USD, leaves in local currency. For use in
** Part 3, separating price change effects from exchange rate effects.

** First filter: data will be filtered out if doesn't have 2 obs/year for all years
** Drops additional data: Istanbul

clear
capture log close
set more off
set mem 700m
set maxvar 30000
set varabbrev off
capture program drop _all


global programpath "P:\BerginGlickWu Replication\data_creation\programs"
global outpath1 "P:\BerginGlickWu Replication\data_creation\datasets"
global datapath1 "P:\BerginGlickWu Replication\data_creation\original"
cd "$programpath"


** Load the dataset with all the q's, years 1990-2006. sorted by city1, city2, 
**   series_title

use "$datapath1\price_dispersion_lc_semiannual_f1.dta", clear

encode series_title, generate(series_title1)
drop series_title
rename series_title1 series_title

** drop countries with currency reforms whose data wasn't smoothed **
/*
	Argentina
	Brazil
	Ecuador
	Mexico
	Peru
	Poland
	Russia
	Uruguay
*/

drop if country1 == 1 | country2 == 1
drop if country1 == 6 | country2 == 6
drop if country1 == 16 | country2 == 16
drop if country1 == 37 | country2 == 37
drop if country1 == 47 | country2 == 47
drop if country1 == 49  | country2 == 49
drop if country1 == 51 | country2 == 51
drop if country1 == 68 | country2 == 68

** exclude same country pairs

drop if country1 == country2
************ New drops***********************************
** Dropping Istanbul by dropping Turkey (country code is 64)
drop if country1==64 | country2==64
********************************************************
********************************************************
**** Using .ado file to constrain data to pairs where US is numeraire
dataconstr_indust
********************************************************
***********************************************************************
sort city1 city2 series_title

**** Time-balancing and renaming: dropping any series which do not have full 35 observations
gen includeDummy = 1

forvalues i = 1990/2007 {
	rename q`i'_1 q1`i'
	replace includeDummy = 0 if q1`i' == .
}

forvalues i = 1990/2006 {
	rename q`i'_2 q2`i'
	replace includeDummy = 0 if q2`i' == .

}
compress _all

keep if includeDummy == 1
drop includeDummy
sort city1 city2 series_title
by city1 city2: gen numgoods = [_N]							// Number of goods for a given pair, plus XR
by city1 city2: replace numgoods = 0 if series_title[_N] != 102		// Must have XR
tempfile data_lc
save "`data_lc'", replace

**** Must create one dataset for each of CS and PW constraints (will end up up with about 15000 variables)
**********************************************************************************************************
***** PW first
**********************************************************************************************************
keep if ERprod_PWonecity == 1 & numgoods > 1			// Must have XR plus one good
** Creating pairid's
egen pairid = group(city1 city2)
keep pairid series_title q* CS ERprod_PWonecity
quietly summ pairid
local pairmax = r(max)

*******************************************************
** Separating out the exchange rate for use in part III
preserve
keep if series_title == 102

res_wide_semiannual_lc_all
sort date
forvalues m=1/`pairmax' {
	quietly rename q`m' s_`m'
}

keep s_* date
tempfile nomxr
save "`nomxr'", replace
restore
*******************************************************

drop if series_title == 102			//dropping xr
**Reshaping the data to wide format using the following .ado file

res_wide_semiannual_lc_all
sort series_title date
forvalues m=1/`pairmax' {
	rename q`m' p_`m'_
	drop CS`m' ERprod_PWonecity`m'
}
reshape wide p_* , i(date) j(series_title)
sort date
merge date using "`nomxr'", nolabel
drop _merge

save "$outpath1/semiannual_lc_newPT3_PWT_f1_wide_indust.dta", replace


exit
