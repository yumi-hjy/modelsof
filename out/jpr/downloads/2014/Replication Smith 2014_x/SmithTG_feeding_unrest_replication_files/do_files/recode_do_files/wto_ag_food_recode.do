*** PREP WTO AG AND FOOD TRADE DATA ***

clear
insheet using "data/raw_data/WTO_africa_ag_food_trade_dld120327.csv", comma

encode flow_desc, gen(flow)
encode indicator_desc, gen(indicator)
encode reporter_desc, gen(country)
rename reporter_code iso2

drop topic_code topic_desc dataset_code dataset_desc flow_code flow_desc indicator_code indicator_desc reporter_desc partner_code partner_desc unit_code unit_desc notes_export value_flag

order country iso2 year indicator flow value

tempfile full
save `full'

drop if flow == 2

rename value exports
drop flow

tempfile exports
save `exports'

clear
use `full'

drop if flow == 1
drop flow 

rename value imports

merge 1:1 country year indicator using `exports'
drop _merge

lab var imports "Imports"
lab var exports "Exports"

tempfile `wto'
save wto, replace

drop if indicator == 1
rename imports ag_imp
lab var ag_imp "Agricultural Products Imports (current USD)"
rename exports ag_exp
lab var ag_exp "Agricultural Products Exports (current USD)"
drop indicator
sort country year

tempfile `ag'
save ag, replace

clear
use wto

drop if indicator == 2
rename imports food_imp
lab var food_imp "Food Imports (current USD)"
rename exports food_exp
lab var food_exp "Food Exports (current USD)"
drop indicator
sort country year

merge 1:1 country year using ag
drop _merge

drop if country == 18 & year == 1990
drop if country == 18 & year == 1991
drop if country == 18 & year == 1992

gen iso_num = .
replace iso_num = 	12	if country ==	1

sort country year

xtset iso_num year

gen ag_ratio = ag_exp / ag_imp
lab var ag_ratio "Ratio of Agricultural Products Exports to Imports"
gen food_ratio = food_exp / food_imp
lab var ag_ratio "Ratio of Food Exports to Imports"
gen py_ag_rat = l.ag_ratio
lab var py_ag_rat "Previous Year Ratio of Agricultural Products Exports to Imports"
gen py_food_rat = l.food_ratio
lab var py_food_rat "Previous Year Ratio of Food Exports to Imports"

gen py_food_imp = l.food_imp
gen py_food_exp = l.food_exp
gen py_ag_imp = l.ag_imp
gen py_ag_exp = l.ag_exp

gen food_bal = food_exp - food_imp
gen ag_bal = ag_exp - ag_imp
gen py_food_bal = l.food_bal
gen py_ag_bal = l.ag_bal

gen food_bal_mil = food_bal / 1000000
gen ag_bal_mil = ag_bal / 1000000

order iso_num country year
drop country iso2

quietly do "do_files/iso_code_define.do"

save "data/wto_ag_food.dta", replace

exit