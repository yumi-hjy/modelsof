***************************************************
** Data Management for 
** Emigrants and the Onset of Civil Conflict
**
** Gina Miller
** glmiller1118@gmail.com
** &
** Emily Hencken Ritter
** eritter@ucmerced.edu
**
** File name: emigrants_datamanagement_final.do
** Purpose: Dataset creation/management for above article
** Output file(s): diaspora_state_1960-2009.dta
**
** Last updated: August 8, 2013
**
***************************************************

clear
clear matrix
set mem 700m
cd "/Users/emilyritter/Dropbox/Active projects/Diasporas/Data" // Office
*cd "/Users/erhritter/Dropbox/Active projects/Diasporas/Data"  // Laptop

/*
**************

Bilateral dataset to weight for rights and INGOs hypotheses, and from which to create an origin state-year level dataset

Diaspora & remittances data from the World Bank. 
Source: World Bank Global Bilateral Migration Database, last updated 2011, downloaded February 8, 2013 from 
http://data.worldbank.org/data-catalog/global-bilateral-migration-database

Migrants in actual numbers, data available at the directed-dyad-decade level of analysis.

Summary from GBMD website:
Global matrices of bilateral migrant stocks spanning the period 1960-2000, disaggregated by gender and based primarily on the foreign-born 
concept are presented. Over one thousand census and population register records are combined to construct decennial matrices corresponding 
to the last five completed census rounds. For the first time, a comprehensive picture of bilateral global migration over the last half of 
the twentieth century emerges. The data reveal that the global migrant stock increased from 92 to 165 million between 1960 and 2000. 
South-North migration is the fastest growing component of international migration in both absolute and relative terms. The United States 
remains the most important migrant destination in the world, home to one fifth of the world�s migrants and the top destination for migrants 
from no less than sixty sending countries. Migration to Western Europe remains largely from elsewhere in Europe. The oil-rich Persian Gulf 
countries emerge as important destinations for migrants from the Middle East, North Africa and South and South-East Asia. Finally, although 
the global migrant stock is still predominantly male, the proportion of women increased noticeably between 1960 and 2000.

**************
*/

*Input raw dyadic data
insheet using "Dyadic Global Migration Database/dyadic migration data by decade and gender.csv", comma clear

*Reshape to dyadic form
keep if mig_code=="TOT"
drop yearcode mig_name mig_code
renvars _all, prefix(mig_)
renvars mig_year mig_country_name mig_country_code \ year name wbcode
reshape long mig_, i(wbcode year) j(host) string

*Name and label variables
rename mig_ mig
label var mig migrants
rename name origin
label var origin "Origin/Source State"
label var host "Host/Recipient State"
label var wbcode "Origin State WB Code"

*add identifier codes to origin state
kountry wbcode, from(iso3c) to(cown)
*do cowcodesstandard.do to create ccodes
tab origin if ccode==.
replace ccode=345 if origin=="Serbia and Montenegro"
replace ccode=347 if origin=="Kosovo"
replace ccode=860 if origin=="Timor-Leste"
drop if ccode==.
drop NAMES_STD
rename ccode ccode1
label var ccode1 "Origin State COW Code"

*add identifier codes to host state
kountry host, from(other) m
*do cowcodesstandard.do to create ccodes
tab host if ccode==.
replace ccode=991 if host=="americansamoa"
replace ccode=58 if host=="antiguaandbarbuda"
replace ccode=346 if host=="bosniaandherzegovina"
replace ccode=835 if host=="bruneidarussalam"
replace ccode=439 if host=="burkinafaso"
replace ccode=402 if host=="capeverde"
replace ccode=482 if host=="centralafricanrepublic"
replace ccode=490 if host=="congodemrep"
replace ccode=484 if host=="congorep"
replace ccode=437 if host=="cotedivoire"
replace ccode=316 if host=="czechrepublic"
replace ccode=42 if host=="dominicanrepublic"
replace ccode=651 if host=="egyptarabrep"
replace ccode=92 if host=="elsalvador"
replace ccode=411 if host=="equatorialguinea"
replace ccode=711 if host=="hongkongsarchina"
replace ccode=360 if host=="iranislamicrep"
replace ccode=731 if host=="koreademrep"
replace ccode=732 if host=="korearep"
replace ccode=347 if host=="kosovo"
replace ccode=703 if host=="kyrgyzrepublic"
replace ccode=812 if host=="laopdr"
replace ccode=343 if host=="macedoniafyr"
replace ccode=920 if host=="newzealand"
replace ccode=910 if host=="papuanewguinea"
replace ccode=365 if host=="russianfederation"
replace ccode=331 if host=="sanmarino"
replace ccode=403 if host=="saotomeandprincipe"
replace ccode=670 if host=="saudiarabia"
replace ccode=345 if host=="serbiaandmontenegro"
replace ccode=451 if host=="sierraleone"
replace ccode=317 if host=="slovakrepublic"
replace ccode=560 if host=="southafrica"
replace ccode=780 if host=="srilanka"
replace ccode=940 if host=="solomonislands"
replace ccode=60 if host=="stkittsandnevis"
replace ccode=56 if host=="stlucia"
replace ccode=57 if host=="stvincentandthegrenadines"
replace ccode=652 if host=="syrianarabrepublic"
replace ccode=713 if host=="taiwanchina"
replace ccode=860 if host=="timorleste"
replace ccode=52 if host=="trinidadandtobago"
replace ccode=696 if host=="unitedarabemirates"
replace ccode=200 if host=="unitedkingdom"
replace ccode=2 if host=="unitedstates"
replace ccode=101 if host=="venezuelarb"
replace ccode=667 if host=="westbankandgaza"
replace ccode=679 if host=="yemenrep"
tab host if ccode==.
drop if ccode==.
drop NAMES_STD MARKER
rename ccode ccode2
label var ccode2 "Host State COW Code"

*Label and save BILATERAL data
order year ccode1 origin wbcode ccode2 host mig
drop if ccode1==ccode2
sort ccode1 ccode2 year
label data "Bilateral Migration Data from World Bank, 1960-2000, directed-dyad-decade"
save bilateralmigrants1960-2000.dta, replace

*Collapse to create emigration (total stock) data
use bilateralmigrants1960-2000.dta, clear
sort ccode1 year ccode2
collapse (sum) mig, by(ccode1 year)
*985 state-year observations
rename mig totalmig
label var totalmig "Total number of emigrants from source country"
rename ccode1 ccode
order ccode year
label data "Total Migrant Stock by Origin State, 1960-2000, origin state-year"
sort ccode year
save diaspora_total_1960-2000.dta, replace

*expand to include other years of data
use diaspora_total_1960-2000, clear
expand 10
sort ccode year
by ccode year: replace year = year[_n-1]+1 if year[_n-1]>=1960 & year[_n-1]!=. 

*create lags
gen yearst=string(year)
gen totalmigl1=totalmig
replace totalmigl1=. if regexm(yearst, "^([0-9][0-9][0-9][0,2-9])")
gen totalmigl2=totalmig
replace totalmigl2=. if regexm(yearst, "^([0-9][0-9][0-9][0-1,3-9])")
gen totalmigl3=totalmig
replace totalmigl3=. if regexm(yearst, "^([0-9][0-9][0-9][0-2,4-9])")
gen totalmigl4=totalmig
replace totalmigl4=. if regexm(yearst, "^([0-9][0-9][0-9][0-3,5-9])")
gen totalmigl5=totalmig
replace totalmigl5=. if regexm(yearst, "^([0-9][0-9][0-9][0-4,6-9])")
replace totalmig=. if regexm(yearst, "^([0-9][0-9][0-9][1-9])")
*Migration data is skewed: ln to normalize.
gen lnmig=ln(totalmig)
label var lnmig "Total Migration, ln, WB"
gen lnmig1=ln(totalmigl1)
label var lnmig1 "Total Migration, ln, Lagged 1 year, WB"
gen lnmig2=ln(totalmigl2)
label var lnmig2 "Total Migration, ln, Lagged 2 years, WB"
gen lnmig3=ln(totalmigl3)
label var lnmig3 "Total Migration, ln, Lagged 3 years, WB"
label var lnmig "Total Migration, ln, WB"
label var totalmigl1 "Total Migration, Lagged 1 year, WB"
label var totalmigl2 "Total Migration, Lagged 2 year, WB"
label var totalmigl3 "Total Migration, Lagged 3 year, WB"
label var totalmigl4 "Total Migration, Lagged 4 year, WB"
label var totalmigl5 "Total Migration, Lagged 5 year, WB"
drop yearst

label data "State-year data for -Emigrants & CW-, March 2013"

sort ccode year
save diaspora_state_1960-2009.dta, replace

/*
**************

Conflict Data from the UCDP/PRIO Armed Conflict Dataset v.4-2011, 1946 � 2010
Source: updated 29 July 2011, downloaded October 30, 2011 from http://www.pcr.uu.se/research/ucdp/datasets/ucdp_prio_armed_conflict_dataset/

**************
*/
/*
insheet using "UCDP/ArmedConflictDataset_v42011.csv", comma clear
save UCDP/civconflict.dta, replace
*keep only internal conflict
drop if type==1 
drop if type==2
drop sidea2nd sideb2nd 
drop version
compress
gen internal = 1
gen startyear = ""
replace startyear = regexs(1) if regexm(startdate2, "^([0-9][0-9][0-9][0-9])")
destring startyear, replace
label var startyear "Year the current episode of civil war reached 25 battle deaths in a year"
gen onset = 0
replace onset = 1 if startyear==year
*62 instances of onset
rename gwnoa ccode
destring ccode, replace
sort id
by id: gen ccchange = 0
by id: replace ccchange = 1 if intensity>intensity[_n-1] & intensity[_n-1]!=.
replace ccchange = 1 if onset==1
label var onset "1 if the civil war FIRST reached 25 battle deaths in that year, 0otherwise"
label var ccchange "Equals 1 if the intensity of the civil war increased from the previous year"
*76 instances of change and/or onset
order id sidea year ccode startdate2 startyear onset ccchange intensity 
duplicates tag ccode year, gen(d)
*quite a few duplicates b/c more than one internal conflict in a year.
gsort ccode year -onset -ccchange
duplicates drop ccode year, force
drop d
duplicates tag ccode year, gen(d)
*keep the duplicates that are onset or changes that occur soonest after the 2005 data.
*gsort ccode year startyear
*duplicates drop ccode year, force
drop d
sort ccode year
save UCDP/civconflictallyears.dta, replace
*/

*merge into state-year dataset
use diaspora_state_1960-2009.dta, clear
sort ccode year
merge 1:1 ccode year using UCDP/civconflictallyears.dta
sort ccode year
drop if ccode<2
drop if year<1960
drop if year>2009
drop if _merge==2
*If the observation is missing for onset or ccchange, that means UCDP recorded no conflict in that year for that state. Fill in the blanks.
replace onset=0 if onset==.
replace ccchange=0 if ccchange==.
replace intensity=0 if intensity==.
replace internal=0 if internal==.
label var id "UCDP ID"
label var intensity "UCDP Intensity"
label var cumint "UCDP Cumulative Intensity"
label var type "UCDP Type"
label var internal "Equals 1 if civil war starts or continues in that year"
label var onset "Equals 1 if civil war starts in that year"
drop _merge gwnoa2nd gwnob gwnob2nd gwnoloc startyear sidebid sidea sideb incomp startprec startprec2 epend ependdate ependprec region location terr startdate startdate2
sort ccode year
save diaspora_state_1960-2009.dta, replace

/*
**************

Control variables:
1. Dichotomous indicator as to whether the state was formerly a colony of a Western power. Data from Hadenius and Toerell 2005, obtained
November 30, 2011 from Quality of Government Institute (version April 6, 2011). Cite Moore and Shellman. diaspora more likely in former colonizer, 
and civil conflict more likely because institutions unstable---most likely to see our effects in these cases
2. Civil war in the previous 5 years. past CW makes people more likely to leave AND causes recidivism. Cite Fearon, Collier & Hoeffler.
3. GDPpc (World Bank)

**************
*/

*** FORMER COLONY

/*
use "/Users/emilyritter/Documents/data/QoG/QoG_t_s_v6Apr11.dta", clear
keep ccodecow ccodewb year ht_colonial
rename ccodecow ccode
duplicates tag ccode year, gen(d)
keep if d==0 | ccodewb=="PAK" | ccodewb=="VNM" | ccodewb=="RUS" | ccodewb=="ETH" | ccodewb=="SRB" 
drop d
sort ccode year
save colony, replace
*/

use diaspora_state_1960-2009.dta, clear
merge 1:1 ccode year using colony
generate colony=.
replace colony=1 if ht_colonial>0 & ht_colonial!=.
replace colony=0 if ht_colonial==0
label var colony "Equals 1 if state was a colony of any Western power, 0 otherwise"
drop if year<1960
drop if year>2009
drop if _merge==2
drop _merge
sort ccode year
save diaspora_state_1960-2009.dta, replace

***PREVIOUS CIVIL WAR

gen prevcw5yr=0
sort ccode year
by ccode: replace prevcw5yr=1 if internal[_n-1]==1 | internal[_n-2]==1 | internal[_n-3]==1 | internal[_n-4]==1 | internal[_n-5]==1
label var prevcw5yr "Civil war in any of the five years prior"
sort ccode year
save diaspora_state_1960-2009.dta, replace

*** GDPpc and population

/*
use "/Users/emilyritter/Documents/data/Capacity/WDI_GDP", clear
rename cowcode ccode
replace ccode=316 if ccode==315 
replace ccode=255 if ccode==260 
sort ccode year
save wdipop, replace
*/

use diaspora_state_1960-2009.dta, clear
merge 1:1 ccode year using wdipop
drop if _merge==2
drop _merge country
gen lnwdipop=ln(populationtotal)
gen lngdppc=ln(gdppc)
label var populationtotal "Total Population, WDI"
label var lnwdipop "Total Population, ln, WDI"
label var lngdppc "GDP per capita, ln, WDI"
label var gdp "GDP, WDI"
label var gdppc "GDP per capita, WDI"
label var gdppcppp "GDP per capita, purchasing power parity, WDI"
sort ccode year
save diaspora_state_1960-2009.dta, replace

/*
**************

Independent variable of interest: Remittances

Remittances in millions of current US dollars
Downloaded on March 4, 2013 from http://go.worldbank.org/092X1CHHD0
Inflows or outflows only, but H2 does not require info about host states for hypothesis testing. 

Final data: Origin State-year from 1970 to 2011
File name: remitstock1970-2011.dta

**************
*/

/*
insheet using "Remittances/RemittancesData_Inflows_Nov12.csv", comma names clear
renvars v2-v43 \ rem1970-rem2011
rename migrantremittanceinflowsusmillio state
keep state rem*
drop remittancesasashareofgdp2011
set more off
destring rem*, replace ignore(",") force
drop if state==""
reshape long rem, i(state) j(year)
rename rem remit
label var remit "Remittance inflows from World Bank, 1970-2011"
rename state origin
label var origin "State of Migrant Origin"
save remit1970-2011, replace

*add identifier codes

use remit1970-2011, clear
kountry origin, from(other) m
tab origin if MARKER==0
replace NAMES_STD ="Cote d'Ivoire" if origin =="C�te d'Ivoire"
replace NAMES_STD ="Hong Kong" if origin =="Hong Kong SAR, China"
replace NAMES_STD ="Kosovo" if origin =="Kosovo"
replace NAMES_STD ="Korea, Dem. Rep." if origin =="Korea, Dem. Rep."
replace NAMES_STD ="Sao Tome and Principe" if origin =="S�o Tom� and Principe"
*do cowcodesstandard.do to create ccodes
tab origin if ccode==.
replace ccode=    860    if origin=="Timor-Leste"
drop if ccode==.
drop NAMES_STD MARKER
label var ccode "Migrant Origin State COW Code"
label var year "Year"
order ccode year
save remit1970-2011, replace

*Lag and log remittance data
sort ccode year
by ccode: gen remitlag1=remit[_n-1]
by ccode: gen remitlag2=remit[_n-2]
by ccode: gen remitlag3=remit[_n-3]
label var remitlag1 "Total Remittances (stocks), Lagged 1 year, WB"
label var remitlag2 "Total Remittances (stocks), Lagged 2 year, WB"
label var remitlag3 "Total Remittances (stocks), Lagged 3 year, WB"
gen lnrem=ln(remit)
sort ccode year
by ccode: gen lnremitlag1= lnrem[_n-1]
by ccode: gen lnremitlag2= lnrem[_n-2]
by ccode: gen lnremitlag3= lnrem[_n-3]
label var lnrem "Total Remittances (stocks), ln, WB"
label var lnremitlag1 "Total Remittances (stocks), ln, Lagged 1 year, WB"
label var lnremitlag2 "Total Remittances (stocks), ln, Lagged 2 year, WB"
label var lnremitlag3 "Total Remittances (stocks), ln, Lagged 3 year, WB"

label data "Total Remittance Inflows by Origin State, 1970-2011, state-year"
sort ccode year
save remittances1970-2011, replace
*save remitstock1970-2011.dta, replace
*/

*merge into state-year dataset
use diaspora_state_1960-2009.dta, clear
sort ccode year
merge 1:1 ccode year using remittances1970-2011
sort ccode year
drop if year>2009
drop _merge
sort ccode year
save diaspora_state_1960-2009.dta, replace

/*
**************

Independent variable of interest: proportion of migrants living in states with better rights protection than the state of origin

Human Rights data from Cingranelli and Richards, downloaded December 11, 2011
Use the CIRI data to account for the (a) human rights score for home states and (b) for host states.

**************
*/

*Merge in total migrant data so we can see what proportion of the whole network is living in that host state.
use bilateralmigrants1960-2000.dta, clear
rename ccode1 ccode
rename ccode2 ccodehost
merge m:1 ccode year using diaspora_total_1960-2000.dta
label var mig "Migrants from the Origin State living in the Host State, WB"
drop _merge
gen migprop=.
replace migprop=mig/totalmig
label var migprop "Proportion of emigrants in host state of the total emigrants from origin"
expand 10
sort ccodehost ccode year
by ccodehost ccode year: replace year = year[_n-1]+1 if year[_n-1]>=1960 & year[_n-1]!=. 
save bilateralmigrants1960-2000expanded.dta, replace

/*
insheet using "/Users/emilyritter/Documents/Data/Repression/CIRI/ciridec11-2011.csv", clear comma
drop v29
rename cow ccode 
duplicates tag ccode year, gen(d)
replace ctry="Srpska" if (ctry=="Serbia" & year>2005) | (ctry=="Serbia and Montenegro" & year>2002 & year<2006) | (ctry=="Yugoslavia, Federal Republic of" & year<2003)
keep if d==0 | (ctry=="Russia" | ctry=="Srpska")
replace ccode=345 if ccode==.
drop ctry ciri polity unctry unreg unsubreg d
renvars, pref(home)
rename homeyear year
rename homeccode ccode
sort ccode year
save cirihome, replace

insheet using "/Users/emilyritter/Documents/Data/Repression/CIRI/ciridec11-2011.csv", clear comma
drop v29
rename cow ccode 
duplicates tag ccode year, gen(d)
replace ctry="Srpska" if (ctry=="Serbia" & year>2005) | (ctry=="Serbia and Montenegro" & year>2002 & year<2006) | (ctry=="Yugoslavia, Federal Republic of" & year<2003)
keep if d==0 | (ctry=="Russia" | ctry=="Srpska")
replace ccode=345 if ccode==.
drop ctry ciri polity unctry unreg unsubreg d
renvars, pref(host)
rename hostyear year
rename hostccode ccodehost
sort ccodehost year
save cirihost, replace
*/

/*
* Merge home and host rights records into dyadic data so that they can be compared.
use bilateralmigrants1960-2000expanded.dta, clear
drop if year<1981 // because CIRI doesn't start til 1981
sort ccode year
merge m:1 ccode year using cirihome
drop if _merge==2
drop _merge
sort ccodehost year
merge m:1 ccodehost year using cirihost
drop if _merge==2
drop _merge
sort ccode ccodehost year

* Create a variable that indicates whether the host state has better or worse rights practices than the home state
gen relrep=.
replace relrep=0 if homephysint!=. & hostphysint!=.
replace relrep=1 if hostphysint>homephysint & homephysint!=. & hostphysint!=.
label var relrep "Relative Repression, =1 if host state has better physint practices than home state, 0 otherwise"
order migprop homephysint hostphysint, before(relrep)
tab relrep, missing

* Weight that variable by the relative stock in the host state
gen relrepweight=.
replace relrepweight=relrep*migprop 
order migprop homephysint hostphysint relrep relrepweight, after(totalmig)
* Collapse by home state - year to see the proportion of the diaspora that is in host states with better rights practices than the home state
sort ccode ccodehost year
collapse (sum) relrepweight (mean) homephysint hostphysint, by(ccode year)
*so, I'm not sure why some of these (10) sum to greater than 1, but they tend to be conflict-prone states. 
drop if year>2010
replace relrepweight=. if homephysint==.
label var relrepweight "Relative Repression: proportion of the diaspora in host states with better rights protection than the home state"
gen better=.
replace better=0 if relrepweight!=.
replace better=1 if relrepweight>.5 & relrepweight!=.
label var better "Equals 1 if more than 50% of migrants in states with better practices than home"
sort ccode year
save relrep1980-2010, replace
*/

*Merge into state-year data
use diaspora_state_1960-2009.dta, clear
merge 1:1 ccode year using relrep1980-2010
drop if year>2009 // because migration data doesn't include 2010
drop _merge 
sort ccode year
save diaspora_state_1960-2009.dta, replace

/*
**************

H3: Political activity in host states

Data on HROs with local membership from Smith and Weist 2012, downloaded March 11, 2013 from ICPSR, recommended by Amanda Murdie

**************
*/

*Finally, Smith and Weist (2012) data, downloaded from ICPSR 11 March 2013. Intl Organizations from 1953-2003.
use "SmithWeist2012\smithweist2012", clear
*keep only human rights organizations
drop if SMI_RIGHTS!=1
drop CASEID CASEID ORGNAME SERIESID FIRSTCASE_FLAG
drop PERIOD PERIOD PERIOD_FLAG YEARBOOKID FOUNDYR DECADE YEARS_ALIVE DEAD FOUNDED_AFTER_1990 FOUNDED_AFTER_1980 AGE REGIONAL_BREAKDOWN GOAL1 GOAL2 GOAL3 GOAL4 SMI SMI_ENVIRO
drop SMI_WOMEN WOMENMOB SMI_DEVELOPMENT SMI_PEACE SMI_DEMOCRACY SMI_JUSTICE HEADQUARTERS_1 HEADQUARTERS_2 HEADQUARTERS_TXT BUDGET STAFF_NUM VOL_NUM EVENTS FINANCE_SELF FINANCE_FOUNDS FINANCE_CORPS FINANCE_GOVIGO FINANCE_OTHR MEMBERS_1 MEMBERS_2 MEMBERS_3 MEMBERS_4 MEMBERS_5 IDENT_1 IDENT_2 IGONUM NGONUM IGO1 IGO2 IGO3 IGO4 IGO5 IGO6 CONS1 CONS2 CONS3 CONS4 CONS5 CONS6 CONS7 CONS8 CONS9 CONS10 CONS_TXT IGO_TXT
renvars _all, prefix(state)
rename stateYEAR year
drop stateSMI_RIGHTS
sort year
collapse (sum) state*, by(year)
tsset year
tsfill
set more off
reshape long state, i(year) j(name) string
rename state hrolm
sort name year
by name: ipolate hrolm year, gen(hrolm_filled)
*round the interpolated numbers, so they represent a possible number of INGOs with local memberships
replace hrolm_filled=round(hrolm_filled,1)
kountry name, from(other) m
tab name if MARKER==0
replace NAMES_STD="Afghanistan" if name=="AFGHANIS"
*do cowcodesstandard.do
tab name if ccode==.
tab hrolm if ccode==.
drop if ccode==.
compress
order ccode year
duplicates tag ccode year, gen(d)
sort ccode name year
drop if name=="SERBIA" | name=="USSR" | name=="ZAIRE" | name=="RHODESIA" | name=="YEMEN_REP" | name=="CEYLON"
drop name NAMES_STD MARKER d
drop hrolm
sort ccode year
save sw_hros-53-03, replace

use sw_hros-53-03, clear
rename ccode ccodehost
rename hrolm_filled hosthrolm_filled
sort ccodehost year
save host-sw_hros-53-03, replace

* Merge into dyadic data to weight it.
use bilateralmigrants1960-2000expanded.dta, clear
drop if year>2009 | year<1960
merge m:1 ccode year using sw_hros-53-03
drop if year>2009 | year<1960
drop if _merge==2
drop _merge
sort ccodehost year
merge m:1 ccodehost year using host-sw_hros-53-03
drop if year>2009 | year<1960
drop if _merge==2
drop _merge
sort ccode ccodehost year
save swhrosmigrants, replace

*Create the weighted variable
gen lnhosthrolm_filled=ln(hosthrolm_filled)
gen migswHROlm1=.
replace migswHROlm1=lnhosthrolm_filled*migprop
gen migswHROlm2=.
replace migswHROlm2=hosthrolm_filled*migprop
gen binhostswHROlm=.
replace binhostswHROlm=0 if hosthrolm_filled!=.
replace binhostswHROlm=1 if hosthrolm_filled>0 & hosthrolm_filled!=.
gen migswHROlm3=.
replace migswHROlm3=binhostswHROlm*migprop
label var hrolm_filled "Smith & Weist HRO local membership in home states"
label var hosthrolm_filled "Smith & Weist HRO local membership in host states"
label var lnhosthrolm_filled "Smith & Weist HRO local membership in host states (ln)"
label var binhostswHROlm "Smith & Weist HRO local membership in host states (binary)"
label var migswHROlm1 "Smith & Weist HRO local membership in host states (ln) relative to prop of migrant stock"
label var migswHROlm2 "Smith & Weist HRO local membership in host states relative to prop of migrant stock"
label var migswHROlm3 "Smith & Weist HRO local membership in host states (binary) relative to prop of migrant stock"

sort ccode ccodehost year
collapse (sum) migswHROlm1 migswHROlm2 migswHROlm3 (mean) hrolm_filled, by(ccode year)
label var hrolm_filled "Smith & Weist HRO local membership in home states"
label var migswHROlm1 "Smith & Weist HRO local membership in host states (ln) relative to prop of migrant stock"
label var migswHROlm2 "Smith & Weist HRO local membership in host states relative to prop of migrant stock"
label var migswHROlm3 "Smith & Weist HRO local membership in host states (binary) relative to prop of migrant stock"
sort ccode year
replace migswHROlm1=. if year>2003
replace migswHROlm2=. if year>2003
replace migswHROlm3=. if year>2003
sort ccode year
by ccode: gen mighroslag1= migswHROlm1[_n-1]
by ccode: gen mighroslag2= migswHROlm1[_n-2]
sort ccode year
save swhrosmigrants, replace

*AND NOW BACK TO THE STATE-YEAR DATASET

use diaspora_state_1960-2009.dta, clear
sort ccode year
merge 1:1 ccode year using swhrosmigrants 
drop if _merge==2
drop _merge
sort ccode year
save diaspora_state_1960-2009.dta, replace

/*
**************

End of do-file

**************
*/