/*--------------------------------------------------------------

Rent-price ratio plausibility: Norway
----------------------------------------------------------------*/ 

clear all
set more off

*======================= Path settings =============================================

cd "${main_dir}"

include paths


*======================= Import data ==============================================

* 1/ Additional data for Norway
import excel using "${rore}/src/raw_data/excel/r_p/rp_NOR.xlsx", clear

keep A B C D H
rename A year
rename B iso
rename C numbeo_city
rename D numbeo_noncity
rename H rp_newspapers
drop if inlist(_n,1)
destring year numbeo_city numbeo_noncity rp_newspapers, replace
sort iso year

* 2/ RORE dataset
merge 1:1 iso year using "${rore}/bld/data_out/rore_core_dataset.dta", nogen

keep if iso == "NOR"


*======================= Manipulations ==============================================
* Convert ratios to net

local tonet numbeo_city numbeo_noncity rp_newspapers
foreach n of local tonet	{
	gen `n'_net = `n'*${netgross}
}

*======================= Labels ==============================================
label var numbeo_city_net "Numbeo (city centers)"
label var numbeo_noncity_net "Numbeo (rest of the country)"
label var dp_unadj "Unadjusted estimates, rent-price approach"
label var dp_baseline "Rent-price ratio, final series"
label var bs_netrent_pct "Balance sheet approach"
label var rp_newspapers_net "Newspapers"

*======================= Graph settings ==============================================
* Lines
local lines dp_baseline dp_unadj numbeo_city_net numbeo_noncity_net rp_newspapers_net bs_netrent_pct
local colors dkgreen orange ebbblue purple blue brown
local symbols O Oh Dh Th d t
local clines dash none none none none none none

su year if dp_baseline !=.
local start = r(min)

* Scales
local ysc 0(0.03)0.15

*======================= Graph ==============================================
scatter `lines' year if iso=="NOR" & year>=`start', ///
	msize(small small small small small small)  msymbol(`symbols') ///
	connect(l) clpattern(`clines') ///
	mcolor(`colors') lcolor(`colors') ///
	xtitle("") xlabel(#15,labsize(small)) ///
	ytitle("Rent-price ratio") ylabel(`ysc',labsize(small)) ///
	tline(1914 1915 1916 1917 1918 1919 1939 1940 1941 1942 1943 1944 1945, lc(gs14) lw(vthick)) ///
	scheme(s1color) ///
	legend(size(vsmall) col(1) ring(0) position(7)  symxsize(*0.7))
graph export "${rore}/bld/graphs/accuracy/rp_plaus/NOR_plaus.pdf", replace
graph export "${qje_figures}/Figure_A21.pdf", replace

* Save data not in core RORE dataset
ren rp_newspapers_net rp_newspapers_nor_net
keep iso year numbeo* rp_newspapers_nor*
save "${rore}/bld/data_out/rp_plaus/NOR.dta", replace
