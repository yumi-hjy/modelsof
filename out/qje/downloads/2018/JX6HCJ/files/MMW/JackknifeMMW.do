

capture program drop mycmd
program define mycmd
	syntax anything [if] [in] [, cluster(string) robust absorb(string) fe]
	gettoken testvars anything: anything, match(match)
	`anything' `if' `in', cluster(`cluster') `robust' `fe'
	testparm `testvars'
	global k = r(df)
	unab testvars: `testvars'
	mata B = st_matrix("e(b)"); V = st_matrix("e(V)"); V = sqrt(diagonal(V)); BB = B[1,1..$k]',V[1..$k,1]; st_matrix("B",BB)
preserve
	keep if e(sample)
	if ("$cluster" ~= "") egen M = group($cluster)
	if ("$cluster" == "") gen M = _n
	quietly sum M
	global N = r(max)
	mata ResB = J($N,$k,.); ResSE = J($N,$k,.); ResF = J($N,3,.)
	forvalues i = 1/$N {
		if (floor(`i'/50) == `i'/50) display "`i'", _continue
		quietly `anything' if M ~= `i', cluster(`cluster') `robust' `fe'
		matrix BB = J($k,2,.)
		local c = 1
		foreach var in `testvars' {
			capture matrix BB[`c',1] = _b[`var'], _se[`var']
			local c = `c' + 1
			}
		matrix F = J(1,3,.)
		capture testparm `testvars'
		if (_rc == 0) matrix F = r(p), r(drop), e(df_r)
		mata BB = st_matrix("BB"); F = st_matrix("F"); ResB[`i',1..$k] = BB[1..$k,1]'; ResSE[`i',1..$k] = BB[1..$k,2]'; ResF[`i',1..3] = F
		}
	quietly drop _all
	quietly set obs $N
	global kk = $j + $k - 1
	forvalues i = $j/$kk {
		quietly generate double ResB`i' = .
		}
	forvalues i = $j/$kk {
		quietly generate double ResSE`i' = .
		}
	quietly generate double ResF$i = .
	quietly generate double ResD$i = .
	quietly generate double ResDF$i = .
	mata X = ResB, ResSE, ResF; st_store(.,.,X)
	quietly svmat double B
	quietly rename B2 SE$i
	capture rename B1 B$i
	save ip\JK$i, replace
restore
	global i = $i + 1
	global j = $j + $k
end



*******************


global cluster = "sheno"

use DatMMW, clear

global i = 1
global j = 1

*All of these xtregs are simple regressions with fixed effects (no re) - but stata's method of calculation involves different finite sample correction - see paper

*Table 2
mycmd (amount amount_female) xtreg realprof amount amount_female wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, fe cluster (sheno)
mycmd (amount amount_female) xtreg adjprof3 amount amount_female wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, fe cluster (sheno)
mycmd (firstyear_amount secondyear_amount thirdyear_amount) xtreg adjprof3 firstyear_amount secondyear_amount thirdyear_amount wave2-wave9 wave10 wave11 if Sample == 1 & sample2==1 & femaleverified==0, fe cluster(sheno)
mycmd (firstyear_amount secondyear_amount thirdyear_amount) xtreg adjprof3 firstyear_amount secondyear_amount thirdyear_amount wave2-wave9 wave10 wave11 if Sample == 1 & sample2==1 & femaleverified==1, fe cluster(sheno)

*Table 3 
mycmd (amount100 amount200 female_100 female_200) xtreg K2_noland amount100 amount200 female_100 female_200 wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 & prof~=., fe cluster(sheno)
mycmd (amount100 amount200 female_100 female_200) xtreg K2_noland amount100 amount200 female_100 female_200 wave2-wave4 femaleverified_wave2-femaleverified_wave4 if Sample == 1 & ets>1 & sample2==1 & prof~=. & timesince<=1 & wave<=4 , fe cluster(sheno)
mycmd (amount100 amount200 female_100 female_200) xtreg adjprof3 amount100 amount200 female_100 female_200 wave2-wave9 wave10 wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, fe cluster(sheno)
mycmd (inv_amount eq_amount) xtreg adjprof3 inv_amount eq_amount wave2-wave9 wave10 wave11 if Sample == 1 & ets>1 & sample2==1 & trtmnt_reported==trtmnt_actual & femaleverified==0, fe cluster (sheno)
mycmd (inv_amount eq_amount) xtreg adjprof3 inv_amount eq_amount wave2-wave9 wave10 wave11 if Sample == 1 & ets>1 & sample2==1 & trtmnt_reported==trtmnt_actual & femaleverified==1, fe cluster (sheno)

*Table 5 
mycmd (amount100 amount200 amount100_female amount200_female amount100_nwageworkers amount100_assetindex amount200_nwageworkers amount200_assetindex amount100_female_nwageworkers amount100_female_assetindex amount200_female_nwageworkers amount200_female_assetindex) xtreg K2_noland amount100 amount200 amount100_female amount200_female amount100_nwageworkers amount100_assetindex amount200_nwageworkers amount200_assetindex amount100_female_nwageworkers amount100_female_assetindex amount200_female_nwageworkers amount200_female_assetindex wave2-wave9 wave10 wave11  nwageworkers_wave2-nwageworkers_wave11 assetindex_wave2-assetindex_wave11 femaleverified_wave2-femaleverified_wave11   if Sample == 1 & ets>1 & sample2==1 , fe cluster (sheno)
mycmd (amount100 amount200 amount100_female amount200_female amount100_ednyearsFIRM amount100_p_digitspan amount200_ednyearsFIRM amount200_p_digitspan amount100_female_ednyearsFIRM amount100_female_p_digitspan amount200_female_ednyearsFIRM amount200_female_p_digitspan) xtreg K2_noland amount100 amount200 amount100_female amount200_female amount100_ednyearsFIRM amount100_p_digitspan amount200_ednyearsFIRM amount200_p_digitspan amount100_female_ednyearsFIRM amount100_female_p_digitspan amount200_female_ednyearsFIRM amount200_female_p_digitspan wave2-wave9 wave10 wave11   ednyearsFIRM_wave2-ednyearsFIRM_wave11 p_digitspan_wave2-p_digitspan_wave11     femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , fe cluster (sheno)
mycmd (amount100 amount200 amount100_female amount200_female amount100_p_lotBcrra amount200_p_lotBcrra amount100_female_p_lotBcrra amount200_female_p_lotBcrra) xtreg K2_noland amount100 amount200 amount100_female amount200_female amount100_p_lotBcrra amount200_p_lotBcrra amount100_female_p_lotBcrra amount200_female_p_lotBcrra    wave2-wave9 wave10 wave11 p_lotBcrra_wave2-p_lotBcrra_wave11  femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , fe cluster (sheno)
mycmd (amount100 amount200 amount100_female amount200_female amount100_nwageworkers amount100_assetindex amount100_ednyearsFIRM amount100_p_digitspan amount100_p_lotBcrra amount200_nwageworkers amount200_assetindex amount200_ednyearsFIRM amount200_p_digitspan  amount200_p_lotBcrra amount100_female_nwageworkers amount100_female_assetindex amount100_female_ednyearsFIRM amount100_female_p_digitspan  amount100_female_p_lotBcrra amount200_female_nwageworkers amount200_female_assetindex amount200_female_ednyearsFIRM amount200_female_p_digitspan amount200_female_p_lotBcrra) xtreg K2_noland amount100 amount200 amount100_female amount200_female amount100_nwageworkers amount100_assetindex amount100_ednyearsFIRM amount100_p_digitspan amount100_p_lotBcrra amount200_nwageworkers amount200_assetindex amount200_ednyearsFIRM amount200_p_digitspan  amount200_p_lotBcrra  amount100_female_nwageworkers amount100_female_assetindex amount100_female_ednyearsFIRM amount100_female_p_digitspan  amount100_female_p_lotBcrra amount200_female_nwageworkers amount200_female_assetindex amount200_female_ednyearsFIRM amount200_female_p_digitspan amount200_female_p_lotBcrra wave2-wave9 wave10 wave11 nwageworkers_wave2-nwageworkers_wave11 assetindex_wave2-assetindex_wave11 ednyearsFIRM_wave2-ednyearsFIRM_wave11 p_lotBcrra_wave2-p_lotBcrra_wave11 p_digitspan_wave2-p_digitspan_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , fe cluster (sheno)
mycmd (amount100 amount200 amount100_female amount200_female amount100_nwageworkers amount100_assetindex amount200_nwageworkers amount200_assetindex amount100_female_nwageworkers amount100_female_assetindex amount200_female_nwageworkers amount200_female_assetindex) xtreg adjprof3 amount100 amount200 amount100_female amount200_female amount100_nwageworkers amount100_assetindex amount200_nwageworkers amount200_assetindex amount100_female_nwageworkers amount100_female_assetindex amount200_female_nwageworkers amount200_female_assetindex  wave2-wave9 wave10 wave11 nwageworkers_wave2-nwageworkers_wave11 assetindex_wave2-assetindex_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , fe cluster (sheno)
mycmd (amount100 amount200 amount100_female amount200_female amount100_ednyearsFIRM amount100_p_digitspan amount200_ednyearsFIRM amount200_p_digitspan amount100_female_ednyearsFIRM amount100_female_p_digitspan amount200_female_ednyearsFIRM amount200_female_p_digitspan) xtreg adjprof3 amount100 amount200 amount100_female amount200_female amount100_ednyearsFIRM amount100_p_digitspan amount200_ednyearsFIRM amount200_p_digitspan amount100_female_ednyearsFIRM amount100_female_p_digitspan amount200_female_ednyearsFIRM amount200_female_p_digitspan wave2-wave9 wave10 wave11   ednyearsFIRM_wave2-ednyearsFIRM_wave11  p_digitspan_wave2-p_digitspan_wave11     femaleverified_wave2-femaleverified_wave11   if Sample == 1 & ets>1 & sample2==1 , fe cluster (sheno)
mycmd (amount100 amount200 amount100_female amount200_female amount100_p_lotBcrra amount200_p_lotBcrra amount100_female_p_lotBcrra amount200_female_p_lotBcrra) xtreg adjprof3 amount100 amount200 amount100_female amount200_female amount100_p_lotBcrra amount200_p_lotBcrra amount100_female_p_lotBcrra amount200_female_p_lotBcrra    wave2-wave9 wave10 wave11   p_lotBcrra_wave2-p_lotBcrra_wave11  femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , fe cluster (sheno)
mycmd (amount100 amount200 amount100_female amount200_female amount100_nwageworkers amount100_assetindex amount100_ednyearsFIRM amount100_p_digitspan amount100_p_lotBcrra amount200_nwageworkers amount200_assetindex amount200_ednyearsFIRM amount200_p_digitspan amount200_p_lotBcrra amount100_female_nwageworkers amount100_female_assetindex amount100_female_ednyearsFIRM amount100_female_p_digitspan amount100_female_p_lotBcrra amount200_female_nwageworkers amount200_female_assetindex amount200_female_ednyearsFIRM amount200_female_p_digitspan amount200_female_p_lotBcrra) xtreg adjprof3 amount100 amount200 amount100_female amount200_female amount100_nwageworkers amount100_assetindex amount100_ednyearsFIRM amount100_p_digitspan  amount100_p_lotBcrra amount200_nwageworkers amount200_assetindex amount200_ednyearsFIRM amount200_p_digitspan  amount200_p_lotBcrra  amount100_female_nwageworkers amount100_female_assetindex amount100_female_ednyearsFIRM amount100_female_p_digitspan  amount100_female_p_lotBcrra amount200_female_nwageworkers amount200_female_assetindex amount200_female_ednyearsFIRM amount200_female_p_digitspan  amount200_female_p_lotBcrra wave2-wave9 wave10 wave11   nwageworkers_wave2-nwageworkers_wave11 assetindex_wave2-assetindex_wave11   ednyearsFIRM_wave2-ednyearsFIRM_wave11 p_lotBcrra_wave2-p_lotBcrra_wave11 p_digitspan_wave2-p_digitspan_wave11      femaleverified_wave2-femaleverified_wave11   if Sample == 1 & ets>1 & sample2==1 , fe cluster (sheno)

*Table 6 
foreach X in timetosolve fatherbus motherbus optimismI p_carer reasongrow4 athomebus selfefficacy financialliteracy impulsiveness passionforwork tenacity locusofcontrol trust achievement powermotivation polychronicity workcentrality organization {
	mycmd (amount100 amount200 amount100_female amount200_female amount100_`X' amount200_`X' amount100_fem_`X' amount200_fem_`X') xtreg adjprof3 amount100 amount200 amount100_female amount200_female amount100_`X' amount200_`X' amount100_fem_`X' amount200_fem_`X' wave2-wave9 wave10 wave11 `X'_wave2-`X'_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, fe cluster (sheno)	
	}

*Table 7 
mycmd (amount100 amount200 amount100_female amount200_female amount100_propfem amount200_propfem amount100_propfem_fem amount200_propfem_fem) xtreg K2_noland amount100 amount200 amount100_female amount200_female amount100_propfem amount200_propfem amount100_propfem_fem amount200_propfem_fem wave2-wave9 wave10 wave11 propfem_wave2-propfem_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , fe cluster (sheno)
mycmd (amount100 amount200 amount100_female amount200_female amount100_propfem amount200_propfem amount100_propfem_fem amount200_propfem_fem) xtreg adjprof3 amount100 amount200 amount100_female amount200_female amount100_propfem amount200_propfem amount100_propfem_fem amount200_propfem_fem wave2-wave9 wave10 wave11 propfem_wave2-propfem_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , fe cluster (sheno)
mycmd (amount100 amount200 amount100_female amount200_female amount100_pindfemale amount200_pindfemale amount100_pindfemale_fem amount200_pindfemale_fem) xtreg K2_noland amount100 amount200 amount100_female amount200_female amount100_pindfemale amount200_pindfemale amount100_pindfemale_fem amount200_pindfemale_fem wave2-wave9 wave10 wave11 pindfemale_wave2-pindfemale_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , fe cluster (sheno)
mycmd (amount100 amount200 amount100_female amount200_female amount100_pindfemale amount200_pindfemale amount100_pindfemale_fem amount200_pindfemale_fem) xtreg adjprof3 amount100 amount200 amount100_female amount200_female amount100_pindfemale amount200_pindfemale amount100_pindfemale_fem amount200_pindfemale_fem wave2-wave9 wave10 wave11 pindfemale_wave2-pindfemale_wave11 femaleverified_wave2-femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1 , fe cluster (sheno)

*Table 8 
foreach X in enroll5to12 enroll12to15 enroll17to18 rexp_month_groceries rexp_month_health rexp_month_education {
	mycmd (amount100 amount200 amount100_female amount200_female) xtreg `X' amount100 amount200 amount100_female amount200_female wave5 wave9 wave11 femaleverified_wave5 femaleverified_wave9 femaleverified_wave11 if Sample == 1 & ets>1 , fe cluster (sheno)
	}
mycmd (amount100 amount200 amount100_female amount200_female) xtreg assetindex1 amount100 amount200 amount100_female amount200_female wave5 wave9 wave11 femaleverified_wave5 femaleverified_wave9 femaleverified_wave11 if Sample == 1 & ets>1 & sample2==1, fe cluster (sheno)

*Table 9 
foreach X in K2_noland adjprof3 inv fixed {
	mycmd (amount100 amount200 amount100_power amount200_power) xtreg `X' amount100 amount200 amount100_power amount200_power wave2-wave9 wave10 wave11 power_wave2 - power_wave11 if Sample == 1 & ets>1 & sample2==1 & femaleverified==1, fe cluster(sheno)	
	}


use ip\JK1, clear
forvalues i = 2/51 {
	merge using ip\JK`i'
	tab _m
	drop _m
	}
quietly sum B1
global k = r(N)
mkmat B1 SE1 in 1/$k, matrix(B)
forvalues i = 2/51 {
	quietly sum B`i'
	global k = r(N)
	mkmat B`i' SE`i' in 1/$k, matrix(BB)
	matrix B = B \ BB
	}
drop B* SE*
svmat double B
aorder
save results\JackKnifeMMW, replace


