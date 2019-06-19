* Graphs
* ======
clear
clear matrix
set more off
set mem 700m

use  synthresults_merged_Killed_P99.dta, clear

local MaxLEAD = 10
local MaxLEADplus1 = `MaxLEAD' + 1


preserve
	drop *synth*
	keep  YearsFromLD   gdppccteus_*_*PL*_100

	* Placebo Average Treatment effects
	local placebosfor_P99_56  "9  13 14  17  28 29  35  38  39  41  43  46  55  59  60  62  65  67  72  74  79  84  88  89  91  92  97  100 102 107 115 126 129 138 139 146 147 149 151 153 154 159 160 173 182 185 187 188 195 200 201 212 214"
	local placebosfor_P99_85  "9  13 14	 17	 28	29	35	38	39	41	43	46	55	59	60	62	65	67	72	74	79	84	88	89	91	92	97	100	102	107	115	126	129	138	139	146	147	149	151	153	154	159	160	173	182	185	187	188	195	200	201	212	214"

	* Rename for Reshape
	
	rename  gdppccteus_56_PL0_100 gdppccteus_b100_56_PL0
	foreach pl of numlist `placebosfor_P99_56'{
			rename  gdppccteus_56_PL`pl'_100 gdppccteus_b100_56_PL`pl'
	}
	rename  gdppccteus_85_PL0_100 gdppccteus_b100_85_PL0
	foreach pl of numlist `placebosfor_P99_85'{
			rename  gdppccteus_85_PL`pl'_100 gdppccteus_b100_85_PL`pl'
	}
	
	drop gdppccteus_93_PL0_100
	drop gdppccteus_145_PL0_100
	
	  reshape long  gdppccteus_b100_56_PL  gdppccteus_b100_85_PL                                               , i(YearsFromLD) j(Placebo)

	sort  YearsFromLD Placebo
	save	 gdppccteus_Placebos_P99-NoRev.dta, replace

restore

preserve

	keep  YearsFromLD   *PL*synth*_100

	* Placebo Average Treatment effects
	local placebosfor_P99_56  "9    13  14  17  28  29  35  38  39  41  43  46  55  59  60  62  65  67  72  74  79  84  88  89  91  92  97  100 102 107 115 126 129 138 139 146 147 149 151 153 154 159 160 173 182 185 187 188 195 200 201 212 214"
	local placebosfor_P99_85  "9	13	14	17	28	29	35	38	39	41	43	46	55	59	60	62	65	67	72	74	79	84	88	89	91	92	97	100	102	107	115	126	129	138	139	146	147	149	151	153	154	159	160	173	182	185	187	188	195	200	201	212	214"

	* Rename for Reshape
	
	rename  gdppccteus_56_PL0synth_100 gdppccteus_b100synth_56_PL0
	foreach pl of numlist `placebosfor_P99_56'{
			rename  gdppccteus_56_PL`pl'synth_100 gdppccteus_b100synth_56_PL`pl'
	}
	rename  gdppccteus_85_PL0synth_100 gdppccteus_b100synth_85_PL0
	foreach pl of numlist `placebosfor_P99_85'{
			rename  gdppccteus_85_PL`pl'synth_100 gdppccteus_b100synth_85_PL`pl'
	}
	
	drop gdppccteus_93_PL0synth_100
	drop gdppccteus_145_PL0synth_100
	
	  reshape long  gdppccteus_b100synth_56_PL  gdppccteus_b100synth_85_PL                                                         , i(YearsFromLD) j(Placebo)

	sort  YearsFromLD Placebo
	save	 gdppccteus_Placebos_synthetic_P99-NoRev.dta, replace

	restore

use gdppccteus_Placebos_P99-NoRev.dta
merge YearsFromLD Placebo using gdppccteus_Placebos_synthetic_P99-NoRev.dta

* Computes Differences

foreach num of numlist 56 85 {
		gen diff_b100_`num' = gdppccteus_b100_`num'_PL - gdppccteus_b100synth_`num'_PL
}


keep YearsFromLD Placebo diff_b100_56-diff_b100_85
saveold diffs_Placebos_P99-NoRev.dta, replace