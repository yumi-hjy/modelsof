**** PREP FAO DATA *****

clear
import excel "data/FAOSTAT_consumer_prices_dld_120313.xlsx", sheet("Sheet1") firstrow

gen month = .
replace month = 1 if element == "January"
lab def month 1 "January" 2 "February" 3 "March" 4 "April" 5 "May" 6 "June" 7 "July" 8 "August" 9 "September" 10 "October" 11 "November" 12 "December"
lab val month month

gen time = ((year - 1960) * 12) + (month - 1)
format time %tmMon_CCYY

gen int iso_num = .

replace iso_num = 012 if countries == "Algeria"
replace iso_num = 736 if countries == "South Sudan, Funafuti"

rename ConsumerPricesFoodIndices2 food_price
rename ConsumerPricesGeneralIndices gen_price

replace food_price = food_price * 1000  if iso_num == 716 & year >= 2005
replace food_price = gen_price * 1000 if iso_num == 716 & year >= 2005

order iso_num countries countrycodes elementCode year month time food_price gen_price
collapse (mean) food_price gen_price, by(iso_num time)

xtset iso_num time
gen food_chg = (food_price - l.food_price) / l.food_price * 100
gen gen_chg = (gen_price - l.gen_price) / l.gen_price * 100

*tempfile `faostat'
save "data/fao_consumer_price_recode.dta", replace