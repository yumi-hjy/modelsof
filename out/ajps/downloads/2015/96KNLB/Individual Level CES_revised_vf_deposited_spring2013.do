clear
clear matrix
**creating user ID
gen RANK=runiform()
egen ID=rank(RANK), unique 


gen ELECTION2006=0 if ces06_pes_a1==.
replace ELECTION2006=1 if ces06_pes_a1~=.

gen ELECTION2008=0 if ces08_pes_a1==.
replace ELECTION2008=1 if ces08_pes_a1~=.
gen gov=0 if lib2006==0 & ELECTION2006==1
replace gov=0 if con2008==0  & ELECTION2008==1
replace gov=1 if lib2006==1 & ELECTION2006==1
replace gov=1 if con2008==1 & ELECTION2008==1

label variable lib2006 "Government Incumbent 2006"
label variable con2008 "Government Incumbent 2008"
label variable INCUMBENTLIKE06 "Incumbent preferred locally 2006"
label variable INCUMBENTLIKE08 "Incumbent preferred locally 2008"
label variable p2p2006 "Proposal power 2006"
label variable p2p2008 "Proposal power 2008"
label define YN 0 "No" 1 "Yes"


label values  lib2006 con2008 INCUMBENTLIKE06 INCUMBENTLIKE08 p2p2006 p2p2008 YN

tab INCUMBENTLIKE06 p2p2006 if lib2006==1 & ELECTION2006==1, col chi

**final result for table in paper is calculated by hand based on two results immediately above

*							No propose		Propose
*~prefer incumbemt			427 (75.7%)		216 (65.9%)
*prefer incumbent			137 (24.3%)		112 (34.1%)

* chi-squared: 10.1, p=.002
* Yates':		9.53, p=.002

