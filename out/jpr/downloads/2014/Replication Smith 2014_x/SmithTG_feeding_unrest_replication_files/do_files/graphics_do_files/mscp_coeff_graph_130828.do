********** MOTHER NATURE AND MARKETS **********
********** WRITTEN BY TODD G. SMITH ***********
********** UPDATED 14 MARCH 2013 **************

loc index `1'
use "results/`index'_results/mscp_months/fe18.dta", clear
keep if var == "l_dry_mscp" | var == "l_wet_mscp"
set obs 3
gen months = 18
sort var
save "results/`index'_results/fs_results_by_mscp.dta", replace

foreach n of numlist 15(3)3 {
	clear
	use "results/`index'_results/mscp_months/fe`n'.dta"
	keep if var == "l_dry_mscp" | var == "l_wet_mscp"
	set obs 3
	gen months = `n'
	sort var
	append using "results/`index'_results/fs_results_by_mscp.dta"
	save "results/`index'_results/fs_results_by_mscp.dta", replace
	}

egen variable = fill(1 2)
lab def variable	1 "MSCP over 3 months" ///
lab val variable variable
*drop var
*egen var = concat(months variable)
*destring var, replace

gen ub_95 = coef + (1.96 * stderr)
lab var ub_95 " "
gen lb_95 = coef - (1.96 * stderr)
lab var lb_95 "95% conf interval"

gen sig_01 = coef
replace sig_01 = . if (abs(coef) - (2.576 * stderr)) < 0
lab var sig_01 "significant at alpha = 0.01"
gen sig_05 = coef
replace sig_05 = . if (abs(coef) - (1.96 * stderr)) < 0
replace sig_05 = . if sig_01 != .
lab var sig_05 "significant at alpha = 0.05"
replace coef = . if sig_01 != . | sig_05 != .

twoway (rcap lb_95 ub_95 variable, lcolor(gs9) horizontal) ///
	(scatter variable coef, msymbol(circle) mlcolor(gs9) mfcolor(white))  ///
	(scatter variable sig_05, msymbol(circle) mcolor(gs9))  ///
	(scatter variable sig_01, msymbol(circle) mcolor(black)),      ///
	ytitle(, size(zero)) ///
	yscale(reverse) ///
	ylabel(1(1)18, valuelabel angle(horizontal) labsize(small) noticks) ///
	xtitle("Marginal effect on standardized % change in food prices") ///
	xtitle(, size(medsmall) margin(small)) ///
	xlabel(, grid) ///
	legend(size(vsmall) region(lcolor(none)) order(1 "95% confidence interval" 2 "not significant at alpha = 0.1" 3 "significant at alpha = 0.05" 4 "significant at alpha = 0.01") span) ///
	xsize(5) ysize(4) scheme(s1mono) name(mscp_est_mono, replace)
graph export "graphs/`index'_graphs/mscp_est_std_fc_mono.pdf", replace

twoway (rcap lb_95 ub_95 variable, lcolor(dkgreen) horizontal) ///
	(scatter variable coef, msymbol(circle) mlcolor(dkgreen) mfcolor(white))  ///
	(scatter variable sig_05, msymbol(circle) mcolor(dkgreen))  ///
	(scatter variable sig_01, msymbol(circle) mcolor(dkorange)),      ///
	ytitle(, size(zero)) ///
	yscale(reverse) ///
	ylabel(1(1)18, valuelabel angle(horizontal) labsize(small) noticks) ///
	xtitle("Marginal effect on standardized % change in food prices") ///
	xtitle(, size(medsmall) margin(small)) ///
	title("MSCP Estimates over Different Accumulation Periods", size(medium) margin(medium)) ///
	xlabel(, grid) ///
	legend(size(vsmall) region(lcolor(none)) order(1 "95% confidence interval" 2 "not significant at alpha = 0.1" 3 "significant at alpha = 0.05" 4 "significant at alpha = 0.01") span) ///
	xsize(5) ysize(4) scheme(s1color) name(mscp_est_color, replace)
graph export "graphs/`index'_graphs/mscp_est_std_fc_color.pdf", replace

exit

/*
egen variable = fill(1 2)
lab def variable	1 "MSCP over 3 months     " ///
lab val variable variable
*drop var
*egen var = concat(months variable)
*destring var, replace

gen sig_01 = coef
replace sig_01 = . if (abs(coef) - (2.576 * stderr)) < 0
lab var sig_01 "significant at alpha = 0.01"
gen sig_05 = coef
replace sig_05 = . if (abs(coef) - (1.96 * stderr)) < 0
lab var sig_05 "significant at alpha = 0.05"

gen ub_95 = coef + (1.96 * stderr)
lab var ub_95 " "
gen lb_95 = coef - (1.96 * stderr)
lab var lb_95 "95% conf interval"

twoway  (rcap lb_95 ub_95 variable, lcolor(gs9) horizontal) ///
	(scatter variable coef, msymbol(circle) mlcolor(gs9) mfcolor(white))  ///
	(scatter variable sig_05, msymbol(circle) mcolor(gs9))  ///
	(scatter variable sig_01, msymbol(circle) mcolor(black)),      ///
	ytitle(, size(zero)) ///
	yscale(reverse) ///
	ylabel(1(1)24, valuelabel angle(horizontal) labsize(small) noticks) ///
	xtitle("Marginal effect on % change in consumer food prices") ///
	xtitle(, size(medsmall) margin(small)) ///
	xlabel(-.2(.1).4, grid) xmtick(##2) ///
	legend(size(small) region(lcolor(none))) ///
	xsize(5) ysize(4) scheme(s1mono)
*/

exit