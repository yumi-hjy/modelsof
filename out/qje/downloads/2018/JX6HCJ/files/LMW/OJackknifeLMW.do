
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, ll hc3 robust vce(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', `ll' 
	if (_rc == 0) {
		local i = 0
		foreach var in `testvars' {
			matrix B[$j+`i',1] = _b[`var']
			local i = `i' + 1
			}
		}
global j = $j + $k
end

****************************************
****************************************

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, ll hc3 robust vce(string)]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', `ll' 
	if (_rc == 0) {
		local i = 0
		foreach var in `testvars' {
			matrix BB[$j+`i',1] = _b[`var']
			local i = `i' + 1
			}
		}
global j = $j + $k
end


****************************************
****************************************

global b = 11

use DatLMW, clear

matrix B = J($b,1,.)

global j = 1
*Table 1
mycmd (sorting) reg percshared sorting , hc3
mycmd (sorting sortBarcelona) reg percshared sorting sortBarcelona Barcelona, hc3
mycmd (sorting) tobit percshared sorting , ll vce(jackknife)
mycmd (sorting sortBarcelona) tobit percshared sorting sortBarcelona Barcelona, ll vce(jackknife)	
mycmd (sorting) probit percshared sorting , robust
mycmd (sorting sortBarcelona) probit percshared sorting sortBarcelona Barcelona, robust

*Table 2
mycmd (sorting) reg percshared sorting female ethCatalan ethAsian ethWhite SES_middle SES_upmid EducHighDegr Major_INDICATED_BusEcon schoolBerkeley schoolUPF Sib_0 Sib_1 Sib_more donation likerisk, hc3
mycmd (sorting) reg percshared sorting , hc3

global reps = _N

mata ResB = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix BB = J($b,1,.)
	display "`c'"

preserve

drop if _n == `c'

global j = 1

*Table 1
mycmd1 (sorting) reg percshared sorting , hc3
mycmd1 (sorting sortBarcelona) reg percshared sorting sortBarcelona Barcelona, hc3
mycmd1 (sorting) tobit percshared sorting , ll vce(jackknife)
mycmd1 (sorting sortBarcelona) tobit percshared sorting sortBarcelona Barcelona, ll vce(jackknife)	
mycmd1 (sorting) probit percshared sorting , robust
mycmd1 (sorting sortBarcelona) probit percshared sorting sortBarcelona Barcelona, robust

*Table 2
mycmd1 (sorting) reg percshared sorting female ethCatalan ethAsian ethWhite SES_middle SES_upmid EducHighDegr Major_INDICATED_BusEcon schoolBerkeley schoolUPF Sib_0 Sib_1 Sib_more donation likerisk, hc3
mycmd1 (sorting) reg percshared sorting , hc3

mata BB = st_matrix("BB"); ResB[`c',1..$b] = BB[.,1]'

restore

}

drop _all
set obs $reps
forvalues i = 1/$b {
	quietly generate double ResB`i' = .
	}
mata st_store(.,.,ResB)
svmat double B
gen N = _n
save results\OJackknifeLMW, replace


