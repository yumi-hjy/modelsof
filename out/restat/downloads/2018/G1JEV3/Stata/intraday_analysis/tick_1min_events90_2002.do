/* 1)���the S&P 500 cash index back to 1983 (symbol SP)
2)����� futures data for the U.S. 10-year T-note back to 1983 (symbol TY)
3)����� futures data for the U.S. 5-year T-note back to 1988 (symbol FV)
4)����� futures data for the U.S. 2-year T-note back to 1991 (symbol TU)
5)����� volume on E-mini S&P500 futures (ES?)
6)����� data for the VIX index back to 2003 (symbol IAP)
7)�� data on the Eurodollar futures contract (symbol is ED). */

use "$path1\\AnnouncementReleases90.dta", clear // Hour, minute, date of FOMC Events
g year = year(Meetingdate)
g month = month(Meetingdate)
g day = day(Meetingdate)
g hh_GW= hh(TimeofannouncementGorodniche)
g mm_GW = mm(TimeofannouncementGorodniche)
g date_day = Meetingdate
format %td date_day
g FOMC_unscheduled1=0
replace FOMC_unscheduled1=1 if Meetingtype=="U"
keep year-day date_day FOMC_unscheduled1 *_GW
order date_day year-day FOMC_unscheduled1
save "$path1\\AnnouncementReleases1_90.dta", replace

set more off
clear
import delimited "$path2\output\1m intraday observations\\SP_1.csv"
g date_day = date(date, "MDY")
format %td date_day
g hour = substr(time,1,2)
g minute = substr(time,4,5)
destring hour minute, force replace
drop date time
capture recode volume 0=.
foreach var of varlist open-tickcount {
rename `var' SP_`var' 
}
save "$path3\\Tick_1min_events90.dta", replace
forv x=2/4 {
clear
import delimited "$path2\output\1m intraday observations\\SP_`x'.csv"
g date_day = date(date, "MDY")
format %td date_day
g hour = substr(time,1,2)
g minute = substr(time,4,5)
destring hour minute, force replace
drop date time
capture recode volume 0=.
foreach var of varlist open-tickcount {
rename `var' SP_`var' 
}
joinby date_day hour minute using "$path3\\Tick_1min_events90.dta", unmatched(both) update
drop _merge
save "$path3\\Tick_1min_events90.dta", replace
}
//

local vars1 "TY FV TU ES IAP ED" // 
foreach x of local vars1 {
clear
import delimited "$path2\output\1m intraday observations\\`x'.csv"
g date_day = date(date, "MDY")
format %td date_day
g hour = substr(time,1,2)
g minute = substr(time,4,5)
destring hour minute, force replace
drop date time
capture recode volume 0=.
foreach var of varlist open-tickcount {
rename `var' `x'_`var' 
}
joinby date_day hour minute using "$path3\\Tick_1min_events90.dta", unmatched(both) update
drop _merge
save "$path3\\Tick_1min_events90.dta", replace
}
g year = year(date_day)
g month = month(date_day)
g day = day(date_day)
order date_day hour minute day month year, first
save "$path3\\Tick_1min_events90.dta", replace

use "$path3\\Tick_1min_events90.dta", clear // Merge TickData with Dissent and FOMC Events
joinby date_day using "$path1\\FED_dissent_date.dta", unmatched(both) update
tab _merge
drop _merge
joinby date_day using "$path1\\AnnouncementReleases1.dta", unmatched(master) update
tab _merge
drop _merge
joinby date_day using "$path1\\FED_dissent90_94.dta", unmatched(master) update
tab _merge
drop _merge
joinby date_day using "$path1\\AnnouncementReleases1_90.dta", unmatched(master) update
tab _merge
drop _merge //drop if year<1993 //No press statements before then
drop if year>2002
drop if year==2002 & month>=3
compress
save "$path3\\Tick_1min_events_dissent90.dta", replace