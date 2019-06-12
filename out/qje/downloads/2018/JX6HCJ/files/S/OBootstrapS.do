
****************************************
****************************************

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) re ]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	`anything' `if' `in', cluster(`cluster') `re'
	capture testparm `testvars'
	if (_rc == 0) {
		matrix F[$i,1] = r(p), r(drop), e(df_r), $k
		local i = 0
		foreach var in `testvars' {
			matrix B[$j+`i',1] = _b[`var'], _se[`var']
			local i = `i' + 1
			}
		}
global i = $i + 1
global j = $j + $k
end

****************************************
****************************************

capture program drop mycmd1
program define mycmd1
	syntax anything [if] [in] [, cluster(string) re ]
	gettoken testvars anything: anything, match(match)
	global k = wordcount("`testvars'")
	capture `anything' `if' `in', cluster(`cluster') `re'
	if (_rc == 0) {
		capture testparm `testvars'
		if (_rc == 0) {
			matrix FF[$i,1] = r(p), r(drop), e(df_r)
			matrix V = e(V)
			matrix b = e(b)
			matrix V = V[1..$k,1..$k]
			matrix b = b[1,1..$k]
			matrix f = (b-B[$j..$j+$k-1,1]')*invsym(V)*(b'-B[$j..$j+$k-1,1])
			if (e(df_r) ~= .) capture matrix FF[$i,4] = Ftail($k,e(df_r),f[1,1]/$k)
			if (e(df_r) == .) capture matrix FF[$i,4] = chi2tail($k,f[1,1])
			local i = 0
			foreach var in `testvars' {
				matrix BB[$j+`i',1] = _b[`var'], _se[`var']
				local i = `i' + 1
				}
			}
		}
global i = $i + 1
global j = $j + $k
end


****************************************
****************************************

global a = 24
global b = 60

use DatS, clear

matrix F = J($a,4,.)
matrix B = J($b,2,.)

global i = 1
global j = 1

*Table 5
foreach X in "" "0" {
	mycmd (trocp`X' treatp`X') xtreg prexp trocp`X' treatp`X' oc`X', re cluster(session) 
	}
foreach X in poexp poexp_a {
	mycmd (troca treata) xtreg `X' troca treata oc, re cluster(session)
	}

*Table 6 
foreach X in "" "0" {
	mycmd( trocp`X' treatp`X') xtreg prexp trocp`X' treatp`X' oc`X' if p1 == 1, re cluster(session) 
	}
foreach X in poexp poexp_a {
	mycmd (troca treata) xtreg `X' troca treata oc if p1 == 1, re cluster(session)
	}

*Table 7 
foreach Y in wexp wgap {
	foreach X in "" "0" {
		mycmd (trocp`X' treatp`X') xtreg `Y' trocp`X' treatp`X' oc`X' if p1 == 1, re cluster(session) 
		}
	}

mycmd (troca0 treata0) xtreg investment troca0 treata0 oc if p1==1, re cluster(session)
mycmd (troca treata) xtreg reject troca treata oc if p1==1, re cluster(session)

*Table B4
foreach X in "" "dumneg" {
	mycmd (wgaptr wgaptroc treat troc) xtprobit investment wgaptr wgaptroc treat troc wgap wgapoc dum23 oc `X' if reject==0 & role==2 , re
	}
foreach X in "" "dumneg" {
	mycmd (wgaptr wgaptroc treat troc wexptr wexptroc) xtprobit reject wgaptr wgaptroc treat troc wexptr wexptroc wgap wgapoc oc wexp2 wexpoc dumPC `X' if role==2, re
	}

*Table B5 
foreach Y in wexp wgap {
	foreach X in "" "0" {
		mycmd (trocp`X' treatp`X') xtreg `Y' trocp`X' treatp`X' oc`X', re cluster(session) 
		}
	}
mycmd (troca0 treata0) xtreg investment troca0 treata0 oc, re cluster(session)
mycmd (troca treata) xtreg reject troca treata oc, re cluster(session)

gen Order = _n
sort session Order
gen N = 1
gen Dif = (session ~= session[_n-1])
replace N = N[_n-1] + Dif if _n > 1
save aa, replace

drop if N == N[_n-1]
egen NN = max(N)
keep NN
generate obs = _n
save aaa, replace

mata ResFF = J($reps,$a,.); ResF = J($reps,$a,.); ResD = J($reps,$a,.); ResDF = J($reps,$a,.); ResB = J($reps,$b,.); ResSE = J($reps,$b,.)
forvalues c = 1/$reps {
	matrix FF = J($a,4,.)
	matrix BB = J($b,3,.)
	display "`c'"
	set seed `c'

	use aaa, clear
	quietly generate N = ceil(uniform()*NN)
	joinby N using aa
	drop session
	rename obs session

	egen newid = group(session ID)
	replace ID = newid

xtset ID

global i = 1
global j = 1

*Table 5
foreach X in "" "0" {
	mycmd1 (trocp`X' treatp`X') xtreg prexp trocp`X' treatp`X' oc`X', re cluster(session) 
	}
foreach X in poexp poexp_a {
	mycmd1 (troca treata) xtreg `X' troca treata oc, re cluster(session)
	}

*Table 6 
foreach X in "" "0" {
	mycmd1( trocp`X' treatp`X') xtreg prexp trocp`X' treatp`X' oc`X' if p1 == 1, re cluster(session) 
	}
foreach X in poexp poexp_a {
	mycmd1 (troca treata) xtreg `X' troca treata oc if p1 == 1, re cluster(session)
	}

*Table 7 
foreach Y in wexp wgap {
	foreach X in "" "0" {
		mycmd1 (trocp`X' treatp`X') xtreg `Y' trocp`X' treatp`X' oc`X' if p1 == 1, re cluster(session) 
		}
	}

mycmd1 (troca0 treata0) xtreg investment troca0 treata0 oc if p1==1, re cluster(session)
mycmd1 (troca treata) xtreg reject troca treata oc if p1==1, re cluster(session)

*Table B4
foreach X in "" "dumneg" {
	mycmd1 (wgaptr wgaptroc treat troc) xtprobit investment wgaptr wgaptroc treat troc wgap wgapoc dum23 oc `X' if reject==0 & role==2 , re
	}
foreach X in "" "dumneg" {
	mycmd1 (wgaptr wgaptroc treat troc wexptr wexptroc) xtprobit reject wgaptr wgaptroc treat troc wexptr wexptroc wgap wgapoc oc wexp2 wexpoc dumPC `X' if role==2, re
	}

*Table B5 
foreach Y in wexp wgap {
	foreach X in "" "0" {
		mycmd1 (trocp`X' treatp`X') xtreg `Y' trocp`X' treatp`X' oc`X', re cluster(session) 
		}
	}
mycmd1 (troca0 treata0) xtreg investment troca0 treata0 oc, re cluster(session)
mycmd1 (troca treata) xtreg reject troca treata oc, re cluster(session)

mata BB = st_matrix("BB"); FF = st_matrix("FF")
mata ResF[`c',1..$a] = FF[.,1]'; ResD[`c',1..$a] = FF[.,2]'; ResDF[`c',1..$a] = FF[.,3]'; ResFF[`c',1..$a] = FF[.,4]'
mata ResB[`c',1..$b] = BB[.,1]'; ResSE[`c',1..$b] = BB[.,2]'

}

drop _all
set obs $reps
foreach j in ResFF ResF ResD ResDF {
	forvalues i = 1/$a {
		quietly generate double `j'`i' = .
		}
	}
foreach j in ResB ResSE {
	forvalues i = 1/$b {
		quietly generate double `j'`i' = .
		}
	}

mata st_store(.,.,(ResFF, ResF, ResD, ResDF, ResB, ResSE))
svmat double F
svmat double B
gen N = _n
save results\OBootstrapS, replace

capture erase aa.dta
capture erase aaa.dta

